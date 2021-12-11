import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:flare_flutter/flare_actor.dart';

import '../../providers/animated_drawer.dart';

/// This app bar should be used in conjunction with `AnimatedDrawer` only
class AnimatedAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double appBarHeight = 80 + 32;
  const AnimatedAppBar({Key? key}) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(appBarHeight);

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
      child: Container(
        height: _provider.appbarHeight,
        color: Theme.of(context).appBarTheme.backgroundColor,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            _DrawerToggleButton(),
          ],
        ),
      ),
    );
  }
}

/// **NOTE**: When `Icon` widget is used in `icon` of `IconButton`, even if the
/// `AnimatedAppBar` height is reduced to 0, the `IconButton` won't shrink in height,
/// it would just go at the top and that's it
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
