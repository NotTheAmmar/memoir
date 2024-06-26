import 'package:flutter/material.dart';
import 'package:memoir/assets.dart';
import 'package:memoir/extensions.dart';

/// SplashScreen Page
///
/// Redirects to [HomePage] after `4` Seconds
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  /// Logo Animation Controller
  late final AnimationController _animation;

  @override
  void initState() {
    super.initState();

    _animation = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    Future.delayed(
      const Duration(seconds: 3),
      () => context.navigator.pushReplacementNamed('/homePage'),
    );
  }

  @override
  void dispose() {
    _animation.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Hero(
          // Linked to HomePage AppBar Logo
          tag: 'Logo',
          child: RotationTransition(
            turns: _animation,
            child: Container(
              width: context.mediaQuery.size.width * 0.75,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(image: AssetImage(Assets.logo)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
