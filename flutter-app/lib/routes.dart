import 'package:flutter/material.dart';
import 'package:salt/screens/app_splash_screen.dart';

Map<String, Widget Function(BuildContext)> getRoutes(BuildContext context) {
  return {
    '/': (context) => const AppSplashScreen(),
  };
}
