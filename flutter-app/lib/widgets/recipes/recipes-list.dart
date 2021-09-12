import 'package:flutter/material.dart';
import 'package:salt/services/receipes.dart';
import 'package:salt/widgets/recipes/recipe-list-item-loader.dart';
import 'package:salt/widgets/recipes/recipe-list-item.dart';

class RecipesList extends StatefulWidget {
  const RecipesList({Key? key}) : super(key: key);

  @override
  _RecipesListState createState() => _RecipesListState();
}

class _RecipesListState extends State<RecipesList> {
  late Future<dynamic> _getAllRecipes;

  @override
  void initState() {
    super.initState();
    _getAllRecipes = getAllRecipes();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Trending Recipes',
          style: Theme.of(context).textTheme.bodyText2?.copyWith(
                color: Theme.of(context).textTheme.headline1?.color,
                fontWeight: FontWeight.w700,
              ),
        ),
        SizedBox(height: 16),
        FutureBuilder(
          future: _getAllRecipes,
          builder: (context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) return RecipeListItemLoader();

            var error = snapshot.data[1];
            var data = snapshot.data[0];

            if (error != null || data['error']) return RecipeListItemLoader();

            List<dynamic> recipes = data['data']['recipes'];
            return Container(
              height: 225,
              // padding: EdgeInsets.only(left: 16),
              child: ListView.builder(
                // clipBehavior: Clip.none,
                scrollDirection: Axis.horizontal,
                itemCount: recipes.length,
                itemBuilder: (context, idx) => RecipeListItem(
                  recipe: recipes[idx],
                  key: Key(idx.toString()),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
