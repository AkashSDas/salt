import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salt/design_system.dart';
import 'package:salt/providers/blog_post_infinite_scroll.dart';
import 'package:salt/widgets/blog_post/blog_post_listview_utils.dart';

/// This widget is meant to be used inside another listview
/// which will get (from backend) more posts when user reaches the
/// end of that listview

class BlogPostListView extends StatelessWidget {
  const BlogPostListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BlogPostInfiniteScrollProvider _provider =
        Provider.of<BlogPostInfiniteScrollProvider>(context);

    if (_provider.firstLoading) return const BlogPostListViewCircularLoader();
    if (_provider.firstError) {
      return Center(
        child: Text(
          _provider.firstApiResponseMsg,
          style: DesignSystem.bodyIntro,
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      itemCount: _provider.posts.length,
      itemBuilder: (context, idx) {
        return Container(
          height: 200,
          child: Center(child: Text(_provider.posts[idx].title)),
        );
      },
    );
  }
}
