import 'package:flutter/material.dart';
import 'package:salt/design_system.dart';
import 'package:salt/models/post/post.dart';
import 'package:salt/models/tag/tag.dart';
import 'package:salt/screens/tag.dart';
import 'package:salt/widgets/common/markdown.dart';
import 'package:salt/widgets/drawer/animate_appbar_on_scroll.dart';
import 'package:salt/widgets/post/big_post.dart';

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
              DesignSystem.spaceH20,
              Text(post.description, style: DesignSystem.bodyIntro),
              DesignSystem.spaceH20,
              PostMetadata(
                authorProfilePicURL: post.user.profilePicURL,
                authorName: post.user.username,
                updatedAt: post.updatedAt,
              ),
              DesignSystem.spaceH20,
              BigPostCoverImg(url: post.coverImgURL),
              DesignSystem.spaceH20,
              TagsInlineView(tags: post.tags),
              DesignSystem.spaceH20,
              MarkdownContent(
                text: post.content,
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
              ),
              DesignSystem.spaceH40,
            ],
          ),
        )
      ],
    );
  }
}

/// Display [tags] in horizontal scroll view
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
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TagScreen(tagId: tags[idx].id),
                ),
              );
            },
            child: Container(
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
            ),
          );
        },
      ),
    );
  }
}
