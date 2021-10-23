import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salt/design_system.dart';
import 'package:salt/providers/animated_drawer.dart';
import 'package:salt/providers/user.dart';
import 'package:salt/widgets/buttons/index.dart';

/// This app bar is for use in AnimatedDrawer
class AnimatedAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double appBarHeight;
  final AnimationController drawerCtrl;
  final AnimationController bodyCtrl;

  const AnimatedAppBar({
    required this.appBarHeight,
    required this.drawerCtrl,
    required this.bodyCtrl,
    Key? key,
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(appBarHeight);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: drawerCtrl,
      builder: (context, child) {
        return Container(
          alignment: Alignment.bottomCenter,
          color: Theme.of(context).appBarTheme.backgroundColor,
          height: appBarHeight * drawerCtrl.value,
          child: child,
        );
      },
      child: Container(
        height: appBarHeight,
        color: Theme.of(context).appBarTheme.backgroundColor,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildDrawerButton(context),
            const AnimatedAppBarProfilePic(),
          ],
        ),
      ),
    );
  }

  /// Drawer open button
  Widget _buildDrawerButton(BuildContext context) {
    final AnimatedDrawerProvider _provider =
        Provider.of<AnimatedDrawerProvider>(context);

    return IconButton(
      icon: const FlareActor(
        'assets/flare-icons/hamburger-menu.flr',
        alignment: Alignment.center,
        fit: BoxFit.contain,
        animation: 'idle',
      ),
      color: Theme.of(context).iconTheme.color,
      onPressed: () {
        _provider.toggleDrawerState();
        if (_provider.isDrawerOpen) {
          drawerCtrl.reverse();
          bodyCtrl.forward();
        } else {
          drawerCtrl.forward();
          bodyCtrl.reverse();
        }
      },
    );
  }
}

class AnimatedAppBarProfilePic extends StatelessWidget {
  const AnimatedAppBarProfilePic({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final UserProvider _user = Provider.of<UserProvider>(context);

    if (_user.token == null) {
      return RoundedCornerButton(
        horizontalPadding: 32,
        onPressed: () {},
        text: 'Sign up',
      );
    }

    return Container(
      height: 38,
      width: 38,
      decoration: BoxDecoration(
        color: DesignSystem.ebonyClay,
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: NetworkImage(_user.user?.profilePicURL ?? ''),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
