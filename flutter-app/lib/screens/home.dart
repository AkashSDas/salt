import 'package:flutter/material.dart';
import 'package:salt/widgets/product/covers.dart';
import 'package:salt/widgets/product/heading.dart';

import '../widgets/drawer/animated_drawer.dart';
import '../widgets/tag/preset_tag_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedDrawer(
      child: ListView(
        children: const [
          SizedBox(height: 0),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: PresetTagSection(),
          ),
          SizedBox(height: 40),
          GroceriesSectionHeading(),
          SizedBox(height: 20),
          GroceriesCovers(),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
