import 'package:flutter/material.dart';
import 'package:salt/screens/app_splash_screen.dart';
import 'package:salt/screens/login.dart';
import 'package:salt/screens/signup.dart';

Map<String, Widget Function(BuildContext)> getRoutes(BuildContext context) {
  return {
    '/': (context) => const AppSplashScreen(),
    '/auth/signup': (context) => const SignupScreen(),
    '/auth/login': (context) => const LoginScreen(),
  };
}
