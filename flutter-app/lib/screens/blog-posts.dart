import 'package:flutter/material.dart';
import 'package:salt/services/blog-post.dart';
import 'package:salt/widgets/blog-post/blog-post-list-item-loader.dart';
import 'package:salt/widgets/blog-post/blog-post-list-item.dart';
import 'package:salt/widgets/blog-post/blog-post-list.dart';
import 'package:salt/widgets/common/bottom-nav.dart';

class BlogPostsScreen extends StatefulWidget {
  const BlogPostsScreen({Key? key}) : super(key: key);

  @override
  _BlogPostsScreenState createState() => _BlogPostsScreenState();
}

class _BlogPostsScreenState extends State<BlogPostsScreen> {
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

  Future<void> _fetch() async {
    setState(() {
      firstLoading = true;
    });

    var data = await getAllBlogPostsPaginated(limit: 10);
    List<dynamic> newPosts = data[0]['data']['posts'];
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
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        bottomNavigationBar: AppBottomNav(currentIndex: 3),
        body: Container(
          clipBehavior: Clip.antiAlias,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(color: Theme.of(context).primaryColor),
          child: _buildBody(),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (firstLoading) return BlogPostListItemLoader();
    return ListView(
      clipBehavior: Clip.none,
      controller: _ctrl,
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          itemCount: posts.length,
          itemBuilder: (context, idx) => BlogPostListItem(
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
      return Container(child: Center(child: CircularProgressIndicator()));
    return SizedBox(height: 32);
  }
}