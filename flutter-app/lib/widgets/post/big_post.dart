import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import 'package:salt/design_system.dart';
import 'package:salt/models/post/post.dart';
import 'package:salt/providers/post_infinite_scroll.dart';
import 'package:salt/screens/post.dart';
import 'package:salt/services/post.dart';
import 'package:salt/utils/api.dart';
import 'package:salt/utils/index.dart';
import 'package:salt/widgets/common/loader.dart';
import 'package:salt/widgets/common/markdown.dart';
import 'package:shimmer/shimmer.dart';

/// Posts loader
class PostsLoader extends StatelessWidget {
  const PostsLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: 3,
      itemBuilder: (context, idx) => const PostCardLoader(),
      separatorBuilder: (context, idx) => DesignSystem.spaceH20,
    );
  }
}

/// Post card loader
class PostCardLoader extends StatelessWidget {
  const PostCardLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      child: Container(
        height: 250 + 102,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(32),
        ),
      ),
      baseColor: DesignSystem.shimmerBaseColor,
      highlightColor: DesignSystem.shimmerHighlightColor,
    );
  }
}

/// Post infinite list view
///
/// This widget doesn't handles the fetching of more data,
/// [PostInfiniteListView] should be used with a widget that is
/// scrollable and there a listener should be added to fetch more
/// data. This is done to give flexibity of adding more things in the
/// parent scrollable widget because here only listview will be
/// displayed.
class PostsInfiniteListView extends StatelessWidget {
  final bool shrinkWrap;
  final ScrollPhysics? physics;

  const PostsInfiniteListView({
    this.physics,
    this.shrinkWrap = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<PostInfiniteScrollProvider>(context);

    if (_provider.firstLoading) return const SearchLoader();
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      shrinkWrap: shrinkWrap,
      physics: physics,
      children: [
        AnimationLimiter(
          child: ListView.separated(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            itemCount: _provider.posts.length,
            itemBuilder: (context, idx) => AnimationConfiguration.staggeredList(
              position: idx,
              duration: const Duration(milliseconds: 375),
              delay: const Duration(milliseconds: 600),
              child: SlideAnimation(
                horizontalOffset: -100,
                child: FadeInAnimation(
                  child: BigPostCard(
                    post: _provider.posts[idx],
                  ),
                ),
              ),
            ),
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
    );
  }
}

/// Post finite list view
class PostsFiniteListView extends StatelessWidget {
  final int? limit;
  final bool shrinkWrap;
  final ScrollPhysics? physics;
  final _service = PostService();

  PostsFiniteListView({
    this.limit,
    this.physics,
    this.shrinkWrap = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _service.getPostsPagniated(limit: limit),
      builder: (context, AsyncSnapshot<ApiResponse> snapshot) {
        if (!snapshot.hasData) return const SearchLoader();
        var response = snapshot.data!;
        if (response.error || response.data == null) {
          return const SearchLoader();
        }

        List<Post> posts = [];
        for (int i = 0; i < response.data['posts'].length; i++) {
          posts.add(Post.fromJson(response.data['posts'][i]));
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: AnimationLimiter(
            child: ListView.separated(
              shrinkWrap: shrinkWrap,
              physics: physics,
              itemCount: posts.length,
              itemBuilder: (context, idx) {
                return AnimationConfiguration.staggeredList(
                  position: idx,
                  duration: const Duration(milliseconds: 375),
                  delay: const Duration(milliseconds: 600),
                  child: SlideAnimation(
                    horizontalOffset: -100,
                    child: FadeInAnimation(
                      child: BigPostCard(post: posts[idx]),
                    ),
                  ),
                );
              },
              separatorBuilder: (context, idx) => DesignSystem.spaceH20,
            ),
          ),
        );
      },
    );
  }
}

/// Big post card
class BigPostCard extends StatelessWidget {
  final Post post;
  const BigPostCard({required this.post, Key? key}) : super(key: key);

  void _navigateToPost(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PostScreen(post: post),
      ),
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
        child: ListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            BigPostCoverImg(url: post.coverImgURL),
            PostInfo(post: post),
          ],
        ),
      ),
    );
  }
}

/// Cover image
class BigPostCoverImg extends StatelessWidget {
  final String url;
  const BigPostCoverImg({required this.url, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(image: NetworkImage(url), fit: BoxFit.cover),
      ),
    );
  }
}

/// Display post info
class PostInfo extends StatelessWidget {
  final Post post;
  const PostInfo({required this.post, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      height: 92 + 10, // the first SizedBox of height 10 as spacing
      child: ListView(
        children: [
          const SizedBox(height: 10),
          PostMetadata(
            authorName: post.user.username,
            authorProfilePicURL: post.user.profilePicURL,
            updatedAt: post.updatedAt,
          ),
          DesignSystem.spaceH20,
          Text(post.title, style: DesignSystem.heading4),
          DesignSystem.spaceH20,
          Text(post.description, style: DesignSystem.bodyIntro),
          DesignSystem.spaceH20,
          const Text(
            'Read more',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: DesignSystem.secondary,
              fontSize: 20,
              fontFamily: DesignSystem.fontHighlight,
              fontWeight: FontWeight.w400,
            ),
          ),
          DesignSystem.spaceH20,
        ],
      ),
    );
  }
}

/// Post inline info which has [authorProfilePicURL], [authorName] and
/// [updatedAt]
class PostMetadata extends StatelessWidget {
  final String authorProfilePicURL;
  final String authorName;
  final DateTime updatedAt;

  const PostMetadata({
    required this.authorProfilePicURL,
    required this.authorName,
    required this.updatedAt,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AuthorProfilePic(url: authorProfilePicURL),
        const SizedBox(width: 16),
        Text(
          authorName,
          style: const TextStyle(
            color: DesignSystem.text1,
            fontFamily: DesignSystem.fontBody,
            fontWeight: FontWeight.w600,
            fontSize: 17,
          ),
        ),
        const SizedBox(width: 16),
        Text(
          '${updatedAt.day} ${monthNames[updatedAt.month - 1]} ${updatedAt.year}',
          style: DesignSystem.small,
        ),
      ],
    );
  }
}

/// Author profile pic of size `40X40` takes [url]
class AuthorProfilePic extends StatelessWidget {
  final String url;
  const AuthorProfilePic({required this.url, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xffCEA209), width: 1.6),
        image: DecorationImage(image: NetworkImage(url), fit: BoxFit.cover),
      ),
    );
  }
}
