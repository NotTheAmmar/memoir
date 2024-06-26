import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Shared Preferences Key of [Config._themeMode]
const String _themeModeKey = "themeMode";

/// Shared Preferences Key of [Config._useLetters]
const String _useLettersKey = "useLetters";

/// Shared Preferences Key of [Config._includeUppercase]
const String _includeUppercaseKey = "includeUppercase";

/// Shared Preferences Key of [Config._includeNumbers]
const String _includeNumbersKey = "includeNumbers";

/// Shared Preferences Key of [Config._includeSpecialChars]
const String _includeSpecialCharsKey = "includeSpecialChars";

/// Shared Preferences Key of [Config._passwordLenRange] for `RangeValues.start`
const String _passwordLenRangeStartKey = "passwordLenRangeStart";

/// Shared Preferences Key of [Config._passwordLenRange] for `RangeValues.end`
const String _passwordLenRangeEndKey = "passwordLenRangeEnd";

/// Shared Preferences Key of [Config._passwordLen]
const String _passwordLenKey = "passwordLen";

/// Manages the user preferences and the data in [SharedPreferences]
///
/// The class is a [Listener], notifies after an [ThemeMode] change
///
/// It is Singleton class and data is to be accessed through [instance]
class Config extends ChangeNotifier {
  /// Singleton Instance
  static final Config _instance = Config._();
  static Config get instance => _instance;

  /// For storing theme and password generator preferences
  late final SharedPreferences _preferences;

  /// Current ThemeMode of Application
  ///
  /// Default Value: `ThemeMode.system`
  ThemeMode _themeMode = ThemeMode.system;

  /// Whether a random generated password contains letters
  ///
  /// Default Value: `true`
  bool _useLetters = true;

  /// Whether a random generated password contains Uppercase Letters
  ///
  /// Default Value: `false`
  bool _includeUppercase = false;

  /// Whether a random generated password contains Numbers
  ///
  /// Default Value: `false`
  bool _includeNumbers = false;

  /// Whether a random generated password contains Special Characters
  ///
  /// Default Value: `false`
  bool _includeSpecialChars = false;

  /// Specifies the range in which the user can chose the password length for random generated password
  ///
  /// Default Value: `(start: 1, end: 256)`
  RangeValues _passwordLenRange = const RangeValues(1, 256);

  /// Length for random generated password
  ///
  /// Default Value: `8`
  double _passwordLen = 8;

  /// Initializes [SharedPreferences] and loads the stored preferences if they exists otherwise uses the default values
  Config._() {
    SharedPreferences.getInstance().then(
      (preferences) {
        _preferences = preferences;

        String mode = _preferences.getString(_themeModeKey) ?? "system";
        switch (mode) {
          case "light":
            themeMode = ThemeMode.light;
            break;
          case "dark":
            themeMode = ThemeMode.dark;
            break;
          default:
            themeMode = ThemeMode.system;
        }

        _includeNumbers = _preferences.getBool(_includeNumbersKey) ?? false;
        _includeSpecialChars =
            _preferences.getBool(_includeSpecialCharsKey) ?? false;
        _includeUppercase = _preferences.getBool(_includeUppercaseKey) ?? false;
        _useLetters = _preferences.getBool(_useLettersKey) ?? true;

        _passwordLenRange = RangeValues(
          _preferences.getDouble(_passwordLenRangeStartKey) ?? 1,
          _preferences.getDouble(_passwordLenRangeEndKey) ?? 256,
        );
        _passwordLen = _preferences.getDouble(_passwordLenKey) ?? 8;
      },
    );
  }

  /// ThemeMode of Application
  ///
  /// Notifies any [Listener]s after change
  ThemeMode get themeMode => _themeMode;
  set themeMode(ThemeMode mode) {
    if (_themeMode == mode) return;

    _themeMode = mode;
    _preferences.setString(_themeModeKey, _themeMode.name);
    notifyListeners();
  }

  /// Whether a random generated password should contain Letters
  bool get useLetters => _useLetters;
  set useLetters(bool value) {
    if (_useLetters == value) return;

    _useLetters = value;
    _preferences.setBool(_useLettersKey, _useLetters);
  }

  /// Whether a random generated password should contain Uppercase Letters
  bool get includeUppercase => _includeUppercase;
  set includeUppercase(bool value) {
    if (_includeUppercase == value) return;

    _includeUppercase = value;
    _preferences.setBool(_includeUppercaseKey, _includeUppercase);
  }

  /// Whether a random generated password should contain Numbers
  bool get includeNumbers => _includeNumbers;
  set includeNumbers(bool value) {
    if (_includeNumbers == value) return;

    _includeNumbers = value;
    _preferences.setBool(_includeNumbersKey, _includeNumbers);
  }

  /// Whether a random generated password should contain Special Characters
  bool get includeSpecialChars => _includeSpecialChars;
  set includeSpecialChars(bool value) {
    if (_includeSpecialChars == value) return;

    _includeSpecialChars = value;
    _preferences.setBool(
      _includeSpecialCharsKey,
      _includeSpecialChars,
    );
  }

  /// Specifies the range for selecting a password Length for a randomly generated password
  RangeValues get passwordLenRange => _passwordLenRange;
  set passwordLenRange(RangeValues values) {
    if (_passwordLenRange == values) return;

    _passwordLenRange = values;
    _preferences.setDouble(
      _passwordLenRangeStartKey,
      _passwordLenRange.start,
    );
    _preferences.setDouble(
      _passwordLenRangeEndKey,
      _passwordLenRange.end,
    );
  }

  /// Length of a random generated password
  double get passwordLen => _passwordLen;
  set passwordLen(double length) {
    if (_passwordLen == length) return;

    _passwordLen = length;
    _preferences.setDouble(_passwordLenKey, _passwordLen);
  }
}
