import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:salt/design_system.dart';
import 'package:salt/models/post/post.dart';
import 'package:salt/services/post.dart';
import 'package:salt/utils/api.dart';
import 'package:salt/widgets/animations/reveal.dart';
import 'package:salt/widgets/common/divider.dart';
import 'package:salt/widgets/common/loader.dart';
import 'package:salt/widgets/drawer/animate_appbar_on_scroll.dart';
import 'package:salt/widgets/post/big_post.dart';

class RecipesScreen extends StatelessWidget {
  final _service = PostService();
  RecipesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimateAppBarOnScroll(
      children: [
        const _RecipeHeading(),
        DesignSystem.spaceH20,
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: DashedSeparator(height: 1.6),
        ),
        DesignSystem.spaceH20,
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
              child: _PostsListView(posts: posts),
            );
          },
        ),
      ],
    );
  }
}

/// Posts list view
class _PostsListView extends StatelessWidget {
  final List<Post> posts;
  const _PostsListView({required this.posts, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimationLimiter(
          child: ListView.separated(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            itemCount: posts.length,
            separatorBuilder: (context, idx) => DesignSystem.spaceH20,
            itemBuilder: (context, idx) {
              return AnimationConfiguration.staggeredList(
                position: idx,
                duration: const Duration(milliseconds: 375),
                delay: const Duration(milliseconds: 300),
                child: SlideAnimation(
                  horizontalOffset: -100,
                  child: FadeInAnimation(child: BigPostCard(post: posts[idx])),
                ),
              );
            },
          ),
        ),
        DesignSystem.spaceH20,
      ],
    );
  }
}

/// Recipe heading

class _RecipeHeading extends StatefulWidget {
  const _RecipeHeading({Key? key}) : super(key: key);

  @override
  State<_RecipeHeading> createState() => _RecipeHeadingState();
}

class _RecipeHeadingState extends State<_RecipeHeading>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return RevealAnimation(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Text('Recipes', style: DesignSystem.heading1),
      ),
      startAngle: 10,
      startYOffset: 100,
      delay: 100,
      duration: 1000,
      curve: Curves.easeOut,
    );
  }
}
