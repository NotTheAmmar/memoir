import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:memoir/config.dart';
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
    setState(() => Config.instance.useLetters = value);
  }

  /// Updates the `Include Uppercase` Config value
  void _updateIncludeUppercase(bool value) {
    setState(() => Config.instance.includeUppercase = value);
  }

  /// Updates the `Include Numbers` Config value
  void _updateIncludeNumbers(bool value) {
    setState(() => Config.instance.includeNumbers = value);
  }

  /// Updates the `Include Special Characters` Config value
  void _updateIncludeSpecialChars(bool value) {
    setState(() => Config.instance.includeSpecialChars = value);
  }

  /// Updates the `Password Length Range` Config value
  void _updatePasswordLenRange(RangeValues values) {
    if (values.start > Config.instance.passwordLen ||
        values.end < Config.instance.passwordLen) {
      return;
    }

    setState(() => Config.instance.passwordLenRange = values);
  }

  /// Updates the `Password Length` Config value
  void _updatePasswordLen(double value) {
    setState(() => Config.instance.passwordLen = value);
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
          value: Config.instance.useLetters,
          onChanged: _updateUseLetters,
          title: const Text("Use Letters"),
        ),
        SwitchListTile(
          value: Config.instance.includeUppercase,
          onChanged: _updateIncludeUppercase,
          title: const Text("Include Uppercase Letters"),
        ),
        SwitchListTile(
          value: Config.instance.includeNumbers,
          onChanged: _updateIncludeNumbers,
          title: const Text("Include Numbers"),
        ),
        SwitchListTile(
          value: Config.instance.includeSpecialChars,
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
                  values: Config.instance.passwordLenRange,
                  onChanged: _updatePasswordLenRange,
                  min: 1,
                  max: 256,
                  divisions: 255,
                  labels: RangeLabels(
                    '${Config.instance.passwordLenRange.start.toInt()}',
                    '${Config.instance.passwordLenRange.end.toInt()}',
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
                  value: Config.instance.passwordLen,
                  onChanged: _updatePasswordLen,
                  min: Config.instance.passwordLenRange.start,
                  max: Config.instance.passwordLenRange.end,
                  divisions: Config.instance.passwordLenRange.end.toInt() -
                      Config.instance.passwordLenRange.start.toInt(),
                  label: "${Config.instance.passwordLen.toInt()}",
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
