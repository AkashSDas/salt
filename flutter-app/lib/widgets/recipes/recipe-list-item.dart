import 'package:flutter/material.dart';
import 'package:salt/designs/designs.dart';
import 'package:salt/models/recipe/recipe.dart';

class RecipeListItem extends StatelessWidget {
  final Recipe recipe;
  const RecipeListItem({required this.recipe, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 24),
      width: 175,
      height: 225,
      child: Positioned(
        bottom: 0,
        child: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: DesignSystem.grey1,
            borderRadius: BorderRadius.circular(20),
            image: DecorationImage(
              image: NetworkImage(recipe.coverImgURL),
              fit: BoxFit.cover,
            ),
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [Colors.black, Colors.transparent],
            ),
          ),
          child: Container(
            alignment: Alignment.bottomLeft,
            child: Text(recipe.title),
          ),
        ),
      ),
    );
  }
}
