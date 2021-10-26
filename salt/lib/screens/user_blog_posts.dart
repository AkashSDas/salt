import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salt/design_system.dart';
import 'package:salt/providers/animated_drawer.dart';
import 'package:salt/providers/blog_posts_infinite_scroll.dart';
import 'package:salt/providers/user.dart';
import 'package:salt/widgets/blog_post/blog_posts_listview.dart';
import 'package:salt/widgets/blog_post/blog_posts_listview_utils.dart';
import 'package:salt/widgets/buttons/index.dart';

/// In this screen is for logged in user
/// where that person can see their posts and update, delete them
class UserBlogPostsScreen extends StatefulWidget {
  const UserBlogPostsScreen({Key? key}) : super(key: key);

  @override
  _UserBlogPostsScreenState createState() => _UserBlogPostsScreenState();
}

class _UserBlogPostsScreenState extends State<UserBlogPostsScreen> {
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
      ).initialFetchForLoggedInUser(
        Provider.of<UserProvider>(context, listen: false).token.toString(),
      );

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
          ).fetchMoreForLoggedInUser(
            Provider.of<UserProvider>(context, listen: false).token.toString(),
          );
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
          Text('All your posts', style: DesignSystem.heading2),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 72),
            child: RoundedCornerButton(
              onPressed: () {
                Navigator.pushNamed(context, '/blog-post/create');
              },
              text: 'Create',
            ),
          ),
          const SizedBox(height: 32),
          const BlogPostsListView(),
          const BlogPostsListViewEnd(),
        ],
      ),
    );
  }
}
