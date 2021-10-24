import 'package:flutter/material.dart';
import 'package:salt/utils/animated_drawer.dart';
import 'package:salt/widgets/animated_drawer/drawer_section.dart';
import 'package:salt/widgets/animated_drawer/user_profile_pic.dart';
import 'package:salt/widgets/auth/auth_check.dart';
import 'package:salt/widgets/buttons/index.dart';

class DrawerBody extends StatelessWidget {
  final AnimationController bodyCtrl;
  final AnimationController drawerCtrl;

  const DrawerBody({
    required this.bodyCtrl,
    required this.drawerCtrl,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      /// width of the drawer
      width: MediaQuery.of(context).size.width * 0.5,

      height: MediaQuery.of(context).size.height,
      padding: const EdgeInsets.all(16),
      color: Theme.of(context).primaryColor,
      child: ListView(
        children: [
          const UserProfilePic(),
          const SizedBox(height: 16),
          DrawerSection(
            sectionData: drawerSection1,
            bodyCtrl: bodyCtrl,
            drawerCtrl: drawerCtrl,
          ),
          const SizedBox(height: 16),
          DrawerSection(
            sectionData: drawerSection2,
            bodyCtrl: bodyCtrl,
            drawerCtrl: drawerCtrl,
          ),
          const AuthCheck(displayOnAuth: false, child: SizedBox(height: 16)),
          AuthCheck(
            displayOnAuth: false,
            child: RoundedCornerButton(
              text: 'Sign up',
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}
