import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:salt/designs/designs.dart';
import 'package:salt/models/recipe/recipe.dart';
import 'package:salt/widgets/food-categories/food-category-tags.dart';

class RecipeScreen extends StatelessWidget {
  final Recipe recipe;
  const RecipeScreen({required this.recipe, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: EdgeInsets.all(16),
          child: ListView(
            // crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                recipe.title,
                style: Theme.of(context).textTheme.headline2,
              ),
              _buildSpace(),
              Text(
                recipe.description,
                style: Theme.of(context).textTheme.bodyText1,
              ),
              _buildSpace(),
              Container(
                height: 220,
                decoration: BoxDecoration(
                  color: DesignSystem.grey1,
                  image: DecorationImage(
                    image: NetworkImage(recipe.coverImgURL),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              _buildSpace(),
              FoodCategoryTags(categories: recipe.categories),
              _buildSpace(),
              _buildIngredients(context),
              _buildSpace(),
              Markdown(
                // selectable: true,
                padding: EdgeInsets.all(0),

                /// Below 2 properties are needed for having only the parent
                /// scrollable widget (ListView here to scroll) and the child
                /// scrollable widget to take its height as content height and
                /// not scroll separately
                ///
                /// This is a great working solution when you have 2 unbounded
                /// widgets (one parent and the other as child). Because here
                /// you've to wrap child with either Container, SizedBox or some
                /// widget with constraint in height propert (height: 300), so
                /// the child scrollable widget will now have a height of 300px
                /// but What if you want to display the entire content and not
                /// just 300px of it? For this add the below 2 lines in your child
                /// scrollable whidget
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),

                data: recipe.content,
                styleSheet: MarkdownStyleSheet(
                  h2: Theme.of(context).textTheme.headline2,
                  p: Theme.of(context).textTheme.bodyText2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSpace() => SizedBox(height: 16);

  Widget _buildIngredients(BuildContext context) {
    TextStyle? _headingTextStyle =
        Theme.of(context).textTheme.caption?.copyWith(
              color: Colors.black,
              fontWeight: FontWeight.w700,
            );

    TextStyle? _bodyTextStyle = Theme.of(context).textTheme.caption?.copyWith(
          fontWeight: FontWeight.w400,
        );

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: [
          DataColumn(label: Text('Ingredient', style: _headingTextStyle)),
          DataColumn(label: Text('Quantity', style: _headingTextStyle)),
          DataColumn(label: Text('Description', style: _headingTextStyle)),
        ],
        rows: List.generate(
          recipe.ingredients.length,
          (index) => DataRow(
            cells: [
              DataCell(
                Text(recipe.ingredients[index].name, style: _bodyTextStyle),
              ),
              DataCell(
                Text(recipe.ingredients[index].quantity, style: _bodyTextStyle),
              ),
              DataCell(
                Text(
                  recipe.ingredients[index].description,
                  style: _bodyTextStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
