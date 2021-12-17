import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salt/providers/animated_drawer.dart';
import 'package:salt/providers/post_infinite_scroll.dart';
import 'package:salt/widgets/common/loader.dart';
import 'package:salt/widgets/drawer/animated_drawer.dart';
import 'package:salt/widgets/post/limited_posts_view.dart';
import 'package:salt/widgets/recipe/preset_recipe_category.dart';
import 'package:salt/widgets/tag/preset_tag_section.dart';

import '../design_system.dart';

class PostsScreen extends StatelessWidget {
  const PostsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedDrawer(
      child: ChangeNotifierProvider(
        create: (context) => PostInfiniteScrollProvider(),
        child: const _PostsListView(),
      ),
    );
  }
}

class _PostsListView extends StatefulWidget {
  const _PostsListView({Key? key}) : super(key: key);

  @override
  __PostsListViewState createState() => __PostsListViewState();
}

class __PostsListViewState extends State<_PostsListView> {
  final ScrollController _ctrl = ScrollController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      Provider.of<PostInfiniteScrollProvider>(
        context,
        listen: false,
      ).initialFetch();

      /// Scroll event for fetching more posts
      _ctrl.addListener(() {
        var loading = Provider.of<PostInfiniteScrollProvider>(
          context,
          listen: false,
        ).loading;

        var reachedEnd = Provider.of<PostInfiniteScrollProvider>(
          context,
          listen: false,
        ).reachedEnd;

        var pixels = _ctrl.position.pixels;
        var maxScrollExtent = _ctrl.position.maxScrollExtent;

        if (pixels >= maxScrollExtent && !loading && !reachedEnd) {
          /// fetch more
          Provider.of<PostInfiniteScrollProvider>(
            context,
            listen: false,
          ).fetchMore();
        }

        if (pixels >= 0) {
          /// Listview has be scrolled (when == 0 you're at top)
          Provider.of<AnimatedDrawerProvider>(
            context,
            listen: false,
          ).animateAppBar(pixels);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<PostInfiniteScrollProvider>(context);

    return ListView(
      controller: _ctrl,
      children: [
        const PresetTagSection(),
        const SizedBox(height: 20),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: PresetRecipeCategories(),
        ),
        _provider.firstLoading
            ? const SearchLoader()
            : const SizedBox(height: 40),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Posts(),
        ),
        _provider.reachedEnd
            ? Text(
                "You've reached the end",
                style: DesignSystem.bodyMain,
                textAlign: TextAlign.center,
              )
            : !_provider.firstLoading
                ? const SearchLoader()
                : const SizedBox(),
      ],
    );
  }
}

class Posts extends StatelessWidget {
  const Posts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<PostInfiniteScrollProvider>(context);

    return ListView.builder(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      itemCount: _provider.posts.length,
      itemBuilder: (context, idx) {
        return PostCard(idx: idx, posts: _provider.posts);
      },
    );
  }
}
