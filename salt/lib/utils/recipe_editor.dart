import 'package:image_picker/image_picker.dart';

class RecipeIngredient {
  final String name;
  final String description;
  final String qunatity;

  RecipeIngredient({
    required this.name,
    required this.description,
    required this.qunatity,
  });

  Map toMap() {
    return {
      'name': name,
      'description': description,
      'quantity': qunatity,
    };
  }
}

class CreateRecipe {
  final String title;
  final String description;
  final String content;
  final List<String> categories;
  final String authorId;
  final XFile coverImg;
  final List<RecipeIngredient> ingredients;

  const CreateRecipe({
    required this.title,
    required this.description,
    required this.content,
    required this.categories,
    required this.authorId,
    required this.coverImg,
    required this.ingredients,
  });
}

class UpdateRecipe {
  final String title;
  final String description;
  final String content;
  final List<String> categories;
  final String authorId;
  final XFile? coverImg;
  final List<RecipeIngredient> ingredients;

  const UpdateRecipe({
    required this.title,
    required this.description,
    required this.content,
    required this.categories,
    required this.authorId,
    required this.ingredients,
    this.coverImg,
  });
}
