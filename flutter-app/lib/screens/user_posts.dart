import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import 'package:salt/models/post/post.dart';
import 'package:salt/providers/animated_drawer.dart';
import 'package:salt/providers/post_infinite_scroll.dart';
import 'package:salt/providers/user_provider.dart';
import 'package:salt/screens/post.dart';
import 'package:salt/screens/update_post.dart';
import 'package:salt/services/post.dart';
import 'package:salt/widgets/common/alert.dart';
import 'package:salt/widgets/common/loader.dart';
import 'package:salt/widgets/drawer/animated_drawer.dart';
import 'package:salt/widgets/post/big_post.dart';

import '../design_system.dart';

class UserPostsScreen extends StatelessWidget {
  const UserPostsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedDrawer(
      child: ChangeNotifierProvider(
        create: (context) => PostInfiniteScrollProvider(),
        child: const _ListView(),
      ),
    );
  }
}

class _ListView extends StatefulWidget {
  const _ListView({Key? key}) : super(key: key);

  @override
  State<_ListView> createState() => _ListViewState();
}

class _ListViewState extends State<_ListView> {
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

    return ListView(
      controller: _ctrl,
      children: [
        const SizedBox(height: 20),
        Text(
          'My posts',
          style: DesignSystem.heading4,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        _provider.firstLoading
            ? const SearchLoader()
            : const SizedBox(height: 40),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: _Posts(posts: _provider.posts),
        ),
        _provider.reachedEnd
            ? Text(
                "You've reached the end",
                style: DesignSystem.bodyMain,
                textAlign: TextAlign.center,
              )
            : !_provider.firstLoading
                ? const SearchLoader()
                : const SizedBox(),
      ],
    );
  }
}

class _Posts extends StatelessWidget {
  final List<Post> posts;
  const _Posts({required this.posts, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<PostInfiniteScrollProvider>(context);

    return ListView.builder(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      itemCount: _provider.posts.length,
      itemBuilder: (context, idx) {
        return _UserPostCard(posts: _provider.posts, idx: idx);
      },
    );
  }
}

class _UserPostCard extends StatefulWidget {
  final List<Post> posts;
  final int idx;

  const _UserPostCard({
    required this.posts,
    required this.idx,
    Key? key,
  }) : super(key: key);

  @override
  State<_UserPostCard> createState() => _UserPostCardState();
}

class _UserPostCardState extends State<_UserPostCard> {
  final _service = PostService();
  var loading = false;

  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<PostInfiniteScrollProvider>(context);
    final _user = Provider.of<UserProvider>(context);

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PostScreen(post: widget.posts[widget.idx])),
        );
      },
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              border: Border.all(color: DesignSystem.border, width: 1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                Stack(
                  children: [
                    BigPostCoverImg(url: widget.posts[widget.idx].coverImgURL),
                    Positioned(
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
                        child: Row(
                          children: [
                            IconButton(
                              icon: loading
                                  ? const CircularProgressIndicator()
                                  : const Icon(IconlyLight.delete),
                              onPressed: () async {
                                if (loading) return;

                                // Delete post
                                setState(() => loading = true);
                                var response = await _service.deletePost(
                                  widget.posts[widget.idx].id,
                                  _user.user?.id ?? '',
                                  _user.token ?? '',
                                );
                                setState(() => loading = false);
                                if (response.error) {
                                  failedSnackBar(
                                    context: context,
                                    msg: response.msg,
                                  );
                                } else {
                                  // Update posts state
                                  _provider.setPosts(
                                    _provider.posts
                                        .where((p) =>
                                            p.id != widget.posts[widget.idx].id)
                                        .toList(),
                                  );

                                  successSnackBar(
                                    context: context,
                                    msg: response.msg,
                                  );
                                }
                              },
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              icon: const Icon(IconlyLight.edit),
                              onPressed: () async {
                                if (loading) return;
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => UpdatePostScreen(
                                      post: widget.posts[widget.idx],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                PostInfo(post: widget.posts[widget.idx]),
              ],
            ),
          ),
          SizedBox(height: widget.idx == 2 ? 0 : 20),
        ],
      ),
    );
  }
}
