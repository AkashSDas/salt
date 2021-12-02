import 'package:flutter/material.dart';
import 'package:salt/services/blog-post.dart';
import 'package:salt/widgets/blog-post/blog-post-card.dart';
import 'package:salt/widgets/blog-post/blog-post-list-item-loader.dart';

class BlogPostInfiniteScroll extends StatefulWidget {
  const BlogPostInfiniteScroll({Key? key}) : super(key: key);

  @override
  _BlogPostInfiniteScrollState createState() => _BlogPostInfiniteScrollState();
}

class _BlogPostInfiniteScrollState extends State<BlogPostInfiniteScroll> {
  final ScrollController _ctrl = ScrollController();

  List<dynamic> posts = [];
  bool loading = false;
  bool reachedEnd = false;

  /// The first time when items are loaded at that time will be set
  /// to true and once they are loaded this will be set to false
  /// and won't be used again unless the widget unmounted and then mounted
  /// again. This is because BlogPostListItemLoader widget shoulde be
  /// displayed only when posts are fetched the first time when this widget is
  /// mounted
  bool firstLoading = false;

  /// States which have info about, are there more posts, if yes then id to fetch the next
  /// group of posts
  bool hasNext = false;
  String nextId = '';

  @override
  void initState() {
    super.initState();
    _fetch();
    _ctrl.addListener(() {
      if (_ctrl.position.pixels >= _ctrl.position.maxScrollExtent &&
          !loading &&
          !reachedEnd) {
        _fetchMore();
      }
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _fetch() async {
    setState(() {
      firstLoading = true;
    });

    var data = await getAllBlogPostsPaginated(limit: 10);
    List<dynamic> newPosts = data[0]['data']['posts'];

    /// TODO: Resolve setting state after widget is disposed error
    setState(() {
      posts = [...posts, ...newPosts];
      firstLoading = false;
      hasNext = data[0]['data']['hasNext'];
      nextId = data[0]['data']['next'];
    });

    if (hasNext == false)
      setState(() {
        reachedEnd = true;
      });
  }

  Future<void> _fetchMore() async {
    setState(() {
      loading = true;
    });

    var data = await getAllBlogPostsPaginated(
      limit: 10,
      hasNext: hasNext,
      nextId: nextId,
    );
    List<dynamic> newPosts = data[0]['data']['posts'];
    setState(() {
      posts = [...posts, ...newPosts];
      loading = false;
      hasNext = data[0]['data']['hasNext'];
      nextId = data[0]['data']['next'];
    });

    if (hasNext == false)
      setState(() {
        reachedEnd = true;
      });
  }

  @override
  Widget build(BuildContext context) {
    if (firstLoading) return BlogPostListLoader();

    return ListView(
      clipBehavior: Clip.none,
      controller: _ctrl,
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          itemCount: posts.length,
          itemBuilder: (context, idx) => BlogPostCard(
            post: posts[idx],
          ),
        ),
        SizedBox(height: 16),
        _buildTheEnd(),
      ],
    );
  }

  Widget _buildTheEnd() {
    if (reachedEnd) return Text("You've reached the end");
    if (loading)
      return Builder(builder: (context) {
        return Container(
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      });
    return SizedBox(height: 32);
  }
}
