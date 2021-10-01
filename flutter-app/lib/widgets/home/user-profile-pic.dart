import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salt/designs/designs.dart';
import 'package:salt/providers/user.dart';
import 'package:salt/widgets/home/auth-check.dart';

class UserProfilePic extends StatelessWidget {
  const UserProfilePic({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final UserProvider _user = Provider.of<UserProvider>(context);

    return AuthCheck(
      child: Container(
        width: 115,
        height: 115,
        decoration: BoxDecoration(
          color: DesignSystem.grey1,
          shape: BoxShape.circle,
          image: DecorationImage(
            image: NetworkImage(
              _user.user != null ? _user.user!.profilePicURL : '',
            ),
          ),
        ),
      ),
    );
  }
}
