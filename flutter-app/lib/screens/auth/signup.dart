import 'package:flutter/material.dart';

class SignupScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: Container(
          child: Column(
            children: [Text('Signup')],
          ),
        ),
      ),
    );
  }
}
