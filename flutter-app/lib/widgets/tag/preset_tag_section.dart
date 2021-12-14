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
            PresetTagAnimatedButton(
              flareFilename: 'cake',
              id: "61b445bc2bec119f102b10a9",
            ),
            SizedBox(width: 16),
            PresetTagAnimatedButton(
              flareFilename: 'chocolate',
              id: "61b447922bec119f102b10d6",
            ),
            SizedBox(width: 16),
            PresetTagAnimatedButton(
              flareFilename: 'fast-food',
              id: "61b446402bec119f102b10b1",
            ),
            SizedBox(width: 16),
            PresetTagAnimatedButton(
              flareFilename: 'sweet',
              id: "61b4477a2bec119f102b10d2",
            ),
          ],
        ),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            PresetTagAnimatedButton(
              flareFilename: 'diet',
              id: "61b4468e2bec119f102b10b9",
            ),
            SizedBox(width: 16),
            PresetTagAnimatedButton(
              flareFilename: 'non-veg',
              id: "61b4469f2bec119f102b10bf",
            ),
            SizedBox(width: 16),
            PresetTagAnimatedButton(
              flareFilename: 'high-protein',
              id: "61b446c02bec119f102b10c3",
            ),
            SizedBox(width: 16),
            PresetTagAnimatedButton(
              flareFilename: 'movie-snack',
              id: "61b447602bec119f102b10ce",
            ),
            SizedBox(width: 16),
            PresetTagAnimatedButton(
              flareFilename: 'lunch',
              id: "61b447a62bec119f102b10da",
            ),
          ],
        ),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            PresetTagAnimatedButton(
              flareFilename: 'sushi',
              id: "61b447b72bec119f102b10de",
            ),
            SizedBox(width: 16),
            PresetTagAnimatedButton(
              flareFilename: 'dairy',
              id: "61b447f52bec119f102b10e2",
            ),
            SizedBox(width: 16),
            PresetTagAnimatedButton(
              flareFilename: 'sea-food',
              id: "61b448802bec119f102b10e6",
            ),
            SizedBox(width: 16),
            PresetTagAnimatedButton(
              flareFilename: 'ice-cream',
              id: "61b449352bec119f102b10ee",
            ),
            SizedBox(width: 16),
            PresetTagAnimatedButton(
              flareFilename: 'snack',
              id: "61b44a642bec119f102b10fe",
            ),
          ],
        ),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            PresetTagAnimatedButton(
              flareFilename: 'fruit',
              id: "61b44a3d2bec119f102b10fa",
            ),
            SizedBox(width: 16),
            PresetTagAnimatedButton(
              flareFilename: 'caffeine',
              id: "61b449832bec119f102b10f6",
            ),
            SizedBox(width: 16),
            PresetTagAnimatedButton(
              flareFilename: 'drink',
              id: "61b449672bec119f102b10f2",
            ),
            SizedBox(width: 16),
            PresetTagAnimatedButton(
              flareFilename: 'kitchen',
              id: "61b449192bec119f102b10ea",
            ),
          ],
        ),
      ],
    );
  }
}
