import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salt/providers/user_provider.dart';

/// Display [child] when the user is authenticated in the app i.e.
/// [UserProvider]'s `user` and `token` are not null. If user is not
/// authenticated then the widget built is [SizedBox] with no height & width
class DisplayOnAuth extends StatelessWidget {
  final Widget child;
  const DisplayOnAuth({required this.child, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<UserProvider>(context);
    return _user.token == null ? const SizedBox() : child;
  }
}

/// Display [child] when the user is `not` authenticated in the app i.e.
/// [UserProvider]'s `user` and `token` are null. If user is
/// authenticated then the widget built is [SizedBox] with no height & width
class DisplayOnNoAuth extends StatelessWidget {
  final Widget child;
  const DisplayOnNoAuth({required this.child, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<UserProvider>(context);
    return _user.token != null ? const SizedBox() : child;
  }
}
