import 'package:local_auth/local_auth.dart';
import 'package:memoir/classes/user_preferences.dart';

/// Wrapper class for [LocalAuthentication]
///
/// Call [initialize] before accessing data
abstract final class LocalAuthenticator {
  /// `local_auth` plugin object for authentication
  static final LocalAuthentication _authentication = LocalAuthentication();

  /// Whether the user can authenticate meaning they have some device lock
  static late final bool canAuthenticate;

  /// Whether the user has fingerprint setup
  static late final bool hasFingerprint;

  /// Preforms initialization tasks
  static Future<void> initialize() async {
    canAuthenticate = await _authentication.canCheckBiometrics;

    if (canAuthenticate) {
      final List biometrics = await _authentication.getAvailableBiometrics();

      hasFingerprint = biometrics.contains(BiometricType.strong);
    }
  }

  /// Prompts the user to authenticate based on their preference i.e. fingerprint or not
  static Future<bool> authenticate() {
    return _authentication.authenticate(
      localizedReason: "Unlock",
      options: AuthenticationOptions(
        stickyAuth: true,
        biometricOnly: UserPreferences.fingerprintOnly,
      ),
    );
  }
}
