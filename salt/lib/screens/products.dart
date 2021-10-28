import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salt/design_system.dart';
import 'package:salt/providers/animated_drawer.dart';
import 'package:salt/providers/products_infinite_scroll.dart';
import 'package:salt/widgets/food_category/inline_food_category.dart';
import 'package:salt/widgets/product/products_listview_utils.dart';
import 'package:salt/widgets/product/products_listview.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({Key? key}) : super(key: key);

  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
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
      Provider.of<ProductsInfiniteScrollProvider>(
        context,
        listen: false,
      ).initialFetch();

      /// Scroll event for fetching more posts
      _ctrl.addListener(() {
        var loading = Provider.of<ProductsInfiniteScrollProvider>(
          context,
          listen: false,
        ).loading;

        var reachedEnd = Provider.of<ProductsInfiniteScrollProvider>(
          context,
          listen: false,
        ).reachedEnd;

        var pixels = _ctrl.position.pixels;
        var maxScrollExtent = _ctrl.position.maxScrollExtent;

        if (pixels >= maxScrollExtent && !loading && !reachedEnd) {
          /// fetch more
          Provider.of<ProductsInfiniteScrollProvider>(
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
    return Padding(
      padding: const EdgeInsets.all(8),
      child: ListView(
        controller: _ctrl,
        clipBehavior: Clip.none,
        children: [
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: DesignSystem.heading2,
              children: [
                const TextSpan(text: 'Shop accross '),
                TextSpan(
                  text: '1000s ',
                  style: DesignSystem.heading2.copyWith(
                    color: DesignSystem.dodgerBlue,
                  ),
                ),
                const TextSpan(text: 'of categories'),
              ],
            ),
          ),
          const SizedBox(height: 32),
          const InlineCategory(),
          const SizedBox(height: 32),
          const ProductsListView(),
          const ProductsListViewEnd(),
        ],
      ),
    );
  }
}
