import 'package:flutter/material.dart';
import 'package:flutter_exit_app/flutter_exit_app.dart';
import 'package:memoir/classes/assets.dart';
import 'package:memoir/classes/local_authenticator.dart';
import 'package:memoir/classes/routes.dart';
import 'package:memoir/classes/user_preferences.dart';
import 'package:memoir/extensions.dart';
import 'package:memoir/sheets/confirm_action.dart';

/// SplashScreen Page
///
/// Redirects to either [AuthenticationPage] or [SetupPage]
/// depending on whether master password is set or not after `1.5` Seconds
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(
      const Duration(seconds: 1, milliseconds: 500),
      () {
        if (LocalAuthenticator.instance.canAuthenticate &&
            UserPreferences.instance.appLock) {
          authenticate();
        } else {
          _navigateToNextPage();
        }
      },
    );
  }

  /// To authenticate user with device biometrics
  ///
  /// If the user does not authenticate or fails,
  /// and an BottomSheet is shown to give user another chance,
  /// and if still the user does not authenticate the applications exit
  void authenticate() {
    LocalAuthenticator.instance.authenticate().then((value) {
      if (value) {
        _navigateToNextPage();
      } else {
        showModalBottomSheet<bool>(
          elevation: 10,
          enableDrag: false,
          isDismissible: false,
          context: context,
          builder: (_) {
            String content = "Unlock with ";
            if (UserPreferences.instance.fingerprintOnly) {
              content += "Fingerprint";
            } else {
              content += "Pattern, PIN, Pattern, or Fingerprint";
            }

            return ConfirmActionSheet(
              title: "App Locked",
              content: content,
              declineText: "Exit",
              acceptText: "Unlock",
            );
          },
        ).then((unlock) {
          if (unlock ?? false) {
            authenticate();
          } else {
            FlutterExitApp.exitApp();
          }
        });
      }
    });
  }

  /// Navigate to [AuthenticationPage] if master password already exists otherwise to [SetupPage]
  void _navigateToNextPage() {
    if (UserPreferences.instance.masterPassword.isEmpty) {
      context.navigator.pushReplacementNamed(Routes.setup);
    } else {
      context.navigator.pushReplacementNamed(Routes.authentication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Hero(
                // Linked to Login and SetupMasterPassword Logo
                tag: 'Logo',
                child: Image.asset(
                  Assets.logo,
                  width: context.mediaQuery.size.width * 0.75,
                ),
              ),
              Text("Memoir", style: context.textTheme.titleLarge)
            ],
          ),
        ),
      ),
    );
  }
}
