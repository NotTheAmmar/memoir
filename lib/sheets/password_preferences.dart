import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:memoir/classes/user_preferences.dart';
import 'package:memoir/extensions.dart';
import 'package:memoir/sheets/widgets/sheet.dart';

/// BottomSheet for changing preferences for generating random password temporary (does not change the global settings)
class PasswordPreferencesSheet extends StatefulWidget {
  /// Whether the randomly generated password will use Letters
  final bool useLetters;

  /// Whether the randomly generated password will include Uppercase Letters
  final bool includeUppercase;

  /// Whether the randomly generated password will include Numbers
  final bool includeNumbers;

  /// Whether the randomly generated password will include Special Characters
  final bool includeSpecialChars;

  /// Length of the randomly generated password
  final double passwordLen;

  const PasswordPreferencesSheet({
    super.key,
    required this.useLetters,
    required this.includeUppercase,
    required this.includeNumbers,
    required this.includeSpecialChars,
    required this.passwordLen,
  });

  @override
  State<PasswordPreferencesSheet> createState() {
    return _PasswordPreferencesSheetState();
  }
}

class _PasswordPreferencesSheetState extends State<PasswordPreferencesSheet> {
  /// Whether the randomly generated password will use Letters
  ///
  /// Created to maintain immutability of the Widget
  late bool _useLetters;

  /// Whether the randomly generated password will include Uppercase Letters
  ///
  /// Created to maintain immutability of the Widget
  late bool _includeUppercase;

  /// Whether the randomly generated password will include Numbers
  ///
  /// Created to maintain immutability of the Widget
  late bool _includeNumbers;

  /// Whether the randomly generated password will include Special Characters
  ///
  /// Created to maintain immutability of the Widget
  late bool _includeSpecialChars;

  /// Length of the randomly generated password
  ///
  /// Created to maintain immutability of the Widget
  late double _passwordLen;

  @override
  void initState() {
    super.initState();

    _useLetters = widget.useLetters;
    _includeUppercase = widget.includeUppercase;
    _includeNumbers = widget.includeNumbers;
    _includeSpecialChars = widget.includeSpecialChars;
    _passwordLen = widget.passwordLen;
  }

  /// Updates the `useLetters` value
  void _setUseLetters(bool? value) {
    if (value == null) return;

    setState(() => _useLetters = value);
  }

  /// Updates the `includeUppercase` value
  void _setIncludeUppercase(bool? value) {
    if (value == null) return;

    setState(() => _includeUppercase = value);
  }

  /// Updates the `includeNumbers` value
  void _setIncludeNumbers(bool? value) {
    if (value == null) return;

    setState(() => _includeNumbers = value);
  }

  /// Updates the `includeSpecialChars` value
  void _setIncludeSpecialChars(bool? value) {
    if (value == null) return;

    setState(() => _includeSpecialChars = value);
  }

  /// Updates the `passLen` value
  void _setPassLen(double value) {
    setState(() => _passwordLen = value);
  }

  @override
  Widget build(BuildContext context) {
    return Sheet(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Text("Preferences", style: context.textTheme.titleMedium),
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                tooltip: "Back",
                // Pops the dialog without saving changes to preferences
                onPressed: context.navigator.pop,
                icon: const FaIcon(FontAwesomeIcons.anglesLeft),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                tooltip: "Save",
                // Pops the dialog while saving changes to preferences
                onPressed: () => context.navigator.pop((
                  _useLetters,
                  _includeUppercase,
                  _includeNumbers,
                  _includeSpecialChars,
                  _passwordLen
                )),
                icon: const FaIcon(FontAwesomeIcons.solidFloppyDisk),
              ),
            ),
          ],
        ),
        const Gap(20),
        CheckboxListTile(
          contentPadding: const EdgeInsets.all(10),
          value: _useLetters,
          onChanged: _setUseLetters,
          title: const Text("Letters"),
        ),
        CheckboxListTile(
          contentPadding: const EdgeInsets.all(10),
          value: _includeUppercase,
          onChanged: _setIncludeUppercase,
          title: const Text("Uppercase Letters"),
        ),
        CheckboxListTile(
          contentPadding: const EdgeInsets.all(10),
          value: _includeNumbers,
          onChanged: _setIncludeNumbers,
          title: const Text("Numbers"),
        ),
        CheckboxListTile(
          contentPadding: const EdgeInsets.all(10),
          value: _includeSpecialChars,
          onChanged: _setIncludeSpecialChars,
          title: const Text("Special Characters"),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              Text("Length", style: context.textTheme.bodyLarge),
              Expanded(
                child: Slider(
                  value: _passwordLen,
                  onChanged: _setPassLen,
                  min: UserPreferences.passwordLenRange.start,
                  max: UserPreferences.passwordLenRange.end,
                  divisions: UserPreferences.passwordLenRange.end.toInt() -
                      UserPreferences.passwordLenRange.start.toInt(),
                ),
              ),
              Text("${_passwordLen.toInt()}"),
            ],
          ),
        )
      ],
    );
  }
}
