import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:memoir/classes/password_generator.dart';
import 'package:memoir/classes/user_preferences.dart';
import 'package:memoir/sheets/password_preferences.dart';

/// Handles generating random password and preferences for generating random password
///
/// Parent widget is meant to be a [TextField], this widget is supposed to be an suffix for it
class PasswordTools extends StatefulWidget {
  /// Setter for parent to get the randomly generated password
  final ValueSetter<String> randomPasswordSetter;

  const PasswordTools({super.key, required this.randomPasswordSetter});

  @override
  State<PasswordTools> createState() => _PasswordToolsState();
}

class _PasswordToolsState extends State<PasswordTools> {
  /// Current setting preference of `Using Letters` for generating random password
  ///
  /// Default Value is of Config, essentially the global setting
  bool _useLetters = UserPreferences.instance.useLetters;

  /// Current setting preference of `Including Uppercase Letters` in randomly generated passwords
  ///
  /// Default Value is of Config, essentially the global setting
  bool _includeUppercase = UserPreferences.instance.includeUppercase;

  /// Current setting preference of `Including Number` in randomly generated passwords
  ///
  /// Default Value is of Config, essentially the global setting
  bool _includeNumbers = UserPreferences.instance.includeNumbers;

  /// Current setting preference of `Including Special Characters` in randomly generated passwords
  ///
  /// Default Value is of Config, essentially the global setting
  bool _includeSpecialChars = UserPreferences.instance.includeSpecialChars;

  /// Current setting preference of `Password Length` for generating random passwords
  ///
  /// Default Value is of Config, essentially the global setting
  double _passLen = UserPreferences.instance.passwordLen;

  /// Generates a random password and calls the password setter for parent
  void _generateRandomPassword() {
    widget.randomPasswordSetter(PasswordGenerator.instance.randomPassword(
      letters: _useLetters,
      uppercase: _includeUppercase,
      numbers: _includeNumbers,
      specialChars: _includeSpecialChars,
      passwordLen: _passLen,
    ));
  }

  /// Shows the `Password Preferences` BottomSheet
  void _showPasswordPreferencesSheet() {
    // Parameters
    // 1 - Letters
    // 2 - Uppercase
    // 3 - Numbers
    // 4 - Special Characters
    // 5 - Length
    showModalBottomSheet<(bool, bool, bool, bool, double)>(
      elevation: 10,
      enableDrag: false,
      isDismissible: false,
      context: context,
      builder: (_) => PasswordPreferencesSheet(
        useLetters: _useLetters,
        includeUppercase: _includeUppercase,
        includeNumbers: _includeNumbers,
        includeSpecialChars: _includeSpecialChars,
        passwordLen: _passLen,
      ),
    ).then((result) {
      if (result == null) return;

      _useLetters = result.$1;
      _includeUppercase = result.$2;
      _includeNumbers = result.$3;
      _includeSpecialChars = result.$4;
      _passLen = result.$5;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          tooltip: 'Generate Random',
          onPressed: _generateRandomPassword,
          icon: const FaIcon(FontAwesomeIcons.dice),
        ),
        IconButton(
          tooltip: 'Preferences',
          onPressed: _showPasswordPreferencesSheet,
          icon: const FaIcon(FontAwesomeIcons.sliders),
        ),
      ],
    );
  }
}
