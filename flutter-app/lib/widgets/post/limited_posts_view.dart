import 'package:flutter/material.dart';
import 'package:salt/models/post/post.dart';
import 'package:salt/services/post.dart';
import 'package:salt/utils/api.dart';
import 'package:salt/utils/index.dart';
import 'package:salt/widgets/common/buttons.dart';
import 'package:salt/widgets/common/loader.dart';

import '../../design_system.dart';

class LimitedPostsView extends StatelessWidget {
  final int limit;
  final _service = PostService();
  LimitedPostsView({required this.limit, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: 'Human, ',
              style: DesignSystem.heading3,
              children: [
                TextSpan(
                  text: 'explore',
                  style: DesignSystem.heading3.copyWith(
                    color: DesignSystem.secondary,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        FutureBuilder(
          future: _service.getPostsPagniated(limit: 5),
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
              child: _Posts(posts: posts),
            );
          },
        ),
      ],
    );
  }
}

class _Posts extends StatelessWidget {
  final List<Post> posts;
  const _Posts({required this.posts, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          itemCount: posts.length,
          itemBuilder: (context, idx) {
            return PostCard(idx: idx, posts: posts);
          },
        ),
        const SizedBox(height: 20),
        SecondaryButton(
          text: 'See more...',
          onPressed: () {},
          horizontalPadding: 64,
        ),
      ],
    );
  }
}

class PostCard extends StatelessWidget {
  final int idx;
  final List<Post> posts;

  const PostCard({
    required this.idx,
    required this.posts,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
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
              _CoverImg(url: posts[idx].coverImgURL),
              _PostInfo(post: posts[idx]),
            ],
          ),
        ),
        SizedBox(height: idx == 2 ? 0 : 20),
      ],
    );
  }
}

class _CoverImg extends StatelessWidget {
  final String url;
  const _CoverImg({required this.url, Key? key}) : super(key: key);

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

class _PostInfo extends StatelessWidget {
  final Post post;
  const _PostInfo({required this.post, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      height: 92 + 10, // the first SizedBox of height 10 as spacing
      child: ListView(
        children: [
          const SizedBox(height: 10),
          _PostMetadata(
            authorName: post.user.username,
            authorProfilePicURL: post.user.profilePicURL,
            updatedAt: post.updatedAt,
          ),
          const SizedBox(height: 10),
          Text(post.title, style: DesignSystem.bodyMain),
        ],
      ),
    );
  }
}

class _PostMetadata extends StatelessWidget {
  final String authorProfilePicURL;
  final String authorName;
  final DateTime updatedAt;

  const _PostMetadata({
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
        _AuthorProfilePic(url: authorProfilePicURL),
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

class _AuthorProfilePic extends StatelessWidget {
  final String url;
  const _AuthorProfilePic({required this.url, Key? key}) : super(key: key);

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
