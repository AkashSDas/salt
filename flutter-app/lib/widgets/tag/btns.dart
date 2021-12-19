import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:salt/design_system.dart';

/// The [filename] is just the name of the file and not the path to that file.
/// The [tagId] is the `DB` id which should be correct
///
/// The [animation] is the `animation` for the [FlareActor]
///
/// This widget doesn't have any `label`
class CircularTagButton extends StatelessWidget {
  final String tagId;
  final String filename;
  final String animation;
  final void Function()? onTap;

  const CircularTagButton({
    Key? key,
    required this.tagId,
    required this.filename,
    required this.animation,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: key,
      onTap: onTap,
      child: Container(
        height: 63,
        width: 63,
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(32),
        ),
        child: FlareActor(
          'assets/flare/tags-section/$filename.flr',
          alignment: Alignment.center,
          fit: BoxFit.contain,
          animation: animation,
        ),
      ),
    );
  }
}

/// The [filename] is just the name of the file and not the path to that file.
/// The [tagId] is the `DB` id which should be correct
///
/// The [animation] is the `animation` for the [FlareActor]
///
/// [label] is needed to display text below the sqaure btn
class SquareTagButton extends StatelessWidget {
  final String tagId;
  final String filename;
  final String animation;
  final String label;
  final void Function()? onTap;

  const SquareTagButton({
    Key? key,
    required this.tagId,
    required this.filename,
    required this.animation,
    required this.label,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      key: key,
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
              'assets/flare/tags-section/$filename.flr',
              alignment: Alignment.center,
              fit: BoxFit.contain,
              animation: animation,
            ),
          ),
          const SizedBox(height: 8),
          Text(label, style: DesignSystem.small, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
