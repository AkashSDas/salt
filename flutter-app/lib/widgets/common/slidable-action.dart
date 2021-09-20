import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

class SlidableAction extends StatelessWidget {
  final String flareAssetPath;
  final String label;
  final Color color;
  final Function()? onTap;

  const SlidableAction({
    required this.flareAssetPath,
    required this.label,
    required this.color,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: color,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FlareActor(
              flareAssetPath,
              sizeFromArtboard: true,
              color: Colors.white,
            ),
            SizedBox(height: 16),
            Text(
              label,
              style: Theme.of(context).textTheme.subtitle1?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
