import 'dart:async';

import 'package:flutter/material.dart';
import 'package:memoir/classes/local_storage.dart';
import 'package:memoir/classes/storage_keys.dart';

/// Manages the user preferences
///
/// Call [initializeStorage] before accessing data
abstract final class UserPreferences extends ChangeNotifier {
  /// [Listener], notifies after an [ThemeMode] change
  static ChangeNotifier themeNotifier = ChangeNotifier();

  /// For Storing Data on Disk
  static final LocalStorage _storage = LocalStorage();

  /// Initializes storage object
  static Future<void> initializeStorage() => _storage.initialize();

  /// ThemeMode of Application
  ///
  /// Default: `ThemeMode.system`
  ///
  /// Notifies any [Listener]s after change
  static ThemeMode get themeMode {
    String value = _storage.getString(
      StorageKey.themeMode,
      defaultValue: ThemeMode.system.name,
    );

    switch (value) {
      case "light":
        return ThemeMode.light;
      case "dark":
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  static set themeMode(ThemeMode value) {
    _storage.setString(StorageKey.themeMode, value.name);

    themeNotifier.notifyListeners();
  }

  /// Whether to require authentication at launch
  ///
  /// Sets [fingerprintOnly] to `false` when it is set to `false`
  ///
  /// Default: `false`
  static bool get appLock => _storage.getBool(StorageKey.appLock);
  static set appLock(bool value) {
    _storage.setBool(StorageKey.appLock, value);

    if (!appLock) {
      fingerprintOnly = false;
    }
  }

  /// Whether to use only fingerprint authentication
  ///
  /// It should not used without [appLock], thus it is set to `false` when [appLock] is set to `false`
  ///
  /// Default: `false`
  static bool get fingerprintOnly {
    return _storage.getBool(StorageKey.fingerprintOnly);
  }

  static set fingerprintOnly(bool value) {
    _storage.setBool(StorageKey.fingerprintOnly, value);
  }

  /// Master Password to access the vault
  static String get masterPassword {
    return _storage.getSecureValue(StorageKey.masterPassword);
  }

  static set masterPassword(String value) {
    _storage.setSecureValue(StorageKey.masterPassword, value);
  }

  /// AES Key
  ///
  /// Stored in `base64`
  ///
  /// Default: Empty
  static String get aesKey => _storage.getSecureValue(StorageKey.aesKey);
  static set aesKey(String value) {
    _storage.setSecureValue(StorageKey.aesKey, value);
  }

  /// RSA Public Key
  ///
  /// Stored in `base64`
  ///
  /// Default: Empty
  static String get publicKey => _storage.getSecureValue(StorageKey.publicKey);
  static set publicKey(String value) {
    _storage.setSecureValue(StorageKey.publicKey, value);
  }

  /// RSA Private Key
  ///
  /// Stored in `base64`
  ///
  /// Default: Empty
  static String get privateKey {
    return _storage.getSecureValue(StorageKey.privateKey);
  }

  static set privateKey(String value) {
    _storage.setSecureValue(StorageKey.privateKey, value);
  }

  /// Whether a random generated password contains Letters
  ///
  /// Default: `true`
  static bool get useLetters {
    return _storage.getBool(StorageKey.useLetters, defaultValue: true);
  }

  static set useLetters(bool value) {
    _storage.setBool(StorageKey.useLetters, value);
  }

  /// Whether a random generated password contains Uppercase Letters
  ///
  /// Default: `false`
  static bool get includeUppercase {
    return _storage.getBool(StorageKey.includeUppercase);
  }

  static set includeUppercase(bool value) {
    _storage.setBool(StorageKey.includeUppercase, value);
  }

  /// Whether a random generated password contains Numbers
  ///
  /// Default: `false`
  static bool get includeNumbers => _storage.getBool(StorageKey.includeNumbers);
  static set includeNumbers(bool value) {
    _storage.setBool(StorageKey.includeNumbers, value);
  }

  /// Whether a random generated password contains Special Characters
  ///
  /// Default: `false`
  static bool get includeSpecialChars {
    return _storage.getBool(StorageKey.includeSpecialChars);
  }

  static set includeSpecialChars(bool value) {
    _storage.setBool(StorageKey.includeSpecialChars, value);
  }

  /// Specifies the range in which the user can chose the password length for generating random password
  ///
  /// Default: `(Start: 1, End: 256)`
  static RangeValues get passwordLenRange {
    return RangeValues(
      _storage.getDouble(StorageKey.passwordLenRangeStart, defaultValue: 1),
      _storage.getDouble(StorageKey.passwordLenRangeEnd, defaultValue: 256),
    );
  }

  static set passwordLenRange(RangeValues values) {
    _storage.setDouble(StorageKey.passwordLenRangeStart, values.start);
    _storage.setDouble(StorageKey.passwordLenRangeEnd, values.end);
  }

  /// Length of a random generated password
  ///
  /// Default: `8`
  static double get passwordLen {
    return _storage.getDouble(StorageKey.passwordLen, defaultValue: 8);
  }

  static set passwordLen(double value) {
    _storage.setDouble(StorageKey.passwordLen, value);
  }

  /// Whether to give a override choice when importing a duplicate container
  ///
  /// Default: `true`
  static bool get showOverrideChoice {
    return _storage.getBool(StorageKey.showOverrideChoice, defaultValue: true);
  }

  static set showOverrideChoice(bool value) {
    _storage.setBool(StorageKey.showOverrideChoice, value);
  }

  /// Whether to keep the current container password or
  /// replace it with the new password when importing a duplicate container
  ///
  /// Used when [showOverrideChoice] is `false`
  ///
  /// Default: `false`
  static bool get keepNewPassword {
    return _storage.getBool(StorageKey.keepNewPassword);
  }

  static set keepNewPassword(bool value) {
    _storage.setBool(StorageKey.keepNewPassword, value);
  }
}
