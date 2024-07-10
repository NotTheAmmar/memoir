import 'package:flutter/material.dart';
import 'package:memoir/classes/user_preferences.dart';
import 'package:memoir/screens/settings/widgets/expansion_list_tile.dart';

/// Password Generation Settings
class PasswordGenerationSettings extends StatefulWidget {
  const PasswordGenerationSettings({super.key});

  @override
  State<PasswordGenerationSettings> createState() {
    return _PasswordGenerationSettingsState();
  }
}

class _PasswordGenerationSettingsState
    extends State<PasswordGenerationSettings> {
  /// Updates [UserPreferences.useLetters]
  ///
  /// Causes Widget rebuild
  void _updateUseLetters(bool value) {
    setState(() => UserPreferences.instance.useLetters = value);
  }

  /// Updates [UserPreferences.includeUppercase]
  ///
  /// Causes Widget rebuild
  void _updateIncludeUppercase(bool value) {
    setState(() => UserPreferences.instance.includeUppercase = value);
  }

  /// Updates [UserPreferences.includeNumbers]
  ///
  /// Causes Widget rebuild
  void _updateIncludeNumbers(bool value) {
    setState(() => UserPreferences.instance.includeNumbers = value);
  }

  /// Updates [UserPreferences.includeSpecialChars]
  ///
  /// Causes Widget rebuild
  void _updateIncludeSpecialChars(bool value) {
    setState(() => UserPreferences.instance.includeSpecialChars = value);
  }

  /// Updates [UserPreferences.passwordLenRange]
  ///
  /// Causes Widget rebuild
  void _updatePasswordLenRange(RangeValues values) {
    if (values.start > UserPreferences.instance.passwordLen ||
        values.end < UserPreferences.instance.passwordLen) {
      return;
    }

    setState(() => UserPreferences.instance.passwordLenRange = values);
  }

  /// Updates [UserPreferences.passwordLen]
  ///
  /// Causes Widget rebuild
  void _updatePasswordLen(double value) {
    setState(() => UserPreferences.instance.passwordLen = value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Password Generation")),
      body: Column(
        children: [
          SwitchListTile(
            value: UserPreferences.instance.useLetters,
            onChanged: _updateUseLetters,
            title: const Text("Use Letters"),
            subtitle: const Text("Whether random password will use letters"),
          ),
          SwitchListTile(
            value: UserPreferences.instance.includeUppercase,
            onChanged: _updateIncludeUppercase,
            title: const Text("Include Uppercase Letters"),
            subtitle: const Text(
              "Whether random password will use uppercase letters",
            ),
          ),
          SwitchListTile(
            value: UserPreferences.instance.includeNumbers,
            onChanged: _updateIncludeNumbers,
            title: const Text("Include Numbers"),
            subtitle: const Text("Whether random password will use numbers"),
          ),
          SwitchListTile(
            value: UserPreferences.instance.includeSpecialChars,
            onChanged: _updateIncludeSpecialChars,
            title: const Text("Include Special Characters"),
            subtitle: const Text(
                "Whether random password will use special characters"),
          ),
          ExpansionListTile(
            title: "Length Range",
            subtitle: "Minimum and Maximum values of Password Length",
            children: [
              Row(
                children: [
                  Text(
                    "${UserPreferences.instance.passwordLenRange.start.toInt()}",
                  ),
                  Expanded(
                    child: RangeSlider(
                      values: UserPreferences.instance.passwordLenRange,
                      onChanged: _updatePasswordLenRange,
                      min: 1,
                      max: 256,
                      divisions: 255,
                    ),
                  ),
                  Text(
                    "${UserPreferences.instance.passwordLenRange.end.toInt()}",
                  ),
                ],
              )
            ],
          ),
          ExpansionListTile(
            title: "Length",
            subtitle: "Random Password Length",
            children: [
              Row(
                children: [
                  Text("${UserPreferences.instance.passwordLen.toInt()}"),
                  Expanded(
                    child: Slider(
                      value: UserPreferences.instance.passwordLen,
                      onChanged: _updatePasswordLen,
                      min: UserPreferences.instance.passwordLenRange.start,
                      max: UserPreferences.instance.passwordLenRange.end,
                      divisions: UserPreferences.instance.passwordLenRange.end
                              .toInt() -
                          UserPreferences.instance.passwordLenRange.start
                              .toInt(),
                    ),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
