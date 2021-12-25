import 'package:flutter/material.dart';
import 'package:salt/design_system.dart';
import 'package:salt/models/post/post.dart';
import 'package:salt/models/tag/tag.dart';
import 'package:salt/screens/post.dart';
import 'package:salt/services/post.dart';
import 'package:salt/utils/api.dart';
import 'package:salt/widgets/animations/reveal.dart';
import 'package:shimmer/shimmer.dart';

/// Related posts
///
/// If [tags] is empty list then it will display latest posts having any tag.
/// If [postId] is given then the resulted posts will filter out post with [postId]
class RelatedInlinePosts extends StatelessWidget {
  final List<Tag> tags;
  final String? postId;

  const RelatedInlinePosts({
    Key? key,
    required this.tags,
    this.postId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RevealAnimation(
          child: Text('Related posts', style: DesignSystem.heading3),
          startAngle: 10,
          delay: 100,
          startYOffset: 60,
          duration: 1000,
        ),
        DesignSystem.spaceH20,
        _Posts(tags: tags, postId: postId),
      ],
    );
  }
}

/// Inline tag posts
class _Posts extends StatelessWidget {
  final _service = PostService();
  final List<Tag> tags;
  final String? postId;
  _Posts({required this.tags, this.postId, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _service.getRelatedPosts(tags, 10),
      builder: (context, AsyncSnapshot<ApiResponse> snapshot) {
        if (!snapshot.hasData) return const InlineTagPostsLoader();
        var response = snapshot.data!;
        if (response.error || response.data == null) {
          return const InlineTagPostsLoader();
        }

        List<Post> posts = [];
        for (int i = 0; i < response.data['posts'].length; i++) {
          if (postId != response.data['posts'][i]['id']) {
            posts.add(Post.fromJson(response.data['posts'][i]));
          }
        }

        return SizedBox(
          height: 200,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: posts.length,
            itemBuilder: (context, idx) => InlinePostCard(post: posts[idx]),
            separatorBuilder: (context, idx) => const SizedBox(width: 16),
          ),
        );
      },
    );
  }
}

/// Inline tag posts loader
class InlineTagPostsLoader extends StatelessWidget {
  const InlineTagPostsLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        itemBuilder: (context, idx) => const InlinePostCardLoader(),
      ),
    );
  }
}

/// Inline post card loader
class InlinePostCardLoader extends StatelessWidget {
  const InlinePostCardLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      child: Container(
        height: 200,
        width: 130,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      baseColor: DesignSystem.shimmerBaseColor,
      highlightColor: DesignSystem.shimmerHighlightColor,
    );
  }
}

/// Inline post card
class InlinePostCard extends StatelessWidget {
  final Post post;
  const InlinePostCard({required this.post, Key? key}) : super(key: key);

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
        height: 200,
        width: 130,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(children: [_buildCoverImg(), _buildMask()]),
      ),
    );
  }

  Widget _buildCoverImg() {
    final url = post.coverImgURL;
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(image: NetworkImage(url), fit: BoxFit.cover),
      ),
    );
  }

  Widget _buildTitle() {
    return Container(
      padding: const EdgeInsets.all(4),
      alignment: Alignment.bottomLeft,
      child: Text(
        post.title,
        style: DesignSystem.caption.copyWith(color: DesignSystem.text1),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildMask() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [Color(0xff1F1F1F), Colors.transparent],
        ),
      ),
      child: _buildTitle(),
    );
  }
}
