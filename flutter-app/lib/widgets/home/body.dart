import 'package:flutter/material.dart';
import 'package:salt/widgets/blog-post/blog-post-list.dart';
import 'package:salt/widgets/food-categories/categories-list.dart';
import 'package:salt/widgets/recipes/recipes-list.dart';

/// Home screen's body
class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      clipBehavior: Clip.none,
      child: Column(
        children: [
          CategoriesList(),
          SizedBox(height: 32),
          RecipesList(),
          SizedBox(height: 32),
          BlogPostList(),
        ],
      ),
    );
  }
}
