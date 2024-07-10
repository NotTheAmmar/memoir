import 'package:local_auth/local_auth.dart';
import 'package:memoir/classes/user_preferences.dart';

/// Wrapper class for [LocalAuthentication]
///
/// It is a singleton class and data is to be accessed through [instance]
///
/// Call [initialize] before accessing data
class LocalAuthenticator {
  /// Default Private Constructor
  LocalAuthenticator._();

  /// Actual Instance
  static final LocalAuthenticator _instance = LocalAuthenticator._();

  /// Singleton instance
  static LocalAuthenticator get instance => _instance;

  /// `local_auth` plugin object for authentication
  final LocalAuthentication _authentication = LocalAuthentication();

  /// Whether the user can authenticate meaning they have some device lock
  late final bool canAuthenticate;

  /// Whether the user has fingerprint setup
  late final bool hasFingerprint;

  /// Preforms initialization tasks
  Future<void> initialize() async {
    canAuthenticate = await _authentication.canCheckBiometrics;

    if (canAuthenticate) {
      final List<BiometricType> biometrics =
          await _authentication.getAvailableBiometrics();

      hasFingerprint = biometrics.contains(BiometricType.strong);
    }
  }

  /// Prompts the user to authenticate based on their preference i.e. fingerprint or not
  Future<bool> authenticate() {
    return _authentication.authenticate(
      localizedReason: "Unlock",
      options: AuthenticationOptions(
        stickyAuth: true,
        biometricOnly: UserPreferences.instance.fingerprintOnly,
      ),
    );
  }
}
