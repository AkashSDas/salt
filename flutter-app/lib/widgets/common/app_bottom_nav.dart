import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import 'package:salt/providers/animated_drawer.dart';

import '../../design_system.dart';

class AppBottomNav extends StatelessWidget {
  final int currentIdx;
  const AppBottomNav({required this.currentIdx, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<AnimatedDrawerProvider>(context);
    AnimationController _drawerCtrl = Get.find(
      tag: 'drawerCtrl${_provider.uniqueTag}',
    );
    AnimationController _bodyCtrl = Get.find(
      tag: 'bodyCtrl${_provider.uniqueTag}',
    );

    return AnimatedBuilder(
      animation: _bodyCtrl,
      builder: (context, child) {
        return GestureDetector(
          onTap: () {
            if (_provider.isOpen) {
              _provider.toggleDrawerState();
              _drawerCtrl.forward();
              _bodyCtrl.reverse();
            }
          },
          child: Transform.translate(
            // offset: const Offset(Container, 0),
            offset: Offset(
              /// Width of body that will be visible when the drawer is open
              MediaQuery.of(context).size.width * 0.6 * _bodyCtrl.value,
              0,
            ),

            /// Wrapping bottom nav with Theme to change bg color of bottom nav
            child: Theme(
              data:
                  Theme.of(context).copyWith(canvasColor: DesignSystem.primary),
              child: AbsorbPointer(
                absorbing: _provider.isOpen ? true : false,
                child: BottomNavigationBar(
                  items: _navItems(),
                  onTap: (int idx) => _onTap(idx, context),
                  showUnselectedLabels: false,
                  showSelectedLabels: false,
                  currentIndex: currentIdx,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  List<BottomNavigationBarItem> _navItems() {
    return const [
      BottomNavigationBarItem(icon: Icon(IconlyLight.home), label: 'Home'),
      BottomNavigationBarItem(icon: Icon(IconlyLight.bag), label: 'Shop'),
      BottomNavigationBarItem(
        icon: Icon(IconlyLight.plus),
        label: 'Create Post',
      ),
      BottomNavigationBarItem(icon: Icon(IconlyLight.document), label: 'Posts'),
      BottomNavigationBarItem(icon: Icon(IconlyLight.profile), label: 'User'),
    ];
  }

  void _onTap(int idx, BuildContext context) async {
    switch (idx) {
      case 0:
        Navigator.pushNamed(context, '/');
        break;
      case 1:
        break;
      case 2:
        break;
      case 3:
        break;
      case 4:
        break;
    }
  }
}
