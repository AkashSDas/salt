import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:salt/routes.dart';

import 'design_system.dart';

void main() {
  runApp(const MyApp());

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: DesignSystem.primary,
      statusBarColor: DesignSystem.primary,
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'salt',
      debugShowCheckedModeBanner: false,
      theme: DesignSystem.theme,
      routes: getRoutes(context),
    );
  }
}
