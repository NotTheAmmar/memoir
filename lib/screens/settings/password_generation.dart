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
  void _updateUseLetters(bool value) {
    setState(() => UserPreferences.useLetters = value);
  }

  /// Updates [UserPreferences.includeUppercase]
  void _updateIncludeUppercase(bool value) {
    setState(() => UserPreferences.includeUppercase = value);
  }

  /// Updates [UserPreferences.includeNumbers]
  void _updateIncludeNumbers(bool value) {
    setState(() => UserPreferences.includeNumbers = value);
  }

  /// Updates [UserPreferences.includeSpecialChars]
  void _updateIncludeSpecialChars(bool value) {
    setState(() => UserPreferences.includeSpecialChars = value);
  }

  /// Updates [UserPreferences.passwordLenRange]
  void _updatePasswordLenRange(RangeValues values) {
    if (values.start > UserPreferences.passwordLen ||
        values.end < UserPreferences.passwordLen) {
      return;
    }

    setState(() => UserPreferences.passwordLenRange = values);
  }

  /// Updates [UserPreferences.passwordLen]
  void _updatePasswordLen(double value) {
    setState(() => UserPreferences.passwordLen = value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Password Generation")),
      body: Column(
        children: [
          SwitchListTile(
            value: UserPreferences.useLetters,
            onChanged: _updateUseLetters,
            title: const Text("Use Letters"),
            subtitle: const Text("Whether random password will use letters"),
          ),
          SwitchListTile(
            value: UserPreferences.includeUppercase,
            onChanged: _updateIncludeUppercase,
            title: const Text("Include Uppercase Letters"),
            subtitle: const Text(
              "Whether random password will use uppercase letters",
            ),
          ),
          SwitchListTile(
            value: UserPreferences.includeNumbers,
            onChanged: _updateIncludeNumbers,
            title: const Text("Include Numbers"),
            subtitle: const Text("Whether random password will use numbers"),
          ),
          SwitchListTile(
            value: UserPreferences.includeSpecialChars,
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
                  Text("${UserPreferences.passwordLenRange.start.toInt()}"),
                  Expanded(
                    child: RangeSlider(
                      values: UserPreferences.passwordLenRange,
                      onChanged: _updatePasswordLenRange,
                      min: 1,
                      max: 256,
                      divisions: 255,
                    ),
                  ),
                  Text("${UserPreferences.passwordLenRange.end.toInt()}"),
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
                  Text("${UserPreferences.passwordLen.toInt()}"),
                  Expanded(
                    child: Slider(
                      value: UserPreferences.passwordLen,
                      onChanged: _updatePasswordLen,
                      min: UserPreferences.passwordLenRange.start,
                      max: UserPreferences.passwordLenRange.end,
                      divisions: UserPreferences.passwordLenRange.end.toInt() -
                          UserPreferences.passwordLenRange.start.toInt(),
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
