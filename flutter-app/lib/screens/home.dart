import 'package:flutter/material.dart';
import 'package:salt/widgets/product/covers.dart';
import 'package:salt/widgets/product/heading.dart';
import 'package:salt/widgets/product/preset_groceries.dart';

import '../widgets/drawer/animated_drawer.dart';
import '../widgets/tag/preset_tag_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedDrawer(
      child: ListView(
        children: [
          const SizedBox(height: 0),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: PresetTagSection(),
          ),
          const SizedBox(height: 40),
          const GroceriesSectionHeading(),
          const SizedBox(height: 20),
          const GroceriesCovers(),
          const SizedBox(height: 20),
          const PresetGroceries(),
        ],
      ),
    );
  }
}
