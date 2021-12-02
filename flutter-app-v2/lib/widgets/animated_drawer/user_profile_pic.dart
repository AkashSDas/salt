import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salt/providers/user.dart';
import 'package:salt/widgets/animated_drawer/drawer_logo.dart';

class UserProfilePic extends StatelessWidget {
  const UserProfilePic({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final UserProvider _user = Provider.of<UserProvider>(context);

    /// User profile pic
    if (_user.token != null && _user.user != null) {
      return Container(
        width: 115,
        height: 115,
        decoration: BoxDecoration(
          color: Theme.of(context).iconTheme.color,
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
            image: NetworkImage(_user.user!.profilePicURL),
            fit: BoxFit.cover,
          ),
        ),
      );
    }

    /// Logo
    return const DrawerLogo();
  }
}
