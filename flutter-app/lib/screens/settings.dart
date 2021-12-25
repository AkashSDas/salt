import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:salt/design_system.dart';
import 'package:salt/widgets/animations/reveal.dart';
import 'package:salt/widgets/drawer/animate_appbar_on_scroll.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var baseDelay = 10;

    return AnimateAppBarOnScroll(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildRevealAnimation(
                Text('Settings', style: DesignSystem.heading1),
                baseDelay * 1,
              ),
              DesignSystem.spaceH20,
              _buildRevealAnimation(
                _SettingButton(
                  icon: const Icon(IconlyLight.profile),
                  label: 'Account',
                  onTap: () {},
                ),
                baseDelay * 2,
              ),
              _buildRevealAnimation(
                _SettingButton(
                  icon: const Icon(IconlyLight.wallet),
                  label: 'Payments',
                  onTap: () => Navigator.pushNamed(context, '/user/payment'),
                ),
                baseDelay * 3,
              ),
              _buildRevealAnimation(
                _SettingButton(
                  icon: const Icon(IconlyLight.buy),
                  label: 'My orders',
                  onTap: () => Navigator.pushNamed(
                    context,
                    '/user/product-orders',
                  ),
                ),
                baseDelay * 4,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

Widget _buildRevealAnimation(Widget child, int delay) {
  return RevealAnimation(
    child: child,
    startAngle: 30,
    delay: delay,
    startYOffset: 100,
    duration: 1000,
  );
}

/// Setting btn
class _SettingButton extends StatelessWidget {
  final Icon icon;
  final String label;
  final void Function()? onTap;

  const _SettingButton({
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
