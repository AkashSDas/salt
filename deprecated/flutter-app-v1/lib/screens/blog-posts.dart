import 'package:flutter/material.dart';
import 'package:salt/widgets/blog-post/blog-post-infinite-scroll.dart';
import 'package:salt/widgets/common/bottom-nav.dart';

class BlogPostsScreen extends StatelessWidget {
  const BlogPostsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        bottomNavigationBar: AppBottomNav(currentIndex: 3),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.pushNamed(context, '/blog-post/create'),
          child: Icon(Icons.add),
        ),
        body: Container(
          clipBehavior: Clip.antiAlias,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(color: Theme.of(context).primaryColor),
          child: BlogPostInfiniteScroll(),
        ),
      ),
    );
  }
}
