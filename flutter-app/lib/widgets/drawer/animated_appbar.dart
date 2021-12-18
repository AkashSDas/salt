import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:salt/providers/animated_drawer.dart';
import 'package:salt/widgets/common/buttons.dart';
import 'package:salt/widgets/common/display_on_auth.dart';

/// This [AppBar] should be used with [AnimatedDrawer] and its important to use
/// this with that because in [AnimatedDrawer] [drawerCtrl] is defined and is
/// passed down as dependency. Without [AnimatedDrawer] this will throw error
/// while accessing [drawerCtrl]
class AnimatedAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// This appbar height should be in sync with AnimatedDrawerProvider appbar height
  final double appBarHeight = 80 + 32;

  const AnimatedAppBar({Key? key}) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(appBarHeight);

  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<AnimatedDrawerProvider>(context);

    return _AppBarAnimation(
      child: Container(
        height: _provider.appbarHeight,
        color: Theme.of(context).appBarTheme.backgroundColor,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [_DrawerToggleButton(), _Actions()],
        ),
      ),
    );
  }
}

/// This will handle the appbar animation
class _AppBarAnimation extends StatelessWidget {
  final Widget child;
  const _AppBarAnimation({required this.child, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<AnimatedDrawerProvider>(context);
    AnimationController _drawerCtrl = Get.find(
      tag: 'drawerCtrl${_provider.uniqueTag}',
    );

    return AnimatedBuilder(
      animation: _drawerCtrl,
      builder: (context, child) {
        return Container(
          alignment: Alignment.bottomCenter,
          decoration: BoxDecoration(
            color: Theme.of(context).appBarTheme.backgroundColor,
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, 2),
                blurRadius: 6,
                color: Colors.black.withOpacity(
                  _provider.appbarBoxShadowOpacity,
                ),
              ),
            ],
          ),
          height: _provider.appbarHeight * _drawerCtrl.value,
          child: child,
        );
      },
      child: child,
    );
  }
}

/// This will have the left side content of [AnimatedAppBar]
class _Actions extends StatelessWidget {
  const _Actions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildSearchBtn(context),
        const SizedBox(width: 8),
        _buildCartBtn(context),
        _buildSignupBtn(context),
      ],
    );
  }

  Widget _buildSearchBtn(BuildContext context) {
    return IconButton(
      onPressed: () => Navigator.pushNamed(context, '/search'),
      icon: const FlareActor(
        'assets/flare/icons/search-icon.flr',
        alignment: Alignment.center,
        fit: BoxFit.contain,
        animation: 'idle',
      ),
    );
  }

  Widget _buildCartBtn(BuildContext context) {
    return DisplayOnAuth(
      child: IconButton(
        onPressed: () => Navigator.pushNamed(context, '/user/cart'),
        icon: const FlareActor(
          'assets/flare/icons/cart-icon.flr',
          alignment: Alignment.center,
          fit: BoxFit.contain,
          animation: 'idle',
        ),
      ),
    );
  }

  Widget _buildSignupBtn(BuildContext context) {
    return DisplayOnNoAuth(
      child: PrimaryButton(
        text: 'Signup',
        onPressed: () => Navigator.pushNamed(context, '/auth/signup'),
        horizontalPadding: 64,
      ),
    );
  }
}

/// When `Icon` widget is used in `icon` of `IconButton`, even if the
/// `AnimatedAppBar` height is reduced to 0, the `IconButton` won't shrink in height,
/// it would just go at the top and that's it therefore [FlareActor] is used
/// to display custom icons
class _DrawerToggleButton extends StatelessWidget {
  const _DrawerToggleButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<AnimatedDrawerProvider>(context);
    AnimationController _drawerCtrl = Get.find(
      tag: 'drawerCtrl${_provider.uniqueTag}',
    );
    AnimationController _bodyCtrl = Get.find(
      tag: 'bodyCtrl${_provider.uniqueTag}',
    );

    return IconButton(
      icon: const FlareActor(
        'assets/flare/icons/menu-icon.flr',
        alignment: Alignment.center,
        fit: BoxFit.contain,
        animation: 'idle',
      ),
      onPressed: () {
        _provider.toggleDrawerState();
        if (_provider.isOpen) {
          _drawerCtrl.reverse();
          _bodyCtrl.forward();
        } else {
          _drawerCtrl.forward();
          _bodyCtrl.reverse();
        }
      },
    );
  }
}
