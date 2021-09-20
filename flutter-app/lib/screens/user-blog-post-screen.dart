import 'package:flutter/material.dart';
import 'package:salt/services/auth.dart';
import 'package:salt/services/blog-post.dart';
import 'package:salt/widgets/blog-post/blog-post-list-item-loader.dart';
import 'package:salt/widgets/blog-post/blog-post-list-item.dart';
import 'package:salt/widgets/common/bottom-nav.dart';

class UserBlogPostsScreen extends StatefulWidget {
  const UserBlogPostsScreen({Key? key}) : super(key: key);

  @override
  _UserBlogPostsScreenState createState() => _UserBlogPostsScreenState();
}

class _UserBlogPostsScreenState extends State<UserBlogPostsScreen> {
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

    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      var response = await isAuthenticated();

      // await Future.delayed(Duration(seconds: 15));

      /// TODO:
      /// Note - that if isAuthenticated took time and to get
      /// data then for sometime nothing will be shown on the screen
      /// (put circular progress indicator for that) and once you've
      /// received data then according to response (if not null) _fetch
      /// will be called and _ctrl will addListener _fetchMore and the
      /// initial content will be displayed on screen, So not issues here
      /// which you can check by uncommenting the above code line of Future.delayed
      /// If the user has no post and give some msg or if the user is
      /// not authenticated then show some other msg

      if (response != null) {
        var user = response['user'];
        String? token = response['token'];
        if (user != null && token != null) {
          String userId = user['_id'];
          _fetch(userId, token);
          _ctrl.addListener(() {
            if (_ctrl.position.pixels >= _ctrl.position.maxScrollExtent &&
                !loading &&
                !reachedEnd) {
              _fetchMore(userId, token);
            }
          });
        }
      }
    });
  }

  Future<void> _fetch(String userId, String token) async {
    setState(() {
      firstLoading = true;
    });

    var data = await getAllBlogPostsForSingleUserPaginated(
      userId: userId,
      limit: 10,
      token: token,
    );
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

  Future<void> _fetchMore(String userId, String token) async {
    setState(() {
      loading = true;
    });

    var data = await getAllBlogPostsForSingleUserPaginated(
      userId: userId,
      token: token,
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
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.pushNamed(context, '/blog-post/create'),
          child: Icon(Icons.add),
        ),
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
