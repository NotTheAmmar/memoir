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

  /// Whether the user can authenticate meaning the user must have a fingerprint setup
  late final bool canAuthenticate;

  /// Preforms initialization tasks
  Future<void> initialize() async {
    if (await _authentication.canCheckBiometrics) {
      final List<BiometricType> biometrics =
          await _authentication.getAvailableBiometrics();

      canAuthenticate = biometrics.contains(BiometricType.strong);
    } else {
      canAuthenticate = false;
    }
  }

  /// Prompts the user to authenticate with fingerprint only
  Future<bool> authenticate() {
    return _authentication.authenticate(
      localizedReason: "Verify your Identity",
      options: AuthenticationOptions(
        stickyAuth: true,
        biometricOnly: UserPreferences.instance.fingerprintOnly,
      ),
    );
  }
}
