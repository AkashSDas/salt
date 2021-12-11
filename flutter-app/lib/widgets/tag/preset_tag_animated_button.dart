import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

class PresetTagAnimatedButton extends StatelessWidget {
  final String flareFilename;

  const PresetTagAnimatedButton({
    required this.flareFilename,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 63,
      width: 63,
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(32),
      ),
      child: FlareActor(
        'assets/flare/tags-section/$flareFilename.flr',
        alignment: Alignment.center,
        fit: BoxFit.contain,
        animation: 'blink',
      ),
    );
  }
}
