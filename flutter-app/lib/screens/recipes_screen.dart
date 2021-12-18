import 'package:flutter/material.dart';
import 'package:salt/design_system.dart';
import 'package:salt/models/post/post.dart';
import 'package:salt/services/post.dart';
import 'package:salt/utils/api.dart';
import 'package:salt/widgets/common/loader.dart';
import 'package:salt/widgets/drawer/animate_appbar_on_scroll.dart';
import 'package:salt/widgets/post/big_post_card.dart';

class RecipesScreen extends StatelessWidget {
  final _service = PostService();
  RecipesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimateAppBarOnScroll(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text('Recipes', style: DesignSystem.heading1),
        ),
        const SizedBox(height: 40),
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

class _PostsListView extends StatelessWidget {
  final List<Post> posts;
  const _PostsListView({required this.posts, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          itemCount: posts.length,
          itemBuilder: (context, idx) {
            return BigPostCard(post: posts[idx]);
          },
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
