import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salt/design_system.dart';
import 'package:salt/providers/animated_drawer.dart';
import 'package:salt/providers/product_infinite_scroll.dart';
import 'package:salt/screens/tag.dart';
import 'package:salt/widgets/common/loader.dart';
import 'package:salt/widgets/drawer/animated_drawer.dart';
import 'package:salt/widgets/others/scroll_behavior.dart';
import 'package:salt/widgets/product/covers.dart';
import 'package:salt/widgets/product/groceries_inline_tags.dart';
import 'package:salt/widgets/recipe/recipe_categories_section.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedDrawer(
      bottomNavIdx: 1,
      child: ChangeNotifierProvider(
        create: (context) => ProductInfiniteScrollProvider(),
        child: const _ProductsListView(),
      ),
    );
  }
}

/// Products list view

class _ProductsListView extends StatefulWidget {
  const _ProductsListView({Key? key}) : super(key: key);

  @override
  State<_ProductsListView> createState() => _ProductsListViewState();
}

class _ProductsListViewState extends State<_ProductsListView> {
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
      Provider.of<ProductInfiniteScrollProvider>(
        context,
        listen: false,
      ).initialFetch();

      /// Scroll event for fetching more posts
      _ctrl.addListener(() {
        var loading = Provider.of<ProductInfiniteScrollProvider>(
          context,
          listen: false,
        ).loading;

        var reachedEnd = Provider.of<ProductInfiniteScrollProvider>(
          context,
          listen: false,
        ).reachedEnd;

        var pixels = _ctrl.position.pixels;
        var maxScrollExtent = _ctrl.position.maxScrollExtent;

        if (pixels >= maxScrollExtent && !loading && !reachedEnd) {
          /// fetch more
          Provider.of<ProductInfiniteScrollProvider>(
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
    final _provider = Provider.of<ProductInfiniteScrollProvider>(context);

    return ScrollConfiguration(
      behavior: NoHighlightBehavior(),
      child: ListView(
        controller: _ctrl,
        children: [
          const GroceriesCovers(),
          DesignSystem.spaceH20,
          GroceriesInlineTags(),
          DesignSystem.spaceH20,
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: RecipeCategoriesSection(),
          ),
          _provider.firstLoading ? const SearchLoader() : DesignSystem.spaceH20,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Products(products: _provider.products),
          ),
          DesignSystem.spaceH20,
          _provider.reachedEnd
              ? Text(
                  "You've reached the end",
                  style: DesignSystem.bodyMain,
                  textAlign: TextAlign.center,
                )
              : !_provider.firstLoading
                  ? const SearchLoader()
                  : const SizedBox(),
          DesignSystem.spaceH40,
        ],
      ),
    );
  }
}
