import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salt/design_system.dart';
import 'package:salt/providers/products_infinite_scroll.dart';
import 'package:salt/widgets/loaders/index.dart';

class ProductsInfiniteScrollWrapper extends StatelessWidget {
  final Widget child;

  const ProductsInfiniteScrollWrapper({
    required this.child,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProductsInfiniteScrollProvider(),
      child: child,
    );
  }
}

class ProductsListViewEnd extends StatelessWidget {
  const ProductsListViewEnd({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<ProductsInfiniteScrollProvider>(context);

    if (_provider.reachedEnd) {
      return const Text("You've reached end", style: DesignSystem.bodyIntro);
    }

    return const CircularLoader();
  }
}
