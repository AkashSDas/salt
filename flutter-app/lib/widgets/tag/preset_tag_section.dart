import 'package:flutter/material.dart';

import 'preset_tag_animated_button.dart';

// const tagSectionData = {
//   '1': ['cake', 'chocolate', 'fast-food', 'sweet'],
//   '2': ['diet', 'non-veg', 'high-protein', 'movie-snack', 'lunch'],
//   '3': ['sushi', 'dairy', 'sea-food', 'ice-cream', 'snack'],
//   '4': ['fruit', 'caffeine', 'drink', 'kitchen'],
// };

class PresetTagSection extends StatelessWidget {
  const PresetTagSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
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
    );
  }
}
