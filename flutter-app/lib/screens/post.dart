import 'package:flutter/material.dart';
import 'package:salt/models/post/post.dart';
import 'package:salt/models/tag/tag.dart';
import 'package:salt/screens/product.dart';
import 'package:salt/widgets/drawer/animate_appbar_on_scroll.dart';
import 'package:salt/widgets/post/limited_posts_view.dart';

import '../design_system.dart';

class PostScreen extends StatelessWidget {
  final Post post;
  const PostScreen({required this.post, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimateAppBarOnScroll(
      children: [
        Text(post.title, style: DesignSystem.heading3),
        const SizedBox(height: 20),
        Text(post.description, style: DesignSystem.bodyIntro),
        const SizedBox(height: 20),
        TagsInlineView(tags: post.tags),
        const SizedBox(height: 20),
        PostMetadata(
          authorProfilePicURL: post.user.profilePicURL,
          authorName: post.user.username,
          updatedAt: post.updatedAt,
        ),
        const SizedBox(height: 20),
        PostCoverImg(url: post.coverImgURL),
        const SizedBox(height: 20),
        MarkdownContent(text: post.content),
      ],
    );
  }
}

class TagsInlineView extends StatelessWidget {
  final List<Tag> tags;
  const TagsInlineView({required this.tags, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: tags.length,
      itemBuilder: (context, idx) {
        return Container(
          height: 44,
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
          decoration: BoxDecoration(
            border: Border.all(color: DesignSystem.border),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            '${tags[idx].emoji} ${tags[idx].name[0].toUpperCase()}${tags[idx].name.substring(1)}',
            style: DesignSystem.caption,
          ),
        );
      },
    );
  }
}
