import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import 'package:salt/design_system.dart';
import 'package:salt/models/post/post.dart';
import 'package:salt/providers/animated_drawer.dart';
import 'package:salt/providers/post_infinite_scroll.dart';
import 'package:salt/providers/user_provider.dart';
import 'package:salt/screens/post.dart';
import 'package:salt/screens/update_post.dart';
import 'package:salt/services/post.dart';
import 'package:salt/widgets/common/alert.dart';
import 'package:salt/widgets/common/divider.dart';
import 'package:salt/widgets/common/loader.dart';
import 'package:salt/widgets/drawer/animated_drawer.dart';
import 'package:salt/widgets/others/scroll_behavior.dart';
import 'package:salt/widgets/post/big_post.dart';

class UserPostsScreen extends StatelessWidget {
  const UserPostsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedDrawer(
      child: ChangeNotifierProvider(
        create: (context) => PostInfiniteScrollProvider(),
        child: const _UserPosts(),
      ),
    );
  }
}

/// User posts infinite listview

class _UserPosts extends StatefulWidget {
  const _UserPosts({Key? key}) : super(key: key);

  @override
  State<_UserPosts> createState() => _UserPostsState();
}

class _UserPostsState extends State<_UserPosts> {
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
      Provider.of<PostInfiniteScrollProvider>(
        context,
        listen: false,
      ).initialFetchUserPosts(
        Provider.of<UserProvider>(context, listen: false).user?.id ?? '',
        Provider.of<UserProvider>(context, listen: false).token ?? '',
      );

      /// Scroll event for fetching more posts
      _ctrl.addListener(() {
        var loading = Provider.of<PostInfiniteScrollProvider>(
          context,
          listen: false,
        ).loading;

        var reachedEnd = Provider.of<PostInfiniteScrollProvider>(
          context,
          listen: false,
        ).reachedEnd;

        var pixels = _ctrl.position.pixels;
        var maxScrollExtent = _ctrl.position.maxScrollExtent;

        if (pixels >= maxScrollExtent && !loading && !reachedEnd) {
          /// fetch more
          Provider.of<PostInfiniteScrollProvider>(
            context,
            listen: false,
          ).fetchMoreUserPosts(
            Provider.of<UserProvider>(context, listen: false).user?.id ?? '',
            Provider.of<UserProvider>(context, listen: false).token ?? '',
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
    final _provider = Provider.of<PostInfiniteScrollProvider>(context);

    return ScrollConfiguration(
      behavior: NoHighlightBehavior(),
      child: ListView(
        controller: _ctrl,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          DesignSystem.spaceH20,
          Text('My posts', style: DesignSystem.heading1),
          DesignSystem.spaceH20,
          const DashedSeparator(height: 1.6),
          DesignSystem.spaceH20,
          _provider.firstLoading
              ? const SearchLoader()
              : AnimationLimiter(
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    itemCount: _provider.posts.length,
                    itemBuilder: (context, idx) {
                      return AnimationConfiguration.staggeredList(
                        position: idx,
                        duration: const Duration(milliseconds: 375),
                        delay: const Duration(milliseconds: 300),
                        child: SlideAnimation(
                          horizontalOffset: -100,
                          child: FadeInAnimation(
                            child: _UserPostCard(
                              post: _provider.posts[idx],
                            ),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, idx) => DesignSystem.spaceH20,
                  ),
                ),
          DesignSystem.spaceH40,
          _provider.reachedEnd
              ? Text(
                  "You've reached the end",
                  style: DesignSystem.bodyMain,
                  textAlign: TextAlign.center,
                )
              : !_provider.firstLoading
                  ? const SearchLoader()
                  : const SizedBox(),
          DesignSystem.spaceH40,
        ],
      ),
    );
  }
}

/// User post card which has actions like `update` and `delete` this post
class _UserPostCard extends StatelessWidget {
  final Post post;
  const _UserPostCard({required this.post, Key? key}) : super(key: key);

  void _navigateToPost(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PostScreen(post: post)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _navigateToPost(context),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          border: Border.all(color: DesignSystem.border, width: 1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(children: [_Header(post: post), PostInfo(post: post)]),
      ),
    );
  }
}

/// Header of user post card which has `cover img` and `actions` like
/// `update` and `delete`
class _Header extends StatelessWidget {
  final Post post;
  const _Header({required this.post, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [BigPostCoverImg(url: post.coverImgURL), _Actions(post: post)],
    );
  }
}

/// User big card actions - `update` & `delete`

class _Actions extends StatefulWidget {
  final Post post;
  const _Actions({required this.post, Key? key}) : super(key: key);

  @override
  State<_Actions> createState() => _ActionsState();
}

class _ActionsState extends State<_Actions> {
  var loading = false;

  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<UserProvider>(context);
    final _provider = Provider.of<PostInfiniteScrollProvider>(context);
    var setPosts = _provider.setPosts;
    var posts = _provider.posts;
    var userId = _user.user?.id ?? '';
    var token = _user.token ?? '';

    return Positioned(
      right: 0,
      bottom: 16,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: const BoxDecoration(
          color: DesignSystem.primary,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            bottomLeft: Radius.circular(20),
          ),
        ),
        child: _buildActions(context, setPosts, posts, userId, token),
      ),
    );
  }

  Widget _buildActions(
    BuildContext context,
    Function setPosts,
    List<Post> posts,
    String userId,
    String token,
  ) {
    return Row(
      children: [
        IconButton(
          icon: loading
              ? const CircularProgressIndicator()
              : const Icon(IconlyLight.delete),
          onPressed: () {
            _deleteAction(
              context,
              widget.post.id,
              setPosts,
              posts,
              userId,
              token,
            );
          },
        ),
        const SizedBox(width: 8),
        IconButton(
          icon: const Icon(IconlyLight.edit),
          onPressed: () => _updateAction(context),
        ),
      ],
    );
  }

  void _updateAction(BuildContext context) {
    if (loading) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdatePostScreen(post: widget.post),
      ),
    );
  }

  Future<void> _deleteAction(
    BuildContext context,
    String postId,
    Function setPosts,
    List<Post> posts,
    String userId,
    String token,
  ) async {
    if (loading) return;

    final service = PostService();

    setState(() => loading = true);
    var response = await service.deletePost(postId, userId, token);
    setState(() => loading = false);

    if (response.error) {
      failedSnackBar(context: context, msg: response.msg);
    } else {
      // Update posts state
      setPosts(posts.where((p) => p.id != postId).toList());
      successSnackBar(context: context, msg: response.msg);
    }
  }
}
