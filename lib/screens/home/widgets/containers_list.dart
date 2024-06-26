import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:memoir/assets.dart';
import 'package:memoir/classes/container.dart' as my;
import 'package:memoir/extensions.dart';
import 'package:memoir/sheets/container.dart';

/// Widget that displays a list of [my.Container]
class ContainerList extends StatelessWidget {
  /// List of [my.Container] to display
  final List<my.Container>? containers;

  /// Callback to refresh the [HomePage] with new List of [my.Container]
  final VoidCallback refreshList;

  const ContainerList({
    super.key,
    required this.containers,
    required this.refreshList,
  });

  /// Pushes `[ContainerSheet]` on ModalBottomSheet
  void _showContainer(BuildContext context, my.Container container) {
    showModalBottomSheet<bool>(
      elevation: 10,
      isDismissible: false,
      isScrollControlled: true,
      showDragHandle: true,
      context: context,
      builder: (_) => ContainerSheet(container: container),
    ).then((updated) {
      // if `[updated]` is `true` then a container is updated,
      // if it is false then a container is deleted,
      // and if `null` then no changes to containers
      if (updated != null) {
        refreshList();

        if (updated) {
          context.messenger.showSnackBar(const SnackBar(
            content: Text("Container Updated"),
          ));
        }
      }
    });
  }

  /// Copies the password onto the Clipboard and shows Snackbar message on completion
  void _copyPassToClipboard(BuildContext context, String password) {
    final Future<void> result = Clipboard.setData(
      ClipboardData(text: password),
    );

    result.then((_) {
      context.messenger.showSnackBar(const SnackBar(
        duration: Duration(seconds: 3),
        showCloseIcon: true,
        content: Text("Password Copied to Clipboard!"),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    if (containers == null || containers!.isEmpty) {
      // Displays Empty Vault Message
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              Assets.emptyVault,
              width: context.mediaQuery.size.width * 0.5,
            ),
            const Gap(20),
            Text("Vault Empty!", style: context.textTheme.titleMedium),
            const Gap(10),
            Text(
              "Try adding new passwords from below",
              style: context.textTheme.bodySmall,
            )
          ],
        ),
      );
    }

    // Actual List
    return ListView.separated(
      itemCount: containers!.length,
      itemBuilder: (context, index) {
        return ListTile(
          contentPadding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          onTap: () => _showContainer(context, containers![index]),
          title: Text(
            containers![index].name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: IconButton(
            tooltip: 'Copy Password',
            onPressed: () => _copyPassToClipboard(
              context,
              containers![index].password,
            ),
            icon: const FaIcon(FontAwesomeIcons.solidCopy),
          ),
        );
      },
      separatorBuilder: (_, __) => const Divider(),
    );
  }
}
