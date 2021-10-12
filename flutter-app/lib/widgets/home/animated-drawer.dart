import 'package:flutter/material.dart';
import 'package:salt/utils/animated-drawer/items-data.dart';
import 'package:salt/widgets/common/btns.dart';
import 'package:salt/widgets/home/animated-drawer-item.dart';
import 'package:salt/widgets/home/animated-drawer-section.dart';
import 'package:salt/widgets/home/auth-check.dart';
import 'package:salt/widgets/home/user-info.dart';
import 'package:salt/widgets/home/user-profile-pic.dart';

class AnimatedDrawer extends StatefulWidget {
  const AnimatedDrawer({Key? key}) : super(key: key);

  @override
  _AnimatedDrawerState createState() => _AnimatedDrawerState();
}

class _AnimatedDrawerState extends State<AnimatedDrawer> {
  Widget _buildSpace(double space) => AuthCheck(child: SizedBox(height: space));

  List<Widget> _buildUserInfo() => [
        UserName(),
        _buildSpace(8),
        UserEmailAddress(),
      ];

  Widget _buildLoginBtn() => AuthCheck(
        displayOnAuth: false,
        child: AnimatedDrawerItem(
          flareAssetPath: getFlareAssetPath('user'),
          title: 'Login',
          onTap: () => Navigator.pushNamed(context, '/auth'),
        ),
      );

  Widget _buildSignUpBtn() => AuthCheck(
        displayOnAuth: false,
        child: ExpandedButton(
          text: 'Sign up',
          onPressed: () => Navigator.pushNamed(context, '/auth'),
        ),
      );

  Widget _buildListView() {
    return ListView(
      children: [
        UserProfilePic(),
        _buildSpace(16),
        ..._buildUserInfo(),
        _buildSpace(16),
        AnimatedDrawerSection(items: getAnimatedDrawerItemsData(context, 1)),
        SizedBox(height: 16),
        AnimatedDrawerSection(items: getAnimatedDrawerItemsData(context, 2)),
        SizedBox(height: 16),
        _buildLoginBtn(),
        _buildSpace(16),
        _buildSignUpBtn(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.5,
      height: MediaQuery.of(context).size.height,
      padding: EdgeInsets.all(16),
      color: Theme.of(context).primaryColor,
      child: _buildListView(),
    );
  }
}
