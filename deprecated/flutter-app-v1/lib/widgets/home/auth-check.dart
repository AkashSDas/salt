import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salt/providers/user.dart';

/// To check auth info and return widget if authenticated
/// else return SizedBox()
class AuthCheck extends StatelessWidget {
  final Widget child;
  final bool displayOnAuth;

  const AuthCheck({
    required this.child,
    this.displayOnAuth = true,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final UserProvider _user = Provider.of<UserProvider>(context);
    if (displayOnAuth && _user.user != null) return child;
    if (!displayOnAuth && _user.user == null) return child;
    return SizedBox();
  }
}
