import 'package:flutter/material.dart';
import 'package:salt/designs/designs.dart';
import 'package:salt/models/blog-post/blog-post.dart';
import 'package:salt/utils.dart';
import 'package:salt/widgets/blog-post/blog-post.dart';

class BlogPostCard extends StatelessWidget {
  final BlogPost post;
  const BlogPostCard({required this.post, Key? key}) : super(key: key);

  void gotoPost(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BlogPostScreen(post: post)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => gotoPost(context),
      child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: DesignSystem.subtleBoxShadow,
          ),
          margin: EdgeInsets.only(bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCoverImg(),
              _buildSpace(),
              _buildTitle(context),
              _buildSpace(),
              Container(
                margin: EdgeInsets.only(bottom: 8, right: 8, left: 8),
                child: _buildMetadata(context),
              )
            ],
          )),
    );
  }

  Widget _buildSpace() => SizedBox(height: 8);

  Widget _buildCoverImg() {
    return Container(
      height: 160,
      decoration: BoxDecoration(
        color: DesignSystem.grey2,
        image: DecorationImage(
          image: NetworkImage(post.coverImgURL),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
    );
  }

  TextStyle? _titleStyle(BuildContext context, bool bold) {
    return Theme.of(context).textTheme.bodyText1?.copyWith(
          fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
          color: Theme.of(context).textTheme.headline1?.color,
        );
  }

  Widget _buildTitle(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      child: Text(
        post.title,
        style: _titleStyle(context, true),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  TextStyle? _captionStyle(BuildContext context, bool bold) {
    return Theme.of(context).textTheme.caption?.copyWith(
          fontSize: 13,
          fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
        );
  }

  Widget _buildMetadata(BuildContext context) {
    return Row(
      children: [
        _buildAuthorProfilePic(),

        /// Wrap Column widget with Flexible widget to avoid overflow of
        /// text in Text widget inside the Column widget. This is Flexible
        /// widget is needed in order to avoid text overflow
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                post.author.username,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: _captionStyle(context, true),
              ),
              SizedBox(height: 4),
              Text(
                '${formatDateTime(post.updatedAt)} - ${post.readTime}min read',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: _captionStyle(context, false),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAuthorProfilePic() {
    return Container(
      height: 38,
      width: 38,
      margin: EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        color: DesignSystem.grey1,
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: NetworkImage(post.author.profilePicURL),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
