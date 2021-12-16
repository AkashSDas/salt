import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:salt/design_system.dart';
import 'package:salt/widgets/drawer/animate_appbar_on_scroll.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimateAppBarOnScroll(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              Text('Settings', style: DesignSystem.heading1),
              const SizedBox(height: 20),
              _SettingButtons(
                icon: const Icon(IconlyLight.profile),
                label: 'Account',
                onTap: () {},
              ),
              _SettingButtons(
                icon: const Icon(IconlyLight.wallet),
                label: 'Payments',
                onTap: () {
                  Navigator.pushNamed(context, '/user/payment');
                },
              ),
              _SettingButtons(
                icon: const Icon(IconlyLight.chat),
                label: 'My feedback',
                onTap: () {},
              ),
              _SettingButtons(
                icon: const Icon(IconlyLight.buy),
                label: 'My orders',
                onTap: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SettingButtons extends StatelessWidget {
  final Icon icon;
  final String label;
  final void Function()? onTap;

  const _SettingButtons({
    required this.icon,
    required this.label,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(6),
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
