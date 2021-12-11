import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:salt/widgets/drawer/animated_drawer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedDrawer(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              PresetTagAnimatedButton(flareFilename: 'cake'),
              SizedBox(width: 16),
              PresetTagAnimatedButton(flareFilename: 'chocolate'),
              SizedBox(width: 16),
              PresetTagAnimatedButton(flareFilename: 'fast-food'),
              SizedBox(width: 16),
              PresetTagAnimatedButton(flareFilename: 'sweet'),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              PresetTagAnimatedButton(flareFilename: 'diet'),
              SizedBox(width: 16),
              PresetTagAnimatedButton(flareFilename: 'non-veg'),
              SizedBox(width: 16),
              PresetTagAnimatedButton(flareFilename: 'high-protein'),
              SizedBox(width: 16),
              PresetTagAnimatedButton(flareFilename: 'movie-snack'),
              SizedBox(width: 16),
              PresetTagAnimatedButton(flareFilename: 'lunch'),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              PresetTagAnimatedButton(flareFilename: 'sushi'),
              SizedBox(width: 16),
              PresetTagAnimatedButton(flareFilename: 'dairy'),
              SizedBox(width: 16),
              PresetTagAnimatedButton(flareFilename: 'sea-food'),
              SizedBox(width: 16),
              PresetTagAnimatedButton(flareFilename: 'ice-cream'),
              SizedBox(width: 16),
              PresetTagAnimatedButton(flareFilename: 'snack'),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              PresetTagAnimatedButton(flareFilename: 'fruit'),
              SizedBox(width: 16),
              PresetTagAnimatedButton(flareFilename: 'caffeine'),
              SizedBox(width: 16),
              PresetTagAnimatedButton(flareFilename: 'drink'),
              SizedBox(width: 16),
              PresetTagAnimatedButton(flareFilename: 'kitchen'),
            ],
          ),
        ],
      ),
    );
  }
}

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
