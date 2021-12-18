import 'package:flutter/material.dart';
import 'package:salt/models/post/post.dart';
import 'package:salt/models/tag/tag.dart';
import 'package:salt/screens/product.dart';
import 'package:salt/widgets/drawer/animate_appbar_on_scroll.dart';
import 'package:salt/widgets/post/big_post_card.dart';

import '../design_system.dart';

class PostScreen extends StatelessWidget {
  final Post post;
  const PostScreen({required this.post, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimateAppBarOnScroll(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(post.title, style: DesignSystem.heading3),
              const SizedBox(height: 20),
              Text(post.description, style: DesignSystem.bodyIntro),
              const SizedBox(height: 20),
              PostMetadata(
                authorProfilePicURL: post.user.profilePicURL,
                authorName: post.user.username,
                updatedAt: post.updatedAt,
              ),
              const SizedBox(height: 20),
              BigPostCoverImg(url: post.coverImgURL),
              const SizedBox(height: 20),
              TagsInlineView(tags: post.tags),
              const SizedBox(height: 20),
              MarkdownContent(text: post.content),
            ],
          ),
        )
      ],
    );
  }
}

class TagsInlineView extends StatelessWidget {
  final List<Tag> tags;
  const TagsInlineView({required this.tags, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: tags.length,
        itemBuilder: (context, idx) {
          return Container(
            height: 44,
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
            margin: EdgeInsets.only(right: idx == tags.length - 1 ? 0 : 16),
            alignment: Alignment.center,
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
      ),
    );
  }
}
