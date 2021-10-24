import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salt/providers/blog_post_infinite_scroll.dart';
import 'package:salt/widgets/animated_drawer/animated_drawer.dart';
import 'package:salt/widgets/blog_post/blog_post_listview.dart';
import 'package:salt/widgets/blog_post/blog_post_listview_utils.dart';
import 'package:salt/widgets/food_category/inline_food_category.dart';
import 'package:salt/widgets/headers/index.dart';
import 'package:salt/widgets/recipe/inline_recipes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
      Provider.of<BlogPostInfiniteScrollProvider>(
        context,
        listen: false,
      ).initialFetch();

      /// Scroll event for fetching more posts
      _ctrl.addListener(() {
        var loading = Provider.of<BlogPostInfiniteScrollProvider>(
          context,
          listen: false,
        ).loading;

        var reachedEnd = Provider.of<BlogPostInfiniteScrollProvider>(
          context,
          listen: false,
        ).reachedEnd;

        var pixels = _ctrl.position.pixels;
        var maxScrollExtent = _ctrl.position.maxScrollExtent;

        if (pixels >= maxScrollExtent && !loading && !reachedEnd) {
          /// fetch more
          Provider.of<BlogPostInfiniteScrollProvider>(
            context,
            listen: false,
          ).fetchMore();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedDrawer(
      body: Padding(
        padding: const EdgeInsets.all(8).copyWith(top: 0),
        child: ListView(
          controller: _ctrl,
          clipBehavior: Clip.none,
          addAutomaticKeepAlives: true,
          children: const [
            InlineCategory(),
            SizedBox(height: 32),
            InlineRecipes(),
            SizedBox(height: 32),
            Heading(title: 'Most Popular Posts'),
            SizedBox(height: 16),
            BlogPostListView(),
            BlogPostListViewEnd(),
          ],
        ),
      ),
    );
  }
}
