import 'dart:async';

import 'package:flutter/material.dart';
import 'package:memoir/classes/local_storage.dart';
import 'package:memoir/classes/storage_keys.dart';

/// Manages the user preferences
///
/// The class is a [Listener], notifies after an [ThemeMode] change
///
/// It is Singleton class and data is to be accessed through [instance]
///
/// Call [initializeStorage] before accessing data
class UserPreferences extends ChangeNotifier {
  /// Actual Instance
  static final UserPreferences _instance = UserPreferences._();

  /// Singleton Instance
  static UserPreferences get instance => _instance;

  /// Default Constructor
  UserPreferences._();

  /// For Storing Data on Disk
  final LocalStorage _storage = LocalStorage();

  /// Initializes storage object
  Future<void> initializeStorage() {
    return _storage.initialize();
  }

  /// ThemeMode of Application
  ///
  /// Default: `ThemeMode.system`
  ///
  /// Notifies any [Listener]s after change
  ThemeMode get themeMode {
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

  set themeMode(ThemeMode value) {
    _storage.setString(StorageKey.themeMode, value.name);

    notifyListeners();
  }

  /// Master Password to access the vault
  String get masterPassword => _storage.getString(StorageKey.masterPassword);
  set masterPassword(String value) {
    _storage.setString(StorageKey.masterPassword, value);
  }

  /// Whether a random generated password contains Letters
  ///
  /// Default: `true`
  bool get useLetters {
    return _storage.getBool(StorageKey.useLetters, defaultValue: true);
  }

  set useLetters(bool value) => _storage.setBool(StorageKey.useLetters, value);

  /// Whether a random generated password contains Uppercase Letters
  ///
  /// Default: `false`
  bool get includeUppercase => _storage.getBool(StorageKey.includeUppercase);
  set includeUppercase(bool value) {
    _storage.setBool(StorageKey.includeUppercase, value);
  }

  /// Whether a random generated password contains Numbers
  ///
  /// Default: `false`
  bool get includeNumbers => _storage.getBool(StorageKey.includeNumbers);
  set includeNumbers(bool value) {
    _storage.setBool(StorageKey.includeNumbers, value);
  }

  /// Whether a random generated password contains Special Characters
  ///
  /// Default: `false`
  bool get includeSpecialChars {
    return _storage.getBool(StorageKey.includeSpecialChars);
  }

  set includeSpecialChars(bool value) {
    _storage.setBool(StorageKey.includeSpecialChars, value);
  }

  /// Specifies the range in which the user can chose the password length for generating random password
  ///
  /// Default: `(Start: 1, End: 256)`
  RangeValues get passwordLenRange {
    return RangeValues(
      _storage.getDouble(StorageKey.passwordLenRangeStart, defaultValue: 1),
      _storage.getDouble(StorageKey.passwordLenRangeEnd, defaultValue: 256),
    );
  }

  set passwordLenRange(RangeValues values) {
    _storage.setDouble(StorageKey.passwordLenRangeStart, values.start);
    _storage.setDouble(StorageKey.passwordLenRangeEnd, values.end);
  }

  /// Length of a random generated password
  ///
  /// Default: `8`
  double get passwordLen {
    return _storage.getDouble(StorageKey.passwordLen, defaultValue: 8);
  }

  set passwordLen(double value) {
    _storage.setDouble(StorageKey.passwordLen, value);
  }

  /// Whether to require authentication at launch
  ///
  /// Sets [fingerprintOnly] to `false` when it is set to `false`
  ///
  /// Default: `false`
  bool get appLock {
    return _storage.getBool(StorageKey.authenticateToAccessVault);
  }

  set appLock(bool value) {
    _storage.setBool(StorageKey.authenticateToAccessVault, value);

    if (!appLock) {
      fingerprintOnly = false;
    }
  }

  /// Whether to use only fingerprint authentication
  ///
  /// It should not used without [appLock], thus it is set to `false` when [appLock] is set to `false`
  ///
  /// Default: `false`
  bool get fingerprintOnly => _storage.getBool(StorageKey.fingerprintOnly);
  set fingerprintOnly(bool value) {
    _storage.setBool(StorageKey.fingerprintOnly, value);
  }

  /// Whether to give a override choice when importing a duplicate container
  ///
  /// Default: `true`
  bool get showOverrideChoice {
    return _storage.getBool(StorageKey.showOverrideChoice, defaultValue: true);
  }

  set showOverrideChoice(bool value) {
    _storage.setBool(StorageKey.showOverrideChoice, value);
  }

  /// Whether to keep the current container password or
  /// replace it with the new password when importing a duplicate container
  ///
  /// Used when [showOverrideChoice] is `false`
  ///
  /// Default: `false`
  bool get keepNewPassword {
    return _storage.getBool(StorageKey.keepNewPassword);
  }

  set keepNewPassword(bool value) {
    _storage.setBool(StorageKey.keepNewPassword, value);
  }
}
