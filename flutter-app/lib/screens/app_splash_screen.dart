import 'package:flutter/material.dart';
import 'package:flare_splash_screen/flare_splash_screen.dart';

import '../design_system.dart';
import 'home.dart';

class AppSplashScreen extends StatelessWidget {
  const AppSplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SplashScreen.navigate(
        name: 'assets/flare/splash-screen.flr',
        next: (context) => const HomeScreen(),
        until: () => Future.delayed(const Duration(seconds: 4)),
        startAnimation: 'go',
        backgroundColor: DesignSystem.primary,
      ),
    );
  }
}
