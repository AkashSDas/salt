import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:salt/designs/designs.dart';

class AnimatedDrawerItem extends StatelessWidget {
  final String flareAssetPath;
  final String title;
  final void Function()? onTap;

  const AnimatedDrawerItem({
    required this.flareAssetPath,
    required this.title,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap != null ? onTap : () {},
      child: Container(
        height: 44,

        /// While testing the app in development in mobile phone
        /// whithout the color property if i clicked on side of the text i.e. this container
        /// and not on text or icon then nothing happens i.e. onTap of GestureDetector is
        /// not triggered, but once i give color (it takes the entire width, which i think
        /// it didn't took without color property) it onTap of GestureDetector is triggered
        /// when i clicked on side of the text. Having width: double.infinity didn't worked
        /// either and i didn't tried with fixed width
        color: Colors.transparent,

        child: Row(
          children: [
            _buildIcon(),
            SizedBox(width: 16),
            _buildTitle(),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon() {
    return Container(
      width: 24,
      height: 24,
      child: AspectRatio(
        aspectRatio: 1,
        child: FlareActor(
          flareAssetPath,
          alignment: Alignment.center,
          fit: BoxFit.contain,
          animation: 'idle',
          color: DesignSystem.grey3,
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      title,
      style: TextStyle(
        color: DesignSystem.grey3,
        fontFamily: DesignSystem.fontBody,
        fontWeight: FontWeight.w500,
        fontSize: 15,
      ),
    );
  }
}
