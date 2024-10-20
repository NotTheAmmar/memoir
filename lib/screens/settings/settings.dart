import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:memoir/classes/routes.dart';
import 'package:memoir/classes/user_preferences.dart';
import 'package:memoir/extensions.dart';

/// Settings Page
class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  /// Whether the user imported container or not
  bool _didImport = false;

  /// Number of taps required to unlock [DeveloperSettings]
  int _tapsToGo = 7;

  /// Unlocks [DeveloperSettings] after `7` taps on version
  void _onVersionTap() {
    if (UserPreferences.isDeveloper) return;

    _tapsToGo--;
    if (_tapsToGo == 0) {
      setState(() => UserPreferences.isDeveloper = true);
      context.messenger.showSnackBar(const SnackBar(
        content: Text("You are now a Developer!"),
        duration: Duration(seconds: 2),
        showCloseIcon: true,
      ));
    } else if (_tapsToGo < 4) {
      context.messenger.showSnackBar(SnackBar(
        content: Text("You are $_tapsToGo taps away from being a Developer"),
        duration: const Duration(milliseconds: 200),
        showCloseIcon: true,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          // if didImport is true causes vault to refresh
          onPressed: () => context.navigator.pop(_didImport),
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text("Settings"),
      ),
      body: ListView(
        children: [
          ListTile(
            onTap: () => context.navigator.pushNamed(Routes.appearanceSettings),
            leading: const FaIcon(FontAwesomeIcons.palette),
            title: const Text("Appearance"),
          ),
          ListTile(
            onTap: () => context.navigator.pushNamed(
              Routes.passwordGenerationSettings,
            ),
            leading: const FaIcon(FontAwesomeIcons.dice),
            title: const Text("Password Generation"),
          ),
          ListTile(
            onTap: () => context.navigator.pushNamed(Routes.securitySettings),
            leading: const FaIcon(FontAwesomeIcons.shield),
            title: const Text("Security"),
          ),
          ListTile(
            onTap: () {
              final Future result = context.navigator.pushNamed(
                Routes.backupRestoreSettings,
              );

              result.then((value) => _didImport = value ?? false);
            },
            leading: const FaIcon(FontAwesomeIcons.boxArchive),
            title: const Text("Backup & Restore"),
          ),
          if (UserPreferences.isDeveloper)
            ListTile(
              onTap: () => context.navigator.pushNamed(
                Routes.developerSettings,
              ),
              leading: const FaIcon(FontAwesomeIcons.code),
              title: const Text("Developer Options"),
            ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Author",
                  style: context.textTheme.bodyMedium?.copyWith(
                    fontStyle: FontStyle.italic,
                  ),
                ),
                Text(
                  'Ammar Rangwala',
                  style: context.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: _onVersionTap,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Version",
                    style: context.textTheme.bodyMedium?.copyWith(
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const Text("2.1.0"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
