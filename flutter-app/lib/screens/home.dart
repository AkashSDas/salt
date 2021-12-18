import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:salt/providers/animated_drawer.dart';
import 'package:salt/widgets/common/buttons.dart';
import 'package:salt/widgets/post/inline_posts.dart';
import 'package:salt/widgets/post/limited_posts_view.dart';
import 'package:salt/widgets/product/covers.dart';
import 'package:salt/widgets/product/heading.dart';
import 'package:salt/widgets/product/preset_groceries.dart';
import 'package:salt/widgets/recipe/preset_recipe_category.dart';

import '../design_system.dart';
import '../widgets/drawer/animated_drawer.dart';
import '../widgets/tag/preset_tag_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const AnimatedDrawer(
      child: _HomeScreenListView(),
      bottomNavIdx: 0,
    );
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
        const SizedBox(height: 0),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: PresetTagSection(),
        ),
        const SizedBox(height: 40),
        const _GroceriesSection(),
        const SizedBox(height: 40),
        const _RecipesSection(),
        const SizedBox(height: 40),
        Text("Explore other's recipes", style: DesignSystem.small),
        const SizedBox(height: 20),
        InlineTagPosts(tagId: '61bcb1529a229216955b03fe'),
        const SizedBox(height: 40),
        LimitedPostsView(limit: 5),
        const SizedBox(height: 40),
      ],
    );
  }
}

class _RecipesSection extends StatelessWidget {
  const _RecipesSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: 'Cook ',
              style: DesignSystem.heading3.copyWith(
                color: DesignSystem.secondary,
              ),
              children: [
                TextSpan(
                  text: 'something new',
                  style: DesignSystem.heading3,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: PresetRecipeCategories(),
        ),
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
