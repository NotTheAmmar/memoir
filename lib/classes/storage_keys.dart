/// Contains Keys for storing various data in [SharedPreferences]
abstract final class StorageKey {
  /// Theme Mode Key
  static const String themeMode = "themeMode";

  /// Master Password Key
  static const String masterPassword = "masterPassword";

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
  static const String authenticateToAccessVault = "authenticateToAccessVault";

  /// Fingerprint only Authentication Key
  static const String fingerprintOnly = "fingerprintOnly";

  /// Override Choice Key
  static const String showOverrideChoice = "showOverrideChoice";

  /// Password Keep Key
  static const String keepNewPassword = "keepNewPassword";
}
