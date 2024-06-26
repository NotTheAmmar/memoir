import 'package:flutter/material.dart';

/// Defines short version of commonly accessed data using [BuildContext]
extension ContextExtensions on BuildContext {
  /// Equivalent to Theme.of(BuildContext)
  ThemeData get theme => Theme.of(this);

  /// Equivalent to Theme.of(BuildContext).colorScheme
  ColorScheme get colorScheme => theme.colorScheme;

  /// Equivalent to Theme.of(BuildContext).textTheme
  TextTheme get textTheme => theme.textTheme;

  /// Equivalent to MediaQuery.of(BuildContext)
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  /// Equivalent to Navigator.of(BuildContext)
  NavigatorState get navigator => Navigator.of(this);

  /// Equivalent to ScaffoldMessenger.of(BuildContext)
  ScaffoldMessengerState get messenger => ScaffoldMessenger.of(this);
}
