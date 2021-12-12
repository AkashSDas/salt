import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salt/providers/animated_drawer.dart';
import 'package:salt/widgets/common/buttons.dart';
import 'package:salt/widgets/product/covers.dart';
import 'package:salt/widgets/product/heading.dart';
import 'package:salt/widgets/product/preset_groceries.dart';

import '../widgets/drawer/animated_drawer.dart';
import '../widgets/tag/preset_tag_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const AnimatedDrawer(child: _HomeScreenListView());
  }
}

/// Home Screen ListView

class _HomeScreenListView extends StatefulWidget {
  const _HomeScreenListView({Key? key}) : super(key: key);

  @override
  State<_HomeScreenListView> createState() => _HomeScreenListViewState();
}

class _HomeScreenListViewState extends State<_HomeScreenListView> {
  final ScrollController _ctrl = ScrollController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      _ctrl.addListener(() {
        var pixels = _ctrl.position.pixels;
        if (pixels >= 0) {
          /// Listview has be scrolled (when == 0 you're at top)
          Provider.of<AnimatedDrawerProvider>(
            context,
            listen: false,
          ).animateAppBar(pixels);
        }
      });
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: _ctrl,
      children: [
        SizedBox(height: 0),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: PresetTagSection(),
        ),
        SizedBox(height: 40),
        _GroceriesSection(),
      ],
    );
  }
}

class _GroceriesSection extends StatelessWidget {
  const _GroceriesSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const GroceriesSectionHeading(),
        const SizedBox(height: 20),
        const GroceriesCovers(),
        const SizedBox(height: 20),
        const PresetGroceries(),
        const SizedBox(height: 20),
        SecondaryButton(
          text: 'See more...',
          onPressed: () {},
          horizontalPadding: 64,
        ),
      ],
    );
  }
}
