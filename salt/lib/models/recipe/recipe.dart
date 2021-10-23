import 'package:json_annotation/json_annotation.dart';
import 'package:salt/models/food_category/food_category.dart';
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
  final DateTime createdAt;
  final DateTime updatedAt;

  Recipe({
    required this.title,
    required this.description,
    required this.content,
    required this.coverImgURL,
    required this.readTime,
    required this.categories,
    required this.ingredients,
    required this.author,
    required this.updatedAt,
    required this.createdAt,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return _$RecipeFromJson(json);
  }

  Map<String, dynamic> toJson() => _$RecipeToJson(this);
}
