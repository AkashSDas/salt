import 'package:flare_splash_screen/flare_splash_screen.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'salt',
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => SafeArea(
              child: SplashScreen.navigate(
                name: 'assets/flare/splash-screen.flr',
                next: (context) => const HomeScreen(),
                until: () => Future.delayed(const Duration(seconds: 4)),
                startAnimation: 'go',
              ),
            )
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(),
      ),
    );
  }
}
