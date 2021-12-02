import 'package:flutter/material.dart';
import 'package:salt/services/blog-post.dart';
import 'package:salt/widgets/blog-post/blog-post-list-item-loader.dart';
import 'package:salt/widgets/blog-post/blog-post-card.dart';

class BlogPostsFiniteScroll extends StatefulWidget {
  const BlogPostsFiniteScroll({Key? key}) : super(key: key);

  @override
  _BlogPostsFiniteScrollState createState() => _BlogPostsFiniteScrollState();
}

class _BlogPostsFiniteScrollState extends State<BlogPostsFiniteScroll> {
  late Future<dynamic> _getAllBlogPosts;

  @override
  void initState() {
    super.initState();
    _getAllBlogPosts = getAllBlogPostsPaginated(limit: 10);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getAllBlogPosts,
      builder: (context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) return BlogPostListLoader();

        var error = snapshot.data[1];
        var data = snapshot.data[0];

        if (error != null || data['error']) return BlogPostListLoader();

        List<dynamic> posts = data['data']['posts'];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...posts.map((post) => BlogPostCard(post: post)).toList(),
          ],
        );
      },
    );
  }
}
