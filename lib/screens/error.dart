import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:memoir/assets.dart';
import 'package:memoir/extensions.dart';

/// Widget to show an Error when an exception occurs
class ErrorPage extends StatelessWidget {
  /// Error Details
  final FlutterErrorDetails errorDetails;

  const ErrorPage({super.key, required this.errorDetails});

  /// Restarts the Application
  void _restartApp(BuildContext context) {
    // First Removing every page from stack
    context.navigator.popUntil((_) => false);
    // Starting again from SplashScreen Page
    context.navigator.pushNamed('/splashScreen');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(10),
            width: context.mediaQuery.size.width,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  Assets.error,
                  width: context.mediaQuery.size.width * 0.25,
                ),
                const Gap(20),
                Text(
                  "An Error Occurred!",
                  style: context.textTheme.titleMedium?.copyWith(
                    color: context.colorScheme.onError,
                  ),
                ),
                const Gap(20),
                Text(
                  errorDetails.exceptionAsString(),
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.colorScheme.error,
                  ),
                ),
                const Gap(10),
                TextButton(
                  onPressed: () => _restartApp(context),
                  child: Text(
                    "Restart",
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: Colors.greenAccent,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
