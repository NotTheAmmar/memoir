import 'package:flutter/material.dart';
import 'package:flutter_exit_app/flutter_exit_app.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:memoir/classes/assets.dart';
import 'package:memoir/classes/container.dart' as my;
import 'package:memoir/classes/database.dart';
import 'package:memoir/classes/routes.dart';
import 'package:memoir/extensions.dart';
import 'package:memoir/screens/vault/widgets/containers_builder.dart';
import 'package:memoir/screens/vault/widgets/empty_vault.dart';
import 'package:memoir/sheets/new_container.dart';

/// Main Page of the Application
class VaultPage extends StatefulWidget {
  const VaultPage({super.key});

  @override
  State<VaultPage> createState() => _VaultPageState();
}

class _VaultPageState extends State<VaultPage> {
  /// Last time when back button was pressed
  ///
  /// Defaults to epoch
  DateTime _lastBackPressed = DateTime.fromMillisecondsSinceEpoch(0);

  /// Whether to allow the user to quit app
  bool _allowPop = false;

  /// [Future] of Containers from Database
  ///
  /// Initialized in [initState]
  late Future<List<my.Container>> _containers;

  @override
  void initState() {
    super.initState();

    _containers = SQLite.getContainers();
  }

  /// Implements the Press Back again to quit functionality
  ///
  /// if the user presses back two times within `2` seconds,
  /// the applications quits, otherwise does not let user quit
  void _onPopInvoked(bool didPop) {
    final DateTime now = DateTime.now();

    if (now.difference(_lastBackPressed) > const Duration(seconds: 2)) {
      _lastBackPressed = now;

      _allowPop = true;

      context.messenger.showSnackBar(const SnackBar(
        duration: Duration(seconds: 1, milliseconds: 500),
        showCloseIcon: true,
        content: Text("Press Back to Exit"),
      ));

      Future.delayed(const Duration(seconds: 2), () => _allowPop = false);
    } else {
      if (_allowPop) FlutterExitApp.exitApp();
    }
  }

  /// Fetches all the Containers from [SQLite] database and rebuilds the widget
  void _refreshContainers() {
    setState(() {
      // Do not use arrow Operator
      _containers = SQLite.getContainers();
    });
  }

  /// Pushing Settings Page on top
  void _navigateToSettings() {
    final Future result = context.navigator.pushNamed(Routes.settings);

    // result indicates whether to refresh homepage or not
    // occurs only when user imports containers in settings
    result.then((value) {
      if (value ?? false) _refreshContainers();
    });
  }

  /// Pushes `NewContainer` ModalBottomSheet
  void _showNewContainerSheet() {
    showModalBottomSheet<bool>(
      elevation: 10,
      isDismissible: false,
      isScrollControlled: true,
      showDragHandle: true,
      context: context,
      builder: (_) => const NewContainerSheet(),
    ).then(
      (needRefresh) {
        // true if user added a container otherwise false
        if (needRefresh != null && needRefresh) _refreshContainers();
      },
    );
  }

  /// [FutureBuilder] builder method
  Widget _futureBuilder(
    BuildContext context,
    AsyncSnapshot<List<my.Container>> snapshot,
  ) {
    if (snapshot.hasError) {
      throw FlutterError(snapshot.error.toString());
    }

    if (!snapshot.hasData) {
      return const Center(child: CircularProgressIndicator());
    }

    if (snapshot.data == null || snapshot.data!.isEmpty) {
      return const EmptyVault();
    }

    return ContainersBuilder(
      containers: snapshot.data!,
      refreshContainers: _refreshContainers,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: _onPopInvoked,
      child: Scaffold(
        appBar: AppBar(
          leading: Hero(
            // Linked with SetupMasterPasswordPage and LoginPage
            tag: 'Logo',
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Image.asset(Assets.logo),
            ),
          ),
          title: const Text("Memoir"),
          actions: [
            IconButton(
              tooltip: 'Settings',
              onPressed: _navigateToSettings,
              icon: const FaIcon(FontAwesomeIcons.gear),
            ),
          ],
        ),
        body: FutureBuilder<List<my.Container>>(
          initialData: const [],
          future: _containers,
          builder: _futureBuilder,
        ),
        floatingActionButton: FloatingActionButton(
          tooltip: "New Container",
          onPressed: _showNewContainerSheet,
          child: const FaIcon(FontAwesomeIcons.plus),
        ),
      ),
    );
  }
}
