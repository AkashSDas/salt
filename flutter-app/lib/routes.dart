import 'package:flutter/material.dart';
import 'package:salt/screens/home.dart';

Map<String, Widget Function(BuildContext)> getRoutes(BuildContext context) {
  return {
    '/': (context) => const HomeScreen(),
  };
}
