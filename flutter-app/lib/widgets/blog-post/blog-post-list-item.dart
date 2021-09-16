import 'package:flutter/material.dart';
import 'package:salt/designs/designs.dart';
import 'package:salt/models/blog-post/blog-post.dart';
import 'package:salt/widgets/blog-post/blog-post-metadata.dart';

class BlogPostListItem extends StatelessWidget {
  final BlogPost post;
  const BlogPostListItem({required this.post, Key? key}) : super(key: key);

  String formatDateTime(DateTime dt) {
    var monthNames = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return '${dt.day} ${monthNames[dt.month]}, ${dt.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(12),
        //   boxShadow: [
        //     BoxShadow(
        //       offset: Offset(0, 8),
        //       blurRadius: 16,
        //       color: Color(0xff767676).withOpacity(0.10),
        //     ),
        //     BoxShadow(
        //       offset: Offset(0, -4),
        //       blurRadius: 12,
        //       color: Color(0xff767676).withOpacity(0.025),
        //     ),
        //   ],
        boxShadow: DesignSystem.subtleBoxShadow,
      ),
      margin: EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeaderImg(post.coverImgURL),
          SizedBox(height: 8),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 8),
            child: _buildTitleText(context, post.title, true),
          ),
          SizedBox(height: 8),
          Container(
            margin: EdgeInsets.only(bottom: 8, right: 8, left: 8),
            child: BlogPostMetaData(
              authorProfilePicURL: post.author.profilePicURL,
              authorName: post.author.username,
              postUpdatedAt: formatDateTime(post.updatedAt),
              postReadTime: post.readTime.toString(),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildHeaderImg(String coverImgURL) {
    return Container(
      height: 16 * 10,
      decoration: BoxDecoration(
        color: DesignSystem.grey1,
        image: DecorationImage(
          image: NetworkImage(coverImgURL),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
    );
  }

  Widget _buildTitleText(BuildContext context, String text, bool bold) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodyText1?.copyWith(
            fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
            color: Theme.of(context).textTheme.headline1?.color,
          ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }
}
