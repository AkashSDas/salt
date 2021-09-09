import 'package:flutter/material.dart';

/// Run app
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Salt',
      debugShowCheckedModeBanner: false,
      home: Container(),
    );
  }
}
