import 'package:flutter/material.dart';
import 'package:salt/widgets/tag/preset_tag_animated_button.dart';

class PresetGroceries extends StatelessWidget {
  const PresetGroceries({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          PresetTag(label: 'Sweets', flareFilename: 'chocolate'),
          PresetTag(label: 'Drinks', flareFilename: 'drink'),
          PresetTag(label: 'Cakes', flareFilename: 'cake'),
          PresetTag(label: 'Ice creams', flareFilename: 'ice-cream'),
          PresetTag(label: 'Non veg', flareFilename: 'non-veg'),
        ],
      ),
    );
  }
}
