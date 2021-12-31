import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salt/design_system.dart';
import 'package:salt/providers/animated_drawer.dart';
import 'package:salt/providers/search_provider.dart';
import 'package:salt/screens/tag.dart';
import 'package:salt/widgets/animations/reveal.dart';
import 'package:salt/widgets/common/divider.dart';
import 'package:salt/widgets/common/loader.dart';
import 'package:salt/widgets/drawer/animated_drawer.dart';
import 'package:salt/widgets/others/scroll_behavior.dart';

class SearchPostsScreen extends StatelessWidget {
  final String searchQuery;

  const SearchPostsScreen({
    required this.searchQuery,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedDrawer(
      child: ChangeNotifierProvider(
        create: (context) => SearchProvider.fromQuery(searchQuery: searchQuery),
        child: _PostListView(searchQuery: searchQuery),
      ),
    );
  }
}

/// Posts list view

class _PostListView extends StatefulWidget {
  final String? searchQuery;

  const _PostListView({
    required this.searchQuery,
    Key? key,
  }) : super(key: key);

  @override
  __PostListViewState createState() => __PostListViewState();
}

class __PostListViewState extends State<_PostListView> {
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
      Provider.of<SearchProvider>(
        context,
        listen: false,
      ).searchForPosts(6);

      /// Scroll event for fetching more posts
      _ctrl.addListener(() {
        var loading = Provider.of<SearchProvider>(
          context,
          listen: false,
        ).postLoading;

        var reachedEnd = Provider.of<SearchProvider>(
          context,
          listen: false,
        ).postReachedEnd;

        var pixels = _ctrl.position.pixels;
        var maxScrollExtent = _ctrl.position.maxScrollExtent;

        if (pixels >= maxScrollExtent && !loading && !reachedEnd) {
          /// fetch more
          Provider.of<SearchProvider>(
            context,
            listen: false,
          ).searchForMorePosts(6);
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
    return ScrollConfiguration(
      behavior: NoHighlightBehavior(),
      child: ListView(
        controller: _ctrl,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          RevealAnimation(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                widget.searchQuery ?? 'Search',
                style: DesignSystem.heading1,
              ),
            ),
            startAngle: 10,
            startYOffset: 100,
            delay: 100,
            duration: 1000,
            curve: Curves.easeOut,
          ),
          DesignSystem.spaceH20,
          const DashedSeparator(height: 1.6),
          const _Posts(),
          DesignSystem.spaceH40,
        ],
      ),
    );
  }
}

class _Posts extends StatelessWidget {
  const _Posts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _p = Provider.of<SearchProvider>(context);

    return Column(
      children: [
        _p.postLoading ? const SearchLoader() : DesignSystem.spaceH20,
        Posts(posts: _p.posts),
        DesignSystem.spaceH20,
        _p.postReachedEnd
            ? Text(
                "You've reached the end",
                style: DesignSystem.bodyMain,
                textAlign: TextAlign.center,
              )
            : !_p.postLoading
                ? const SearchLoader()
                : const SizedBox(),
      ],
    );
  }
}
