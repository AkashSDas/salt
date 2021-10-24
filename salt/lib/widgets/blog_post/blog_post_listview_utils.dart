import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salt/design_system.dart';
import 'package:salt/providers/blog_post_infinite_scroll.dart';

class BlogPostInfiniteScrollWrapper extends StatelessWidget {
  final Widget child;

  const BlogPostInfiniteScrollWrapper({
    required this.child,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => BlogPostInfiniteScrollProvider(),
      child: child,
    );
  }
}

class BlogPostListViewEnd extends StatelessWidget {
  const BlogPostListViewEnd({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BlogPostInfiniteScrollProvider _provider =
        Provider.of<BlogPostInfiniteScrollProvider>(context);

    if (_provider.reachedEnd) {
      return const Text("You've reached end", style: DesignSystem.bodyIntro);
    }

    // if (_provider.loading) return const BlogPostListViewCircularLoader();
    // return const SizedBox(height: 32);
    return const BlogPostListViewCircularLoader();
  }
}

class BlogPostListViewCircularLoader extends StatelessWidget {
  const BlogPostListViewCircularLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 128,
      child: Center(child: CircularProgressIndicator()),
    );
  }
}
