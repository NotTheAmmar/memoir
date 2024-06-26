import 'dart:convert';
import 'dart:io';

import 'package:android_path_provider/android_path_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:memoir/classes/container.dart' as my;
import 'package:memoir/classes/database.dart';
import 'package:memoir/dialogs/confirm.dart';
import 'package:memoir/extensions.dart';

/// Accessibility Settings
class AccessibilitySection extends StatelessWidget {
  /// Notifies parent when user imports containers successfully
  final VoidCallback importNotifier;

  const AccessibilitySection({super.key, required this.importNotifier});

  /// Exports Containers in binary file format to documents folder
  ///
  /// After success, shows a [SnackBar] message
  ///
  /// Encodes data in Base64 format
  Future<void> _exportContainers(BuildContext context) async {
    final String documentsDir = await AndroidPathProvider.documentsPath;

    final List<my.Container> containers = await SQLite.instance.getContainers();

    final String jsonData = jsonEncode(containers);
    final List<int> dataBytes = utf8.encode(jsonData);
    final String base64Data = base64Encode(dataBytes);
    final List<int> base64Bytes = utf8.encode(base64Data);

    final File exportFile = await File(
      '$documentsDir/Memoir/backup.bin',
    ).create(recursive: true);
    // exportFile.openWrite();
    exportFile.writeAsBytes(base64Bytes).then((_) {
      context.messenger.showSnackBar(const SnackBar(
        content: Text("Exported"),
      ));
    });
  }

  /// Imports Containers from the exported binary file
  ///
  /// Prompts the user to select the binary file, if not selected then aborts the process
  ///
  /// Reads the file then decodes the base64 data back to utf8 and starts to insert it in the database
  ///
  /// If Container with a name already exists,
  /// the user is given a choice whether to override the password
  /// or skip the container to be added
  ///
  /// The user is asked for every duplicate container
  ///
  /// After successful import, a [SnackBar] message is shown
  Future<void> _importContainers(BuildContext context) async {
    final FilePickerResult? pickedFile = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      dialogTitle: "Pick Json File",
      allowedExtensions: ['bin'],
      initialDirectory: await AndroidPathProvider.documentsPath,
      type: FileType.custom,
    );

    if (pickedFile == null) return;

    final File importFile = File(pickedFile.files.first.path!);

    final List<int> rawBytes = importFile.readAsBytesSync();
    final String base64Data = utf8.decode(rawBytes);
    final List<int> dataBytes = base64Decode(base64Data);
    final String jsonData = utf8.decode(dataBytes);

    // Do not annotate the list, cannot be typecasted
    List data = jsonDecode(jsonData);

    // Implicitly Looping over every container
    Future.forEach(data, (container) async {
      final Future<bool> result = SQLite.instance.doesNameExists(
        container['name'],
      );

      return result.then((doesNameExists) {
        if (doesNameExists) {
          // Container with duplicate name
          final Future<bool?> choiceResult = showDialog<bool>(
            context: context,
            builder: (_) => ConfirmDialog(
              title: 'Override ${container['name']} Password',
            ),
          );

          // Checking if the user wants to override the
          return choiceResult.then((value) {
            if (value ?? false) {
              return SQLite.instance.overridePassword(
                container['name']!,
                container['password']!,
              );
            }
          });

          // No Container with same exists
        } else {
          return SQLite.instance.addContainer(
            container['name']!,
            container['password']!,
          );
        }
      });

      // Once all the future are completed
    }).then((_) {
      importNotifier();

      context.messenger.showSnackBar(const SnackBar(
        content: Text("Imported"),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "Accessibility",
          style: context.textTheme.bodySmall?.copyWith(color: Colors.grey),
        ),
        const Gap(10),
        ButtonBar(
          alignment: MainAxisAlignment.spaceAround,
          children: [
            FilledButton.icon(
              onPressed: () => _exportContainers(context),
              icon: const FaIcon(FontAwesomeIcons.fileExport),
              label: const Text("Export"),
            ),
            FilledButton.icon(
              onPressed: () => _importContainers(context),
              icon: const FaIcon(FontAwesomeIcons.fileImport),
              label: const Text("Import"),
            ),
          ],
        ),
      ],
    );
  }
}
