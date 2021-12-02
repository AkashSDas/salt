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
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: DesignSystem.grey1,
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                image: NetworkImage(recipe.coverImgURL),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [Colors.black, Colors.transparent],
              ),
            ),
            child: Container(
              padding: EdgeInsets.symmetric(
                vertical: 16,
                horizontal: 8,
              ),
              alignment: Alignment.bottomLeft,
              child: Text(
                clampText(recipe.title),
                style: Theme.of(context).textTheme.caption?.copyWith(
                      color: Colors.white,
                    ),
              ),
            ),
          )
        ],
      ),
    );
  }

  String clampText(String text) {
    int upto = 35;
    if (text.length > upto) return text.substring(0, upto) + '...';
    return text;
  }
}
