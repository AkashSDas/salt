import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../providers/animated_drawer.dart';
import '../common/buttons.dart';

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

    return Container(
      // width of the drawer
      width: MediaQuery.of(context).size.width * 0.5,

      height: MediaQuery.of(context).size.height,
      padding: const EdgeInsets.all(16),
      color: Theme.of(context).primaryColor,
      child: ListView(
        children: [
          SecondaryButton(
            text: 'Close',
            onPressed: () {
              /// Closing drawer
              _provider.toggleDrawerState();
              _drawerCtrl.forward();
              _bodyCtrl.reverse();
            },
          ),
        ],
      ),
    );
  }
}
