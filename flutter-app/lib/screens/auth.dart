import 'package:flutter/material.dart';
import 'package:salt/designs/designs.dart';
import 'package:salt/widgets/auth-screen/body.dart';

class AuthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: Container(
          width: double.infinity,
          margin: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(32),
            boxShadow: DesignSystem.subtleBoxShadow,
          ),
          child: Body(),
        ),
      ),
    );
  }
}
