import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:salt/models/post/post.dart';
import 'package:salt/services/post.dart';
import 'package:salt/utils/api.dart';
import 'package:salt/widgets/common/loader.dart';

import '../../design_system.dart';

class OthersRecipePostsInlineView extends StatelessWidget {
  const OthersRecipePostsInlineView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text("Explore other's recipes", style: DesignSystem.small),
        const SizedBox(height: 20),
        _RecipesWrapper(),
      ],
    );
  }
}

class _RecipesWrapper extends StatelessWidget {
  final _service = PostService();
  _RecipesWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _service.getPostsForTag(
        '61bcb1529a229216955b03fe',
        limit: 8,
      ), // recipe tag
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

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          height: 200,
          child: _InlineView(posts: posts),
        );
      },
    );
  }
}

class _InlineView extends StatelessWidget {
  final List<Post> posts;
  const _InlineView({required this.posts, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemCount: posts.length,
          itemBuilder: (context, idx) {
            return Container(
              height: 200,
              width: 130,
              margin: const EdgeInsets.only(right: 16),
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Stack(
                children: [
                  _CoverImage(url: posts[idx].coverImgURL),
                  _MaskWithTitle(title: posts[idx].title),
                ],
              ),
            );
          },
        ),
        Container(
          height: 200,
          width: 130,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: DesignSystem.purple,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              SizedBox(
                height: 40,
                width: 40,
                child: FlareActor(
                  'assets/flare/other-emojis/smiling-face-with-sunglasses.flr',
                  alignment: Alignment.center,
                  fit: BoxFit.contain,
                  animation: 'go',
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Others',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: DesignSystem.fontHighlight,
                  fontSize: 17,
                  color: DesignSystem.text1,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CoverImage extends StatelessWidget {
  final String url;
  const _CoverImage({required this.url, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(image: NetworkImage(url), fit: BoxFit.cover),
      ),
    );
  }
}

class _MaskWithTitle extends StatelessWidget {
  final String title;
  const _MaskWithTitle({required this.title, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [Color(0xff1F1F1F), Colors.transparent],
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(4),
        alignment: Alignment.bottomLeft,
        child: Text(
          title,
          style: DesignSystem.caption.copyWith(color: DesignSystem.text1),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
