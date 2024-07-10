import 'dart:convert';
import 'dart:io';

import 'package:android_path_provider/android_path_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:memoir/classes/container.dart' as my;
import 'package:memoir/classes/database.dart';
import 'package:memoir/classes/user_preferences.dart';
import 'package:memoir/extensions.dart';
import 'package:memoir/main.dart';
import 'package:memoir/screens/settings/widgets/expansion_list_tile.dart';
import 'package:memoir/sheets/confirm_action.dart';

/// Backup & Restore Settings
class BackupRestoreSettings extends StatefulWidget {
  const BackupRestoreSettings({super.key});

  @override
  State<BackupRestoreSettings> createState() => _BackupRestoreSettingsState();
}

class _BackupRestoreSettingsState extends State<BackupRestoreSettings> {
  /// Whether the user restored [my.Container]s from a file
  bool _didImport = false;

  /// Group Value aka current selected value for radio button
  late (bool, bool) _radioGroupValue;

  @override
  void initState() {
    super.initState();

    _radioGroupValue = (
      UserPreferences.instance.showOverrideChoice,
      UserPreferences.instance.keepNewPassword
    );
  }

  /// Exports Containers in binary file format to documents folder
  ///
  /// First Checks for storage permissions, if granted then executes
  ///
  /// After success, shows a [SnackBar] message
  ///
  /// Encodes data in Base64 format
  Future<void> _exportContainers() async {
    final bool permissionsGranted = await checkPermissions();

    if (mounted && !permissionsGranted) {
      context.messenger.showSnackBar(const SnackBar(
        duration: Duration(seconds: 3),
        showCloseIcon: true,
        content: Text("Need Storage Permission"),
      ));

      return;
    }

    final List<my.Container> containers = await SQLite.instance.getContainers();

    final String jsonData = jsonEncode(containers);
    final List<int> dataBytes = utf8.encode(jsonData);
    final String base64Data = base64Encode(dataBytes);
    final List<int> base64Bytes = utf8.encode(base64Data);

    final String documentsDir = await AndroidPathProvider.documentsPath;
    final String date = DateTime.now().toString().substring(0, 10);
    final File exportFile = await File(
      '$documentsDir/Memoir/Backup $date.bin',
    ).create(recursive: true);

    await exportFile.writeAsBytes(base64Bytes);

    if (!mounted) return;
    context.messenger.showSnackBar(const SnackBar(
      content: Text(
        "Exported Containers to \"Internal Storage/Documents/Memoir\"",
      ),
    ));
  }

  /// Imports Containers from the exported binary file
  ///
  /// First Checks for storage permissions, if granted then executes
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
  Future<void> _importContainers() async {
    final bool permissionsGranted = await checkPermissions();

    if (mounted && !permissionsGranted) {
      context.messenger.showSnackBar(const SnackBar(
        duration: Duration(seconds: 3),
        showCloseIcon: true,
        content: Text("Need Storage Permission"),
      ));

      return;
    }

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
    await Future.forEach(data, (container) async {
      final Future<bool> doesNameExists = SQLite.instance.doesNameExists(
        container['name'],
      );

      if (await doesNameExists) {
        // Container with duplicate name

        if (UserPreferences.instance.showOverrideChoice) {
          if (!mounted) return;
          final Future<bool?> choiceResult = showModalBottomSheet<bool>(
            elevation: 10,
            enableDrag: false,
            isDismissible: false,
            context: context,
            builder: (_) => ConfirmActionSheet(
              title: 'Override ${container['name']} Password',
              content:
                  "Doing so will replace the current Password with new Password",
              declineText: "Keep Old",
              acceptText: "Keep New",
            ),
          );

          // Checking if the user wants to override the
          if (await choiceResult ?? false) {
            return SQLite.instance.overridePassword(
              container['name']!,
              container['password']!,
            );
          }
        } else {
          if (UserPreferences.instance.keepNewPassword) {
            return SQLite.instance.overridePassword(
              container['name']!,
              container['password']!,
            );
          }
        }

        // No Container with same exists
      } else {
        return SQLite.instance.addContainer(
          container['name']!,
          container['password']!,
        );
      }
    });

    _didImport = true;

    if (!mounted) return;
    context.messenger.showSnackBar(const SnackBar(
      content: Text("Imported Containers"),
    ));
  }

  /// To update the import (override) settings radio button value when changed
  void _onRadioButtonSelected((bool, bool)? selected) {
    (bool, bool) value = selected ?? (false, false);

    UserPreferences.instance.showOverrideChoice = value.$1;
    UserPreferences.instance.keepNewPassword = value.$2;

    setState(() {
      _radioGroupValue = (
        UserPreferences.instance.showOverrideChoice,
        UserPreferences.instance.keepNewPassword
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Overriding the default back arrow with custom pop logic
        leading: IconButton(
          onPressed: () => context.navigator.pop(_didImport),
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text("Backup & Restore"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          ListTile(
            onTap: _exportContainers,
            leading: const FaIcon(FontAwesomeIcons.upload),
            title: const Text("Backup Containers"),
            subtitle: const Text("Saves Containers to device"),
          ),
          ExpansionListTile(
            onTap: _importContainers,
            leading: const FaIcon(FontAwesomeIcons.download),
            title: "Restore Containers",
            subtitle:
                "Use an existing backup file to restore Containers from device",
            children: [
              RadioListTile<(bool, bool)>(
                contentPadding: const EdgeInsets.all(10),
                controlAffinity: ListTileControlAffinity.trailing,
                enableFeedback: true,
                value: (false, false),
                groupValue: _radioGroupValue,
                onChanged: _onRadioButtonSelected,
                title: Text(
                  "Keep existing Passwords",
                  style: context.textTheme.bodyLarge,
                ),
                subtitle: Text(
                  "Keep already existing passwords for duplicate containers",
                  style: context.textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                  ),
                ),
              ),
              RadioListTile<(bool, bool)>(
                contentPadding: const EdgeInsets.all(10),
                controlAffinity: ListTileControlAffinity.trailing,
                enableFeedback: true,
                value: (false, true),
                groupValue: _radioGroupValue,
                onChanged: _onRadioButtonSelected,
                title: Text(
                  "Keep New Password",
                  style: context.textTheme.bodyLarge,
                ),
                subtitle: Text(
                  "Override the existing passwords with the new passwords for duplicate containers",
                  style: context.textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                  ),
                ),
              ),
              RadioListTile<(bool, bool)>(
                contentPadding: const EdgeInsets.all(10),
                controlAffinity: ListTileControlAffinity.trailing,
                enableFeedback: true,
                value: (true, false),
                groupValue: _radioGroupValue,
                onChanged: _onRadioButtonSelected,
                title: Text(
                  "Always Ask",
                  style: context.textTheme.bodyLarge,
                ),
                subtitle: Text(
                  "Always ask whether to keep the existing or new password for each duplicate container",
                  style: context.textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
