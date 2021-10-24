import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salt/design_system.dart';
import 'package:salt/providers/animated_drawer.dart';
import 'package:salt/providers/blog_posts_infinite_scroll.dart';
import 'package:salt/widgets/blog_post/blog_post_listview.dart';
import 'package:salt/widgets/blog_post/blog_post_listview_utils.dart';
import 'package:salt/widgets/buttons/index.dart';

class BlogPostsScreen extends StatefulWidget {
  const BlogPostsScreen({Key? key}) : super(key: key);

  @override
  _BlogPostsScreenState createState() => _BlogPostsScreenState();
}

class _BlogPostsScreenState extends State<BlogPostsScreen> {
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
      Provider.of<BlogPostsInfiniteScrollProvider>(
        context,
        listen: false,
      ).initialFetch();

      /// Scroll event for fetching more posts
      _ctrl.addListener(() {
        var loading = Provider.of<BlogPostsInfiniteScrollProvider>(
          context,
          listen: false,
        ).loading;

        var reachedEnd = Provider.of<BlogPostsInfiniteScrollProvider>(
          context,
          listen: false,
        ).reachedEnd;

        var pixels = _ctrl.position.pixels;
        var maxScrollExtent = _ctrl.position.maxScrollExtent;

        if (pixels >= maxScrollExtent && !loading && !reachedEnd) {
          /// fetch more
          Provider.of<BlogPostsInfiniteScrollProvider>(
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
                TextSpan(
                  text: 'Enlighten ',
                  style: DesignSystem.heading2.copyWith(
                    color: DesignSystem.dodgerBlue,
                  ),
                ),
                const TextSpan(text: 'the world with your knowledge'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 72),
            child: RoundedCornerButton(onPressed: () {}, text: 'Share'),
          ),
          const SizedBox(height: 32),
          const BlogPostListView(),
          const BlogPostListViewEnd(),
        ],
      ),
    );
  }
}
