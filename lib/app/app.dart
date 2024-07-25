import 'package:flutter/material.dart';
import 'package:memoir/app/theme.dart';
import 'package:memoir/classes/routes.dart';
import 'package:memoir/classes/user_preferences.dart';
import 'package:memoir/screens/qr_scanner.dart';
import 'package:memoir/screens/settings/appearance.dart';
import 'package:memoir/screens/settings/backup_restore.dart';
import 'package:memoir/screens/settings/password_generation.dart';
import 'package:memoir/screens/settings/security.dart';
import 'package:memoir/screens/vault/vault.dart';
import 'package:memoir/screens/authentication.dart';
import 'package:memoir/screens/settings/settings.dart';
import 'package:memoir/screens/setup.dart';
import 'package:memoir/screens/splash_screen.dart';
import 'package:secure_app_switcher/secure_app_switcher.dart';

/// Base [MaterialApp] Class
///
/// Handles the [ThemeMode] changes
class App extends StatelessWidget {
  const App({super.key});

  Route? _generateSensitiveRoutes(RouteSettings settings) {
    switch (settings.name) {
      case Routes.vault:
        return MaterialPageRoute(
          builder: (_) => const SecureAppSwitcherPage(child: VaultPage()),
          settings: settings,
        );
      case Routes.securitySettings:
        return MaterialPageRoute(
          builder: (_) {
            return const SecureAppSwitcherPage(child: SecuritySettings());
          },
          settings: settings,
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
          settings: settings,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: UserPreferences.themeNotifier,
      builder: (_, __) {
        SecureAppSwitcher.on();

        return MaterialApp(
          title: 'Memoir',
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: UserPreferences.themeMode,
          navigatorObservers: [secureAppSwitcherRouteObserver],
          initialRoute: '/splashScreen',
          onGenerateRoute: _generateSensitiveRoutes,
          routes: {
            Routes.splashScreen: (_) => const SplashScreen(),
            Routes.setup: (_) => const SetupPage(),
            Routes.authentication: (_) => const AuthenticationPage(),
            Routes.settings: (_) => const Settings(),
            Routes.appearanceSettings: (_) => const AppearanceSettings(),
            Routes.passwordGenerationSettings: (_) {
              return const PasswordGenerationSettings();
            },
            Routes.backupRestoreSettings: (_) => const BackupRestoreSettings(),
            Routes.qrScanner: (_) => const QRScannerPage(),
          },
        );
      },
    );
  }
}
