import 'package:flutter/material.dart';
import 'package:random_password_generator/random_password_generator.dart';

/// Indicates the Strength of the Password
///
/// Basically how good it is
enum PasswordStrength { strong, good, weak }

/// Wrapper Class for [RandomPasswordGenerator]
abstract final class PasswordGenerator {
  /// [RandomPasswordGenerator] Object for generating random password
  static final RandomPasswordGenerator _generator = RandomPasswordGenerator();

  /// Returns the Password Strength
  static PasswordStrength _getStrength(String password) {
    final double result = _generator.checkPassword(password: password);

    if (result >= 0.8) {
      return PasswordStrength.strong;
    } else if (result >= 0.4) {
      return PasswordStrength.good;
    } else {
      return PasswordStrength.weak;
    }
  }

  /// Returns a randomly generated password
  ///
  /// [letters] indicates whether the random password will contain letters
  ///
  /// [uppercase] indicates whether the random password will contain uppercase letters
  ///
  /// [numbers] indicates whether the random password will contain numbers
  ///
  /// [specialChars] indicates whether the random password will contain special characters
  ///
  /// [passwordLen] specifies the length of the random password
  ///
  /// The random password will contain letters if the all bool option are `false`
  static String randomPassword({
    required bool letters,
    required bool uppercase,
    required bool numbers,
    required bool specialChars,
    required double passwordLen,
  }) {
    return _generator.randomPassword(
      letters: letters,
      uppercase: uppercase,
      numbers: numbers,
      specialChar: specialChars,
      passwordLength: passwordLen,
    );
  }

  /// Returns the password strength status
  ///
  /// Returns the string message and message color
  ///
  /// `[Colors.greenAccent]` if it is `[PasswordStrength.strong]`
  ///
  /// `[Colors.orangeAccent]` if it is `[PasswordStrength.good]`
  ///
  /// `[Colors.redAccent]` if it is `[PasswordStrength.weak]`
  static (String, Color) getStatus(String password) {
    if (password.isEmpty) return ('', Colors.grey);

    final PasswordStrength strength = _getStrength(password);

    switch (strength) {
      case PasswordStrength.strong:
        return ("Strong Password", Colors.greenAccent);
      case PasswordStrength.good:
        return ("Good Password", Colors.orangeAccent);
      case PasswordStrength.weak:
        return ("Weak Password", Colors.redAccent);
    }
  }
}
