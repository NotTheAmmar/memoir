import 'dart:async';

import 'package:encrypt_shared_preferences/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Handles the storage of data
///
/// Call [initialize] before storing data
class LocalStorage {
  /// For Storing data in unsecured format, mainly for insensitive data
  late final SharedPreferences _preferences;

  /// For Storing data in secured format, mainly for sensitive data
  late final EncryptedSharedPreferences _securePreferences;

  /// Initializes [SharedPreferences]
  Future<void> initialize() async {
    _preferences = await SharedPreferences.getInstance();
    
    await EncryptedSharedPreferences.initialize(
      dotenv.env["SHARED_PREFERENCES_ENCRYPTION_KEY"]!,
    );
    _securePreferences = EncryptedSharedPreferences.getInstance();
  }

  /// Returns a `bool` value for the specified [key]
  bool getBool(String key, {bool defaultValue = false}) {
    return _preferences.getBool(key) ?? defaultValue;
  }

  /// Set a `bool` value for the specified [key]
  void setBool(String key, bool value) => _preferences.setBool(key, value);

  /// Returns a `double` value for the specified [key]
  double getDouble(String key, {double defaultValue = 0}) {
    return _preferences.getDouble(key) ?? defaultValue;
  }

  /// Set a `double` value for the specified [key]
  void setDouble(String key, double value) {
    _preferences.setDouble(key, value);
  }

  /// Returns a `String` value for the specified [key]
  String getString(String key, {String defaultValue = ''}) {
    return _preferences.getString(key) ?? defaultValue;
  }

  /// Set a `String` value for the specified [key]
  void setString(String key, String value) {
    _preferences.setString(key, value);
  }

  /// Returns `String` value from encrypted data
  String getSecureValue(String key, {String defaultValue = ''}) {
    return _securePreferences.getString(key) ?? defaultValue;
  }

  /// Sets a `String` value in encrypted form
  void setSecureValue(String key, String value) {
    _securePreferences.setString(key, value);
  }
}
