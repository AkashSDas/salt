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

class SearchProductsScreen extends StatelessWidget {
  final String searchQuery;

  const SearchProductsScreen({
    required this.searchQuery,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedDrawer(
      child: ChangeNotifierProvider(
        create: (context) => SearchProvider.fromQuery(searchQuery: searchQuery),
        child: _ProductsListView(searchQuery: searchQuery),
      ),
    );
  }
}

/// Products list view

class _ProductsListView extends StatefulWidget {
  final String? searchQuery;

  const _ProductsListView({
    required this.searchQuery,
    Key? key,
  }) : super(key: key);

  @override
  __ProductsListViewState createState() => __ProductsListViewState();
}

class __ProductsListViewState extends State<_ProductsListView> {
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
      ).searchForProducts(6);

      /// Scroll event for fetching more posts
      _ctrl.addListener(() {
        var loading = Provider.of<SearchProvider>(
          context,
          listen: false,
        ).productLoading;

        var reachedEnd = Provider.of<SearchProvider>(
          context,
          listen: false,
        ).productReachedEnd;

        var pixels = _ctrl.position.pixels;
        var maxScrollExtent = _ctrl.position.maxScrollExtent;

        if (pixels >= maxScrollExtent && !loading && !reachedEnd) {
          /// fetch more
          Provider.of<SearchProvider>(
            context,
            listen: false,
          ).searchForMoreProducts(6);
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
          const _Products(),
          DesignSystem.spaceH40,
        ],
      ),
    );
  }
}

class _Products extends StatelessWidget {
  const _Products({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _p = Provider.of<SearchProvider>(context);

    return Column(
      children: [
        _p.productLoading ? const SearchLoader() : DesignSystem.spaceH20,
        Products(products: _p.products),
        DesignSystem.spaceH20,
        _p.productReachedEnd
            ? Text(
                "You've reached the end",
                style: DesignSystem.bodyMain,
                textAlign: TextAlign.center,
              )
            : !_p.productReachedEnd
                ? const SearchLoader()
                : const SizedBox(),
      ],
    );
  }
}
