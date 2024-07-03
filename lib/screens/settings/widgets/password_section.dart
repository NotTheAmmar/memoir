import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:memoir/classes/user_preferences.dart';
import 'package:memoir/extensions.dart';

/// Password Settings
class PasswordSettingsSection extends StatefulWidget {
  const PasswordSettingsSection({super.key});

  @override
  State<PasswordSettingsSection> createState() {
    return _PasswordSettingsSectionState();
  }
}

class _PasswordSettingsSectionState extends State<PasswordSettingsSection> {
  /// Updates the `Use Letters` Config value
  void _updateUseLetters(bool value) {
    setState(() => UserPreferences.instance.useLetters = value);
  }

  /// Updates the `Include Uppercase` Config value
  void _updateIncludeUppercase(bool value) {
    setState(() => UserPreferences.instance.includeUppercase = value);
  }

  /// Updates the `Include Numbers` Config value
  void _updateIncludeNumbers(bool value) {
    setState(() => UserPreferences.instance.includeNumbers = value);
  }

  /// Updates the `Include Special Characters` Config value
  void _updateIncludeSpecialChars(bool value) {
    setState(() => UserPreferences.instance.includeSpecialChars = value);
  }

  /// Updates the `Password Length Range` Config value
  void _updatePasswordLenRange(RangeValues values) {
    if (values.start > UserPreferences.instance.passwordLen ||
        values.end < UserPreferences.instance.passwordLen) {
      return;
    }

    setState(() => UserPreferences.instance.passwordLenRange = values);
  }

  /// Updates the `Password Length` Config value
  void _updatePasswordLen(double value) {
    setState(() => UserPreferences.instance.passwordLen = value);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "Password",
          style: context.textTheme.bodySmall?.copyWith(color: Colors.grey),
        ),
        const Gap(10),
        SwitchListTile(
          value: UserPreferences.instance.useLetters,
          onChanged: _updateUseLetters,
          title: const Text("Use Letters"),
        ),
        SwitchListTile(
          value: UserPreferences.instance.includeUppercase,
          onChanged: _updateIncludeUppercase,
          title: const Text("Include Uppercase Letters"),
        ),
        SwitchListTile(
          value: UserPreferences.instance.includeNumbers,
          onChanged: _updateIncludeNumbers,
          title: const Text("Include Numbers"),
        ),
        SwitchListTile(
          value: UserPreferences.instance.includeSpecialChars,
          onChanged: _updateIncludeSpecialChars,
          title: const Text("Include Special Characters"),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              Text("Length Range", style: context.textTheme.bodyLarge),
              Expanded(
                child: RangeSlider(
                  values: UserPreferences.instance.passwordLenRange,
                  onChanged: _updatePasswordLenRange,
                  min: 1,
                  max: 256,
                  divisions: 255,
                  labels: RangeLabels(
                    '${UserPreferences.instance.passwordLenRange.start.toInt()}',
                    '${UserPreferences.instance.passwordLenRange.end.toInt()}',
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              Text("Length", style: context.textTheme.bodyLarge),
              Expanded(
                child: Slider(
                  value: UserPreferences.instance.passwordLen,
                  onChanged: _updatePasswordLen,
                  min: UserPreferences.instance.passwordLenRange.start,
                  max: UserPreferences.instance.passwordLenRange.end,
                  divisions: UserPreferences.instance.passwordLenRange.end.toInt() -
                      UserPreferences.instance.passwordLenRange.start.toInt(),
                  label: "${UserPreferences.instance.passwordLen.toInt()}",
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
