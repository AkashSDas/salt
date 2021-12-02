import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salt/providers/user.dart';
import 'package:salt/widgets/home/auth-check.dart';

class UserName extends StatelessWidget {
  const UserName({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final UserProvider _user = Provider.of<UserProvider>(context);

    return AuthCheck(
      child: Text(
        _user.user != null ? _user.user!.username : 'No name',
        style: Theme.of(context).textTheme.bodyText1?.copyWith(
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
      ),
    );
  }
}

class UserEmailAddress extends StatelessWidget {
  const UserEmailAddress({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final UserProvider _user = Provider.of<UserProvider>(context);
    return AuthCheck(
      child: Text(
        _user.user != null ? _user.user!.email : 'No email',
        style: Theme.of(context).textTheme.subtitle1?.copyWith(
              fontWeight: FontWeight.w400,
            ),
      ),
    );
  }
}
