import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import 'package:salt/design_system.dart';

import '../../providers/animated_drawer.dart';

/// The [DrawerBody]'s height is less than the [AppBottomNav]'s
/// height (even if the [AppBottomNav] is traslated when drawer
/// is opened)
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
          const LogoTV(),
          const SizedBox(height: 10),
          Column(
            children: [
              _DrawerBodyButton(
                icon: const Icon(IconlyLight.bag),
                label: 'Shop',
                onTap: () {},
              ),
              _DrawerBodyButton(
                icon: const Icon(IconlyLight.plus),
                label: 'Create post',
                onTap: () {},
              ),
              _DrawerBodyButton(
                icon: const Icon(IconlyLight.document),
                label: 'My posts',
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: 10),
          Column(
            children: [
              _DrawerBodyButton(
                icon: const Icon(IconlyLight.setting),
                label: 'Settings',
                onTap: () {},
              ),
              _DrawerBodyButton(
                icon: const Icon(IconlyLight.info_circle),
                label: 'About',
                onTap: () {},
              ),
              _DrawerBodyButton(
                icon: const Icon(IconlyLight.user_1),
                label: 'Developers',
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class LogoTV extends StatefulWidget {
  const LogoTV({Key? key}) : super(key: key);

  @override
  State<LogoTV> createState() => _LogoTVState();
}

class _LogoTVState extends State<LogoTV> {
  bool toggle = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => toggle = !toggle),
      child: SizedBox(
        height: 120,
        width: 120,
        child: FlareActor(
          'assets/flare/other-emojis/tv.flr',
          alignment: Alignment.center,
          fit: BoxFit.contain,
          animation: !toggle ? 'logo' : 'color change',
        ),
      ),
    );
  }
}

class _DrawerBodyButton extends StatelessWidget {
  final Icon icon;
  final String label;
  final void Function()? onTap;

  const _DrawerBodyButton({
    required this.icon,
    required this.label,
    required this.onTap,
    Key? key,
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

          /// While testing the app in development in mobile phone
          /// whithout the color property if i clicked on side of the text i.e. this container
          /// and not on text or icon then nothing happens i.e. onTap of GestureDetector is
          /// not triggered, but once i give color (it takes the entire width, which i think
          /// it didn't took without color property) it onTap of GestureDetector is triggered
          /// when i clicked on side of the text. Having width: double.infinity didn't worked
          /// either and i didn't tried with fixed width
          color: Colors.transparent,

          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              icon,
              const SizedBox(width: 16),
              Text(label, style: DesignSystem.medium),
            ],
          ),
        ),
      ),
    );
  }
}
