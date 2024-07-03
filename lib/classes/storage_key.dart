/// Contains Keys for storing various data
abstract final class StorageKey {
  /// Theme Mode Key
  static const String themeMode = "themeMode";

  /// Use Letters Key
  static const String useLetters = "useLetters";

  /// Include Uppercase Key
  static const String includeUppercase = "includeUppercase";

  /// Include Numbers Key
  static const String includeNumbers = "includeNumbers";

  /// Include Special Characters Key
  static const String includeSpecialChars = "includeSpecialChars";

  /// Password Length Range Key for `start`
  static const String passwordLenRangeStart = "passwordLenRangeStart";

  /// Password Length Range Key for `end`
  static const String passwordLenRangeEnd = "passwordLenRangeEnd";

  /// Password Length Key
  static const String passwordLen = "passwordLen";

  /// Authentication Key
  static const String authenticateOnLaunch = "authenticationOnLaunch";

  /// Fingerprint only Authentication Key
  static const String fingerprintOnly = "fingerprintOnly";
}
