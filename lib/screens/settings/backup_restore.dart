import 'dart:convert';
import 'dart:io';

import 'package:android_path_provider/android_path_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:memoir/classes/container.dart' as my;
import 'package:memoir/classes/database.dart';
import 'package:memoir/classes/encryptor.dart';
import 'package:memoir/classes/user_preferences.dart';
import 'package:memoir/extensions.dart';
import 'package:memoir/main.dart';
import 'package:memoir/screens/settings/widgets/expansion_list_tile.dart';
import 'package:memoir/sheets/confirm_action.dart';
import 'package:memoir/sheets/public_key_scanner.dart';

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
      UserPreferences.showOverrideChoice,
      UserPreferences.keepNewPassword,
    );
  }

  /// Encodes the containers in json then encrypts using the public key,
  /// and exports to a `.bin` file
  Future<void> _exportContainers(String? publicKey) async {
    if (publicKey == null) return;

    final List<my.Container> containers = await SQLite.getContainers();

    try {
      final String jsonData = jsonEncode(containers);
      final String encryptedData = Encryptor.encryptFile(jsonData, publicKey);
      final List<int> dataBytes = utf8.encode(encryptedData);

      final String documentsDir = await AndroidPathProvider.documentsPath;
      final String date = DateTime.now().toString().substring(0, 10);
      final File exportFile = await File(
        "$documentsDir/Memoir/Backup $date.bin",
      ).create(recursive: true);

      await exportFile.writeAsBytes(dataBytes);

      if (!mounted) return;
      context.messenger.showSnackBar(const SnackBar(
        duration: Duration(seconds: 2),
        showCloseIcon: true,
        content: Text(
          "Exported Containers to \"Internal Storage/Documents/Memoir\"",
        ),
      ));
    } catch (exception) {
      if (!mounted) return;
      context.messenger.showSnackBar(const SnackBar(
        duration: Duration(seconds: 2),
        showCloseIcon: true,
        content: Text("Invalid Public Key"),
      ));
    }
  }

  /// Checks for storage permissions, if granted then
  /// prompts the user to give a public key either through qrcode or clipboard then
  /// exports the passwords encrypted using the key
  void _onBackupTapped() {
    checkPermissions().then((granted) {
      if (!granted) {
        context.messenger.showSnackBar(const SnackBar(
          duration: Duration(seconds: 3),
          showCloseIcon: true,
          content: Text("Need Storage Permission"),
        ));

        return;
      }

      showModalBottomSheet<String>(
        elevation: 10,
        enableDrag: false,
        isDismissible: false,
        context: context,
        builder: (_) => const PublicKeyScannerSheet(),
      ).then(_exportContainers);
    });
  }

  /// Based on UserPreference, asks the user whether to override an already
  /// existing password
  Future<bool> _shouldOverridePassword(String container) async {
    if (UserPreferences.showOverrideChoice) {
      if (!mounted) return false;
      final bool? choiceResult = await showModalBottomSheet<bool>(
        elevation: 10,
        enableDrag: false,
        isDismissible: false,
        context: context,
        builder: (_) => ConfirmActionSheet(
          title: 'Override $container Password',
          content:
              "Doing so will replace the current Password with new Password",
          declineText: "Keep Old",
          acceptText: "Keep New",
        ),
      );

      return choiceResult ?? false;
    }

    return UserPreferences.keepNewPassword;
  }

  /// Reads the file then decrypts the file with device private key
  /// then decodes the json data and
  /// starts to insert it in the database
  ///
  /// If Container with a name already exists,
  /// the user is given a choice whether to override the password
  /// or skip the container to be added
  ///
  /// The user is asked for every duplicate container
  ///
  /// After successful import, a [SnackBar] message is shown
  Future<void> _importContainers(String path) async {
    try {
      final File importFile = File(path);

      final List<int> rawBytes = importFile.readAsBytesSync();
      final String encryptedData = utf8.decode(rawBytes);
      final String jsonData = Encryptor.decryptFile(encryptedData);
      // Do not annotate the list, cannot be typecasted
      List data = jsonDecode(jsonData);

      // Implicitly Looping over every container
      await Future.forEach(data, (container) async {
        final bool doesNameExists = await SQLite.doesNameExists(
          container['name'],
        );

        if (doesNameExists) {
          // Container with duplicate name

          final bool overridePassword = await _shouldOverridePassword(
            container["name"],
          );

          if (overridePassword) {
            return SQLite.overridePassword(
              container['name'],
              container['password'],
            );
          }

          // No Container with same name exists
        } else {
          return SQLite.addContainer(container['name'], container['password']);
        }
      });

      _didImport = true;

      if (!mounted) return;
      context.messenger.showSnackBar(const SnackBar(
        content: Text("Imported Containers"),
      ));
    } catch (exception) {
      if (!mounted) return;
      context.messenger.showSnackBar(const SnackBar(
        duration: Duration(seconds: 2),
        showCloseIcon: true,
        content: Text("Failed to Decrypt the Backup"),
      ));
    }
  }

  /// Checks for storage permissions, if granted then
  /// prompts the user to select the binary file, after selected
  /// imports all the containers
  void _onRestoreTapped() {
    checkPermissions().then((granted) {
      if (!granted) {
        context.messenger.showSnackBar(const SnackBar(
          duration: Duration(seconds: 3),
          showCloseIcon: true,
          content: Text("Need Storage Permission"),
        ));

        return;
      }

      AndroidPathProvider.documentsPath.then((directory) {
        final Future<FilePickerResult?> result = FilePicker.platform.pickFiles(
          allowMultiple: false,
          dialogTitle: "Pick Json File",
          allowedExtensions: ['bin'],
          initialDirectory: directory,
          type: FileType.custom,
        );

        result.then((file) {
          if (file == null) return;

          _importContainers(file.paths.first!);
        });
      });
    });
  }

  /// To update the import (override) settings radio button value when changed
  void _onRadioButtonSelected((bool, bool)? selected) {
    (bool, bool) value = selected ?? (false, false);

    UserPreferences.showOverrideChoice = value.$1;
    UserPreferences.keepNewPassword = value.$2;

    setState(() {
      _radioGroupValue = (
        UserPreferences.showOverrideChoice,
        UserPreferences.keepNewPassword,
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
            onTap: _onBackupTapped,
            leading: const FaIcon(FontAwesomeIcons.upload),
            title: const Text("Backup Containers"),
            subtitle: const Text("Saves Containers to device"),
          ),
          ExpansionListTile(
            onTap: _onRestoreTapped,
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
