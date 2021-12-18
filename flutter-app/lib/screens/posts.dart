import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salt/providers/animated_drawer.dart';
import 'package:salt/providers/post_infinite_scroll.dart';
import 'package:salt/widgets/drawer/animated_drawer.dart';
import 'package:salt/widgets/post/big_post.dart';
import 'package:salt/widgets/recipe/preset_recipe_category.dart';
import 'package:salt/widgets/tag/preset_tag_section.dart';

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
    return ListView(
      controller: _ctrl,
      children: const [
        PresetTagSection(),
        SizedBox(height: 20),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: PresetRecipeCategories(),
        ),
        PostsInfiniteListView(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
        ),
      ],
    );
  }
}
