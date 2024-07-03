import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:memoir/classes/user_preferences.dart';
import 'package:memoir/extensions.dart';

/// Dialog for changing preferences for generating random password temporary (does not change the global settings)
class PasswordPreferencesDialog extends StatefulWidget {
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

  const PasswordPreferencesDialog({
    super.key,
    required this.useLetters,
    required this.includeUppercase,
    required this.includeNumbers,
    required this.includeSpecialChars,
    required this.passwordLen,
  });

  @override
  State<PasswordPreferencesDialog> createState() {
    return _PasswordPreferencesDialogState();
  }
}

class _PasswordPreferencesDialogState extends State<PasswordPreferencesDialog> {
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
  ///
  /// Causes rebuilt of the widget
  void _setUseLetters(bool? value) {
    if (value == null) return;

    setState(() => _useLetters = value);
  }

  /// Updates the `includeUppercase` value
  ///
  /// Causes rebuilt of the widget
  void _setIncludeUppercase(bool? value) {
    if (value == null) return;

    setState(() => _includeUppercase = value);
  }

  /// Updates the `includeNumbers` value
  ///
  /// Causes rebuilt of the widget
  void _setIncludeNumbers(bool? value) {
    if (value == null) return;

    setState(() => _includeNumbers = value);
  }

  /// Updates the `includeSpecialChars` value
  ///
  /// Causes rebuilt of the widget
  void _setIncludeSpecialChars(bool? value) {
    if (value == null) return;

    setState(() => _includeSpecialChars = value);
  }

  /// Updates the `passLen` value
  ///
  /// Causes rebuilt of the widget
  void _setPassLen(double value) {
    setState(() => _passwordLen = value);
  }

  /// Pops the dialog without saving changes to preferences
  void exitWithoutSaving() => context.navigator.pop();

  /// Pops the dialog while saving changes to preferences
  void exit() {
    context.navigator.pop((
      _useLetters,
      _includeUppercase,
      _includeNumbers,
      _includeSpecialChars,
      _passwordLen
    ));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Preferences"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
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
                    min: UserPreferences.instance.passwordLenRange.start,
                    max: UserPreferences.instance.passwordLenRange.end,
                    divisions: UserPreferences.instance.passwordLenRange.end.toInt() -
                        UserPreferences.instance.passwordLenRange.start.toInt(),
                    label: "${_passwordLen.toInt()}",
                  ),
                ),
              ],
            ),
          )
        ],
      ),
      actions: [
        IconButton(
          tooltip: 'Back',
          onPressed: exitWithoutSaving,
          icon: const FaIcon(FontAwesomeIcons.anglesLeft),
        ),
        IconButton(
          tooltip: 'Save Preferences',
          onPressed: exit,
          icon: const FaIcon(FontAwesomeIcons.solidFloppyDisk),
        ),
      ],
    );
  }
}
