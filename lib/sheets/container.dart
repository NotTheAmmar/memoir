import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:memoir/classes/database.dart';
import 'package:memoir/classes/container.dart' as my;
import 'package:memoir/dialogs/confirm.dart';
import 'package:memoir/extensions.dart';
import 'package:memoir/sheets/edit_container.dart';
import 'package:memoir/sheets/widgets/sheet.dart';

/// Displays [my.Container] information in a ModalBottomSheet
class ContainerSheet extends StatefulWidget {
  /// Whose information to display
  final my.Container container;

  const ContainerSheet({super.key, required this.container});

  @override
  State<ContainerSheet> createState() => _ContainerSheetState();
}

class _ContainerSheetState extends State<ContainerSheet> {
  /// Whether password is visible or not
  bool _passVisibility = false;

  /// Pushes [EditContainerSheet] on a ModalBottomSheet
  void showEditContainerSheet(BuildContext context) {
    // Here bool refers to whether the Container was updated
    showModalBottomSheet<bool>(
      elevation: 10,
      isDismissible: false,
      isScrollControlled: true,
      showDragHandle: false,
      context: context,
      builder: (_) => EditContainerSheet(container: widget.container),
    ).then((result) {
      if (result ?? false) {
        // Popping true to show SnackBar message indicating container was updated
        context.navigator.pop(true);
      }
    });
  }

  /// Pops up [ConfirmDialog] on the screen
  void showConfirmDialog(BuildContext context) {
    // Here bool refers to whether to delete the container or not
    showDialog<bool>(
      barrierDismissible: false,
      context: context,
      builder: (_) => const ConfirmDialog(title: "Delete Container"),
    ).then((deleteContainer) {
      if (deleteContainer ?? false) {
        SQLite.instance.removeContainer(widget.container.id);

        // Popping false to avoid the SnackBar message
        context.navigator.pop(false);
      }
    });
  }

  /// Popup Menu Items for Popup Menu Button
  List<PopupMenuItem> getMenuItems(BuildContext context) {
    return [
      PopupMenuItem(
        onTap: () => showEditContainerSheet(context),
        child: const Padding(
          padding: EdgeInsets.all(10),
          child: Row(children: [Icon(Icons.edit), Gap(20), Text("Edit")]),
        ),
      ),
      PopupMenuItem(
        onTap: () => showConfirmDialog(context),
        child: const Padding(
          padding: EdgeInsets.all(10),
          child: Row(children: [Icon(Icons.delete), Gap(20), Text("Delete")]),
        ),
      ),
    ];
  }

  /// Toggles the Password Visibility
  void _toggleVisibility() {
    setState(() => _passVisibility = !_passVisibility);
  }

  @override
  Widget build(BuildContext context) {
    return Sheet(
      children: [
        Stack(
          alignment: Alignment.centerRight,
          children: [
            Center(
              child: Text("Container", style: context.textTheme.titleSmall),
            ),
            PopupMenuButton(tooltip: 'Options', itemBuilder: getMenuItems),
          ],
        ),
        const Gap(20),
        ListTile(
          title: Text(
            widget.container.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            _passVisibility
                ? widget.container.password
                : "*" * widget.container.password.length,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: IconButton(
            tooltip: 'Toggle Visibility',
            onPressed: _toggleVisibility,
            icon: FaIcon(
              _passVisibility
                  ? FontAwesomeIcons.solidEye
                  : FontAwesomeIcons.solidEyeSlash,
            ),
          ),
        ),
      ],
    );
  }
}
