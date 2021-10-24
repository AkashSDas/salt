import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salt/design_system.dart';
import 'package:salt/models/blog_post/blog_post.dart';
import 'package:salt/providers/blog_post_infinite_scroll.dart';
import 'package:salt/utils/index.dart';
import 'package:salt/widgets/blog_post/blog_post_listview_utils.dart';

/// This widget is meant to be used inside another listview
/// which will get (from backend) more posts when user reaches the
/// end of that listview

class BlogPostListView extends StatelessWidget {
  const BlogPostListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BlogPostInfiniteScrollProvider _provider =
        Provider.of<BlogPostInfiniteScrollProvider>(context);

    if (_provider.firstLoading) return const BlogPostListViewCircularLoader();
    if (_provider.firstError) {
      return Center(
        child: Text(
          _provider.firstApiResponseMsg,
          style: DesignSystem.bodyIntro,
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      itemCount: _provider.posts.length,
      itemBuilder: (context, idx) {
        if (idx == _provider.posts.length - 1) {
          return _Card(post: _provider.posts[idx]);
        }

        return Column(
          children: [
            _Card(post: _provider.posts[idx]),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }
}

class _Card extends StatelessWidget {
  final BlogPost post;
  const _Card({required this.post, Key? key}) : super(key: key);

  void _gotoView(BuildContext context) {}

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _gotoView(context),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: DesignSystem.boxShadow1,
        ),

        /// Wrap Column widget with Flexible widget to avoid overflow of
        /// text in Text widget inside the Column widget. This is Flexible
        /// widget is needed in order to avoid text overflow
        child: Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _CardCoverImg(imgURL: post.coverImgURL),
              const SizedBox(height: 12),
              _CardTitle(title: post.title),
              const SizedBox(height: 12),
              _CardMetadata(post: post),
            ],
          ),
        ),
      ),
    );
  }
}

class _CardCoverImg extends StatelessWidget {
  final String imgURL;
  const _CardCoverImg({required this.imgURL, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      decoration: BoxDecoration(
        color: DesignSystem.gallery,
        image: DecorationImage(image: NetworkImage(imgURL), fit: BoxFit.cover),
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }
}

class _CardTitle extends StatelessWidget {
  final String title;
  const _CardTitle({required this.title, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: DesignSystem.heading4.copyWith(fontSize: 20),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class _CardMetadata extends StatelessWidget {
  final BlogPost post;
  const _CardMetadata({required this.post, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildAuthorProfilePic(),
        const SizedBox(width: 16),
        _buildPostInfo(),
      ],
    );
  }

  Widget _buildAuthorProfilePic() {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        color: DesignSystem.gallery,
        borderRadius: BorderRadius.circular(8),
        image: DecorationImage(
          image: NetworkImage(post.author.profilePicURL),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildPostInfo() {
    var dt = post.updatedAt;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          post.author.username,
          style: DesignSystem.bodyMain.copyWith(
            fontWeight: FontWeight.w700,
            color: DesignSystem.tundora,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '${dt.day} ${monthNames[dt.month]}, ${dt.year} - ${post.readTime} min read',
          style: DesignSystem.caption,
        ),
      ],
    );
  }
}
