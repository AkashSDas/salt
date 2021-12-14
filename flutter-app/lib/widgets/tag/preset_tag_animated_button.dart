import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:salt/design_system.dart';
import 'package:salt/screens/tag.dart';

class PresetTagAnimatedButton extends StatelessWidget {
  final String id;
  final String flareFilename;

  const PresetTagAnimatedButton({
    required this.id,
    required this.flareFilename,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TagScreen(tagId: id)),
        );
      },
      child: Container(
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
      ),
    );
  }
}

class PresetTag extends StatelessWidget {
  final String label;
  final String flareFilename;

  const PresetTag({
    required this.label,
    required this.flareFilename,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 63,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 63,
            width: 63,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: FlareActor(
              'assets/flare/tags-section/$flareFilename.flr',
              alignment: Alignment.center,
              fit: BoxFit.contain,
              animation: 'idle',
            ),
          ),
          const SizedBox(height: 8),
          Text(label, style: DesignSystem.small, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
