import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

/// Handles the storage of data in [SharedPreferences]
///
/// Call [initialize] before storing data
class LocalStorage {
  /// For storing theme and password generator preferences
  late final SharedPreferences _preferences;

  /// Initializes [SharedPreferences]
  Future<void> initialize() async {
    _preferences = await SharedPreferences.getInstance();
  }

  /// Returns a `bool` value for the specified [key]
  bool getBool(String key, {bool defaultValue = false}) {
    return _preferences.getBool(key) ?? defaultValue;
  }

  /// Returns a `double` value for the specified [key]
  double getDouble(String key, {double defaultValue = 0}) {
    return _preferences.getDouble(key) ?? defaultValue;
  }

  /// Returns a `String` value for the specified [key]
  String getString(String key, {String defaultValue = ''}) {
    return _preferences.getString(key) ?? defaultValue;
  }

  /// Set a `bool` value for the specified [key]
  void setBool(String key, bool value) => _preferences.setBool(key, value);

  /// Set a `double` value for the specified [key]
  void setDouble(String key, double value) {
    _preferences.setDouble(key, value);
  }

  /// Set a `String` value for the specified [key]
  void setString(String key, String value) {
    _preferences.setString(key, value);
  }
}
