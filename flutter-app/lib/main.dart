import 'package:flare_splash_screen/flare_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:salt/designs/designs.dart';
import 'package:salt/screens/auth/signup.dart';
import 'package:salt/screens/home.dart';

/// Run app
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Salt',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: DesignSystem.grey0,
          textTheme: DesignSystem.textTheme,
        ),
        routes: _getRoutes(context),
      );

  Map<String, Widget Function(BuildContext)> _getRoutes(BuildContext context) {
    return {
      '/': (context) => SplashScreen.navigate(
            height: 90,
            width: 90,
            name: 'assets/flare/logo.flr',
            next: (context) => HomeScreen(),
            until: () => Future.delayed(Duration(seconds: 3)),
            startAnimation: 'idle',
            backgroundColor: Theme.of(context).primaryColor,
          ),
      '/auth/signup': (context) => SignupScreen(),
    };
  }
}
