import 'package:flutter/material.dart';
import 'package:memoir/classes/user_preferences.dart';
import 'package:memoir/extensions.dart';

/// Appearance Settings
class AppearanceSettings extends StatelessWidget {
  const AppearanceSettings({super.key});

  /// Updates ThemeMode when value changes for [DropdownButton]
  void _updateThemeMode(ThemeMode? value) {
    if (value == null) return;

    UserPreferences.themeMode = value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Appearance")),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListTile(
          title: const Text("Theme"),
          subtitle: const Text("Changes the Brightness"),
          trailing: DropdownButton<ThemeMode>(
            enableFeedback: true,
            style: context.textTheme.bodySmall,
            value: UserPreferences.themeMode,
            items: const [
              DropdownMenuItem(
                value: ThemeMode.system,
                child: Text("System"),
              ),
              DropdownMenuItem(
                value: ThemeMode.light,
                child: Text("Light"),
              ),
              DropdownMenuItem(
                value: ThemeMode.dark,
                child: Text("Dark"),
              ),
            ],
            onChanged: _updateThemeMode,
          ),
        ),
      ),
    );
  }
}
