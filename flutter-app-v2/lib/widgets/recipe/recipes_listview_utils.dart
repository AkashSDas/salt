import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salt/design_system.dart';
import 'package:salt/providers/recipes_infinite_scroll.dart';
import 'package:salt/widgets/loaders/index.dart';

class RecipesInfiniteScrollWrapper extends StatelessWidget {
  final Widget child;

  const RecipesInfiniteScrollWrapper({
    required this.child,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => RecipesInfiniteScrollProvider(),
      child: child,
    );
  }
}

class RecipesListViewEnd extends StatelessWidget {
  const RecipesListViewEnd({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    RecipesInfiniteScrollProvider _provider =
        Provider.of<RecipesInfiniteScrollProvider>(context);

    if (_provider.reachedEnd) {
      return const Text("You've reached end", style: DesignSystem.bodyIntro);
    }

    return const CircularLoader();
  }
}
