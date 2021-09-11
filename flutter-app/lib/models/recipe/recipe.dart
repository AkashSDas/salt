import 'package:json_annotation/json_annotation.dart';
import 'package:salt/models/food-category/food-category.dart';
import 'package:salt/models/ingredient/ingredient.dart';
import 'package:salt/models/user/user.dart';

part 'recipe.g.dart';

@JsonSerializable()
class Recipe {
  final String title;
  final String description;
  final String content;
  final String coverImgURL;
  final double readTime;
  final List<FoodCategory> categories;
  final List<Ingredient> ingredients;
  final User author;

  Recipe({
    required this.title,
    required this.description,
    required this.content,
    required this.coverImgURL,
    required this.readTime,
    required this.categories,
    required this.ingredients,
    required this.author,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return _$RecipeFromJson(json);
  }

  Map<String, dynamic> toJson() => _$RecipeToJson(this);
}
