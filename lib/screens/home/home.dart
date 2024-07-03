import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:memoir/classes/assets.dart';
import 'package:memoir/classes/container.dart' as my;
import 'package:memoir/classes/database.dart';
import 'package:memoir/extensions.dart';
import 'package:memoir/sheets/new_container.dart';
import 'package:memoir/screens/home/widgets/containers_list.dart';

/// Main Page of the Application
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  /// [Future] of Containers aka Passwords
  ///
  /// Initialized in [initState]
  late Future<List<my.Container>> _containers;

  @override
  void initState() {
    super.initState();

    _containers = SQLite.instance.getContainers();
  }

  /// Pushing Settings Page on top
  void _navigateToSettings() {
    // do annotate with type causes error, Fucking Stupid
    context.navigator.pushNamed('/settings').then((value) {
      // result indicates whether to refresh homepage or not
      // occurs only when user imports containers in settings
      final result = (value ?? false) as bool;

      if (result) _refreshContainers();
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

  /// Fetches all the Containers from [SQLite] database and rebuilds the widget
  void _refreshContainers() {
    setState(() {
      // Do not use arrow Operator
      _containers = SQLite.instance.getContainers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Hero(
              // Linked to SplashScreen Logo
              tag: 'Logo',
              child: CircleAvatar(backgroundImage: AssetImage(Assets.logo)),
            ),
            Gap(10),
            Text("Memoir"),
          ],
        ),
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
        builder: (_, snapshot) {
          if (snapshot.hasError) {
            throw FlutterError(snapshot.error.toString());
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          return ContainerList(
            containers: snapshot.data,
            refreshList: _refreshContainers,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: "New Container",
        onPressed: _showNewContainerSheet,
        child: const FaIcon(FontAwesomeIcons.plus),
      ),
    );
  }
}
