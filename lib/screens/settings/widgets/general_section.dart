import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:memoir/config.dart';
import 'package:memoir/extensions.dart';

/// General Settings
class GeneralSettingsSection extends StatelessWidget {
  const GeneralSettingsSection({super.key});

  /// Updates ThemeMode when value changes for [DropdownButton]
  void _updateThemeMode(ThemeMode? value) {
    if (value == null) return;

    Config.instance.themeMode = value;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "General",
          style: context.textTheme.bodySmall?.copyWith(color: Colors.grey),
        ),
        const Gap(10),
        ListTile(
          title: const Text("Theme"),
          trailing: DropdownButton<ThemeMode>(
            enableFeedback: true,
            style: context.textTheme.bodySmall,
            value: Config.instance.themeMode,
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
      ],
    );
  }
}
