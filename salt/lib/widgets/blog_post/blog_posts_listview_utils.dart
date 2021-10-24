import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salt/design_system.dart';
import 'package:salt/providers/blog_posts_infinite_scroll.dart';
import 'package:salt/widgets/loaders/index.dart';

class BlogPostsInfiniteScrollWrapper extends StatelessWidget {
  final Widget child;

  const BlogPostsInfiniteScrollWrapper({
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

class BlogPostsListViewEnd extends StatelessWidget {
  const BlogPostsListViewEnd({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BlogPostsInfiniteScrollProvider _provider =
        Provider.of<BlogPostsInfiniteScrollProvider>(context);

    if (_provider.reachedEnd) {
      return const Text("You've reached end", style: DesignSystem.bodyIntro);
    }

    return const CircularLoader();
  }
}
