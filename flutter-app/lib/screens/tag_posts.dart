import 'package:flutter/material.dart';
import 'package:salt/design_system.dart';
import 'package:salt/models/post/post.dart';
import 'package:salt/screens/tag.dart';
import 'package:salt/services/post.dart';
import 'package:salt/utils/api.dart';
import 'package:salt/widgets/animations/translate.dart';
import 'package:salt/widgets/common/buttons.dart';
import 'package:salt/widgets/common/cool.dart';
import 'package:salt/widgets/common/divider.dart';
import 'package:salt/widgets/common/loader.dart';
import 'package:salt/widgets/drawer/animate_appbar_on_scroll.dart';
import 'package:spring/spring.dart';

class TagPostsScreen extends StatelessWidget {
  final _service = PostService();
  final String tagId;
  final String tagName;

  TagPostsScreen({
    Key? key,
    required this.tagId,
    required this.tagName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimateAppBarOnScroll(
      children: [
        _TagPostsHeading(tagName: tagName),
        DesignSystem.spaceH20,
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: DashedSeparator(height: 1.6),
        ),
        DesignSystem.spaceH20,
        FutureBuilder(
          future: _service.getPostsForTag(tagId),
          builder: (context, AsyncSnapshot<ApiResponse> snapshot) {
            if (!snapshot.hasData) return const SearchLoader();
            final response = snapshot.data;
            if (response == null) return const SearchLoader();
            if (response.error || response.data == null) {
              return const SearchLoader();
            }

            List<Post> posts = [];
            for (int i = 0; i < response.data['posts'].length; i++) {
              posts.add(Post.fromJson(response.data['posts'][i]));
            }

            if (posts.isEmpty) return const _NoPostsAvailable();

            return Padding(
              padding: const EdgeInsets.all(16),
              child: Posts(posts: posts),
            );
          },
        ),
      ],
    );
  }
}

/// Tag posts heading

class _TagPostsHeading extends StatefulWidget {
  final String tagName;

  const _TagPostsHeading({
    Key? key,
    required this.tagName,
  }) : super(key: key);

  @override
  __TagPostsHeadingState createState() => __TagPostsHeadingState();
}

class __TagPostsHeadingState extends State<_TagPostsHeading>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return _buildAnimation(
      RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: 'Read articles on ',
          style: DesignSystem.heading2,
          children: [
            TextSpan(
              text: ' ${widget.tagName}',
              style: DesignSystem.heading2.copyWith(
                color: DesignSystem.secondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimation(Widget child) {
    return Spring.rotate(
      startAngle: 10,
      endAngle: 0,
      animDuration: const Duration(milliseconds: 1000),
      delay: const Duration(milliseconds: 100),
      curve: Curves.easeOut,
      child: TranslateAnimation(
        child: child,
        duration: const Duration(milliseconds: 1000),
        delay: const Duration(milliseconds: 100),
        beginOffset: const Offset(0, 60),
        endOffset: const Offset(0, 0),
        curve: Curves.easeInOut,
      ),
    );
  }
}

/// No posts available
class _NoPostsAvailable extends StatelessWidget {
  const _NoPostsAvailable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const LogoTV(),
        DesignSystem.spaceH20,
        Text(
          'No posts available for this category',
          style: DesignSystem.bodyMain,
        ),
        DesignSystem.spaceH20,
        PrimaryButton(
          text: 'Read something else',
          horizontalPadding: 32,
          onPressed: () => Navigator.pushNamed(context, '/posts'),
        ),
      ],
    );
  }
}
