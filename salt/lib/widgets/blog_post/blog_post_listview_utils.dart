import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salt/design_system.dart';
import 'package:salt/providers/blog_posts_infinite_scroll.dart';
import 'package:salt/widgets/loaders/index.dart';

class BlogPostInfiniteScrollWrapper extends StatelessWidget {
  final Widget child;

  const BlogPostInfiniteScrollWrapper({
    required this.child,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => BlogPostsInfiniteScrollProvider(),
      child: child,
    );
  }
}

class BlogPostListViewEnd extends StatelessWidget {
  const BlogPostListViewEnd({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BlogPostsInfiniteScrollProvider _provider =
        Provider.of<BlogPostsInfiniteScrollProvider>(context);

    if (_provider.reachedEnd) {
      return const Text("You've reached end", style: DesignSystem.bodyIntro);
    }

    // if (_provider.loading) return const BlogPostListViewCircularLoader();
    // return const SizedBox(height: 32);
    return const CircularLoader();
  }
}
