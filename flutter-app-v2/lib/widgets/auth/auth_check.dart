import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salt/providers/user.dart';

class AuthCheck extends StatelessWidget {
  final Widget child;
  final bool displayOnAuth; // on authenticated

  const AuthCheck({
    required this.child,
    this.displayOnAuth = true,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final UserProvider _user = Provider.of<UserProvider>(context);

    /// display when user is authenticated
    if (displayOnAuth && _user.user != null) return child;

    /// display when user is not authenticated
    if (!displayOnAuth && _user.user == null) return child;

    return const SizedBox();
  }
}
