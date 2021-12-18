import 'package:flutter/material.dart';
import 'package:salt/design_system.dart';
import 'package:salt/models/post/post.dart';
import 'package:salt/screens/post.dart';
import 'package:salt/services/post.dart';
import 'package:salt/utils/api.dart';
import 'package:salt/widgets/common/cool.dart';
import 'package:shimmer/shimmer.dart';

/// Inline tag posts
class InlineTagPosts extends StatelessWidget {
  final _service = PostService();
  final String tagId;
  InlineTagPosts({required this.tagId, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _service.getPostsForTag(tagId, limit: 8), // recipe tag
      builder: (context, AsyncSnapshot<ApiResponse> snapshot) {
        if (!snapshot.hasData) return const InlineTagPostsLoader();
        var response = snapshot.data!;
        if (response.error || response.data == null) {
          return const InlineTagPostsLoader();
        }

        List<Post> posts = [];
        for (int i = 0; i < response.data['posts'].length; i++) {
          posts.add(Post.fromJson(response.data['posts'][i]));
        }

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          height: 200,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: posts.length,
                itemBuilder: (context, idx) => InlinePostCard(post: posts[idx]),
              ),
              OthersLongCard(
                onTap: () => Navigator.pushNamed(context, '/recipes'),
              ),
            ],
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
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
          borderRadius: BorderRadius.circular(32),
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
        margin: const EdgeInsets.only(right: 16),
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
