import 'package:flutter/material.dart';
import 'package:memoir/app/theme.dart';
import 'package:memoir/classes/user_preferences.dart';
import 'package:memoir/screens/home/home.dart';
import 'package:memoir/screens/settings/settings.dart';
import 'package:memoir/screens/splash_screen.dart';

/// Base [MaterialApp] Class
///
/// Handles the [ThemeMode] changes
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: UserPreferences.instance,
      builder: (_, __) {
        return MaterialApp(
          title: 'Memoir',
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: UserPreferences.instance.themeMode,
          initialRoute: '/splashScreen',
          routes: {
            '/splashScreen': (_) => const SplashScreen(),
            '/homePage': (_) => const HomePage(),
            '/settings': (_) => const Settings(),
          },
        );
      },
    );
  }
}
