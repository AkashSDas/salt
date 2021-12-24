import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salt/design_system.dart';
import 'package:salt/providers/animated_drawer.dart';
import 'package:salt/providers/post_infinite_scroll.dart';
import 'package:salt/widgets/animations/reveal.dart';
import 'package:salt/widgets/drawer/animated_drawer.dart';
import 'package:salt/widgets/others/scroll_behavior.dart';
import 'package:salt/widgets/post/big_post.dart';
import 'package:salt/widgets/recipe/recipe_categories_section.dart';
import 'package:salt/widgets/tag/tags_section.dart';
import 'package:spring/spring.dart';

class PostsScreen extends StatelessWidget {
  const PostsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedDrawer(
      bottomNavIdx: 3,
      child: ChangeNotifierProvider(
        create: (context) => PostInfiniteScrollProvider(),
        child: const _PostsListView(),
      ),
    );
  }
}

/// Post list view that has `infinite scrolling`

class _PostsListView extends StatefulWidget {
  const _PostsListView({Key? key}) : super(key: key);

  @override
  __PostsListViewState createState() => __PostsListViewState();
}

class __PostsListViewState extends State<_PostsListView> {
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
      Provider.of<PostInfiniteScrollProvider>(
        context,
        listen: false,
      ).initialFetch();

      /// Scroll event for fetching more posts
      _ctrl.addListener(() {
        var loading = Provider.of<PostInfiniteScrollProvider>(
          context,
          listen: false,
        ).loading;

        var reachedEnd = Provider.of<PostInfiniteScrollProvider>(
          context,
          listen: false,
        ).reachedEnd;

        var pixels = _ctrl.position.pixels;
        var maxScrollExtent = _ctrl.position.maxScrollExtent;

        if (pixels >= maxScrollExtent && !loading && !reachedEnd) {
          /// fetch more
          Provider.of<PostInfiniteScrollProvider>(
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
    return ScrollConfiguration(
      behavior: NoHighlightBehavior(),
      child: ListView(
        controller: _ctrl,
        children: [
          const _TagsSection(),
          DesignSystem.spaceH40,
          const _RecipesSection(),
          DesignSystem.spaceH40,
          const PostsInfiniteListView(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
          ),
        ],
      ),
    );
  }
}

/// Circular tag section

class _TagsSection extends StatefulWidget {
  const _TagsSection({Key? key}) : super(key: key);

  @override
  State<_TagsSection> createState() => _TagsSectionState();
}

class _TagsSectionState extends State<_TagsSection>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return CircluarTagsSection();
  }
}

/// Recipes section

class _RecipesSection extends StatefulWidget {
  const _RecipesSection({Key? key}) : super(key: key);

  @override
  __RecipesSectionState createState() => __RecipesSectionState();
}

class __RecipesSectionState extends State<_RecipesSection>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Spring.opacity(
        startOpacity: 0,
        endOpacity: 1,
        delay: const Duration(milliseconds: 800),
        animDuration: const Duration(milliseconds: 1000),
        curve: Curves.easeOut,
        child: const RevealAnimation(
          delay: 800,
          duration: 1000,
          startAngle: 3,
          startYOffset: 60,
          child: RecipeCategoriesSection(),
        ),
      ),
    );
  }
}
