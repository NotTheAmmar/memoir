import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:android_path_provider/android_path_provider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:memoir/classes/user_preferences.dart';
import 'package:memoir/extensions.dart';

/// Developer Options Settings
class DeveloperSettings extends StatefulWidget {
  const DeveloperSettings({super.key});

  @override
  State<DeveloperSettings> createState() => _DeveloperSettingsState();
}

class _DeveloperSettingsState extends State<DeveloperSettings> {
  /// Exports the device private and public RSA Keys into a json file
  Future<void> _exportKeys() async {
    final String documentsDir = await AndroidPathProvider.documentsPath;
    File file = await File(
      "$documentsDir/Memoir/Keys.json",
    ).create(recursive: true);

    Map<String, String> data = {
      "Private Key": UserPreferences.privateKey,
      "Public Key": UserPreferences.publicKey
    };
    String jsonData = jsonEncode(data);
    Uint8List bytes = utf8.encode(jsonData);

    file.writeAsBytes(bytes).then((_) {
      context.messenger.showSnackBar(const SnackBar(
        content: Text("Keys Exported"),
        duration: Duration(seconds: 2),
        showCloseIcon: true,
      ));
    });
  }

  /// Updates [UserPreferences.promptPrivateKey]
  void _onPromptPrivatekeyChange(bool value) {
    setState(() => UserPreferences.promptPrivateKey = value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Developer Options")),
      body: Column(
        children: [
          ListTile(
            onTap: _exportKeys,
            leading: const FaIcon(FontAwesomeIcons.fileExport),
            title: const Text("Export Keys"),
          ),
          SwitchListTile(
            value: UserPreferences.promptPrivateKey,
            onChanged: _onPromptPrivatekeyChange,
            title: const Text("Prompt Private Key"),
            subtitle: const Text(
              "Asks for private key while restoring containers",
            ),
          )
        ],
      ),
    );
  }
}
