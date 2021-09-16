import 'package:flutter/material.dart';
import 'package:salt/designs/designs.dart';

class BlogPostMetaData extends StatelessWidget {
  final String authorProfilePicURL;
  final String authorName;
  final String postUpdatedAt;
  final String postReadTime;

  const BlogPostMetaData({
    required this.authorProfilePicURL,
    required this.authorName,
    required this.postUpdatedAt,
    required this.postReadTime,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildAuthorProfilePic(authorProfilePicURL),

        /// Wrap Column widget with Flexible widget to avoid overflow of
        /// text in Text widget inside the Column widget. This is Flexible
        /// widget is needed in order to avoid text overflow
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildMetadataText(context, authorName, true),
              SizedBox(height: 4),
              _buildMetadataText(
                context,
                '$postUpdatedAt - ${postReadTime}min read',
                false,
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMetadataText(BuildContext context, String text, bool bold) {
    return Text(
      text,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: Theme.of(context).textTheme.caption?.copyWith(
            fontSize: 13,
            fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
          ),
    );
  }

  Widget _buildAuthorProfilePic(String photoURL) {
    return Container(
      height: 38,
      width: 38,
      margin: EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        color: DesignSystem.grey1,
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: NetworkImage(photoURL),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
