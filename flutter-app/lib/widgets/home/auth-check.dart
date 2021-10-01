import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salt/providers/user.dart';

/// To check auth info and return widget if authenticated
/// else return SizedBox()
class AuthCheck extends StatelessWidget {
  final Widget child;
  const AuthCheck({required this.child, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final UserProvider _user = Provider.of<UserProvider>(context);
    if (_user.user == null) return SizedBox();
    return child;
  }
}
