import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salt/models/post/post.dart';
import 'package:salt/providers/animated_drawer.dart';
import 'package:salt/providers/post_infinite_scroll.dart';
import 'package:salt/providers/user_provider.dart';
import 'package:salt/screens/post.dart';
import 'package:salt/widgets/common/loader.dart';
import 'package:salt/widgets/drawer/animated_drawer.dart';
import 'package:salt/widgets/post/limited_posts_view.dart';

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

class _UserPostCard extends StatelessWidget {
  final List<Post> posts;
  final int idx;

  const _UserPostCard({
    required this.posts,
    required this.idx,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PostScreen(post: posts[idx])),
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
                PostCoverImg(url: posts[idx].coverImgURL),
                PostInfo(post: posts[idx]),
              ],
            ),
          ),
          SizedBox(height: idx == 2 ? 0 : 20),
        ],
      ),
    );
  }
}
