import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salt/design_system.dart';
import 'package:salt/providers/animated_drawer.dart';
import 'package:salt/providers/recipes_infinite_scroll.dart';
import 'package:salt/widgets/buttons/index.dart';
import 'package:salt/widgets/recipe/recipes_listview.dart';
import 'package:salt/widgets/recipe/recipes_listview_utils.dart';

class RecipesScreen extends StatefulWidget {
  const RecipesScreen({Key? key}) : super(key: key);

  @override
  _RecipesScreenState createState() => _RecipesScreenState();
}

class _RecipesScreenState extends State<RecipesScreen> {
  final ScrollController _ctrl = ScrollController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      Provider.of<RecipesInfiniteScrollProvider>(
        context,
        listen: false,
      ).initialFetch();

      /// Scroll event for fetching more recipes
      _ctrl.addListener(() {
        var loading = Provider.of<RecipesInfiniteScrollProvider>(
          context,
          listen: false,
        ).loading;

        var reachedEnd = Provider.of<RecipesInfiniteScrollProvider>(
          context,
          listen: false,
        ).reachedEnd;

        var pixels = _ctrl.position.pixels;
        var maxScrollExtent = _ctrl.position.maxScrollExtent;

        if (pixels >= maxScrollExtent && !loading && !reachedEnd) {
          /// fetch more
          Provider.of<RecipesInfiniteScrollProvider>(
            context,
            listen: false,
          ).fetchMore();
        }

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
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: ListView(
        controller: _ctrl,
        clipBehavior: Clip.none,
        children: [
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: DesignSystem.heading2,
              children: [
                const TextSpan(text: "What's your secret \n"),
                TextSpan(
                  text: 'recipe',
                  style: DesignSystem.heading2.copyWith(
                    color: DesignSystem.dodgerBlue,
                  ),
                ),
                const TextSpan(text: '?'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 72),
            child: RoundedCornerButton(
              onPressed: () => Navigator.pushNamed(context, '/recipe/create'),
              text: 'Share',
            ),
          ),
          const SizedBox(height: 32),
          const RecipesListView(),
          const RecipesListViewEnd(),
        ],
      ),
    );
  }
}
