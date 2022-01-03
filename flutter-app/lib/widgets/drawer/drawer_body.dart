import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import 'package:salt/design_system.dart';
import 'package:salt/providers/animated_drawer.dart';
import 'package:salt/widgets/animations/reveal.dart';
import 'package:salt/widgets/common/cool.dart';
import 'package:salt/widgets/common/display_on_auth.dart';

/// This the drawer for [AnimatedDrawer].
///
/// When this is opened, there is some space in the bottom (`margin`).
/// This happens in screens where [AnimatedDrawer] is used with `bottom nav bar`
/// and that space in the bottom is of the height of `bottom nav bar`. This
/// space is for `bottom nav bar` which is also translated to the right when
/// [AnimatedDrawer] is opened
class DrawerBody extends StatelessWidget {
  const DrawerBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<AnimatedDrawerProvider>(context);
    AnimationController _drawerCtrl = Get.find(
      tag: 'drawerCtrl${_provider.uniqueTag}',
    );
    AnimationController _bodyCtrl = Get.find(
      tag: 'bodyCtrl${_provider.uniqueTag}',
    );

    /// This function should be whenever a [DrawerBody] item is clicked,
    /// except for [LogoTV] as it only for animation and nothing else
    void _closeDrawer() {
      _provider.toggleDrawerState();
      _drawerCtrl.forward();
      _bodyCtrl.reverse();
    }

    return Container(
      // width of the drawer
      width: MediaQuery.of(context).size.width * 0.5,

      height: MediaQuery.of(context).size.height,
      padding: const EdgeInsets.all(16),
      color: Theme.of(context).primaryColor,
      child: ListView(
        children: [
          const LogoTV(),
          DesignSystem.spaceH20,
          DisplayOnAuth(child: _DrawerBodySection1(closeDrawer: _closeDrawer)),
          DesignSystem.spaceH20,
          _DrawerBodySection2(closeDrawer: _closeDrawer),
        ],
      ),
    );
  }
}

/// Drawer body section 1
class _DrawerBodySection1 extends StatelessWidget {
  final Function closeDrawer;

  const _DrawerBodySection1({
    Key? key,
    required this.closeDrawer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _DrawerItemRevealAnimation(
          child: _DrawerListTile(
            icon: const Icon(IconlyLight.plus),
            label: 'Create post',
            onTap: () {
              closeDrawer();
              Navigator.pushNamed(context, '/user/post/create');
            },
          ),
        ),
        _DrawerItemRevealAnimation(
          child: _DrawerListTile(
            icon: const Icon(IconlyLight.document),
            label: 'My posts',
            onTap: () {
              closeDrawer();
              Navigator.pushNamed(context, '/user/posts');
            },
          ),
        ),
        _DrawerItemRevealAnimation(
          child: _DrawerListTile(
            icon: const Icon(IconlyLight.buy),
            label: 'My orders',
            onTap: () {
              closeDrawer();
              Navigator.pushNamed(context, '/user/product-orders');
            },
          ),
        ),
      ],
    );
  }
}

/// Drawer elements reveal animation
class _DrawerItemRevealAnimation extends StatelessWidget {
  final Widget child;

  const _DrawerItemRevealAnimation({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RevealAnimation(
      child: child,
      startAngle: 30,
      delay: 10,
      startYOffset: 100,
      duration: 1000,
    );
  }
}

/// Drawer body section 2
class _DrawerBodySection2 extends StatelessWidget {
  final Function closeDrawer;

  const _DrawerBodySection2({
    Key? key,
    required this.closeDrawer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DisplayOnAuth(
          child: _DrawerItemRevealAnimation(
            child: _DrawerListTile(
              icon: const Icon(IconlyLight.setting),
              label: 'Settings',
              onTap: () {
                closeDrawer();
                Navigator.pushNamed(context, '/settings');
              },
            ),
          ),
        ),
        _DrawerItemRevealAnimation(
          child: DisplayOnNoAuth(
            child: _DrawerListTile(
              icon: const Icon(IconlyLight.profile),
              label: 'Login',
              onTap: () {
                closeDrawer();
                Navigator.pushNamed(context, '/auth/login');
              },
            ),
          ),
        ),
        _DrawerItemRevealAnimation(
          child: _DrawerListTile(
            icon: const Icon(IconlyLight.info_circle),
            label: 'About',
            onTap: () {},
          ),
        ),
        _DrawerItemRevealAnimation(
          child: _DrawerListTile(
            icon: const Icon(IconlyLight.user_1),
            label: 'Developers',
            onTap: () {},
          ),
        ),
      ],
    );
  }
}

/// This is a list item for [DrawerBody] and its like a [ListTile]
class _DrawerListTile extends StatelessWidget {
  final Icon icon;
  final String label;
  final void Function()? onTap;

  const _DrawerListTile({
    Key? key,
    required this.icon,
    required this.label,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(32),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap ?? () {},
        child: Container(
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          color: Colors.transparent,
          child: _buildContent(),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        icon,
        const SizedBox(width: 16),
        Text(label, style: DesignSystem.medium),
      ],
    );
  }
}
