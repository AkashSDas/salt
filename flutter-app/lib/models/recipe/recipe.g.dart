// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Recipe _$RecipeFromJson(Map<String, dynamic> json) {
  return Recipe(
    title: json['title'] as String,
    description: json['description'] as String,
    content: json['content'] as String,
    coverImgURL: json['coverImgURL'] as String,
    readTime: (json['readTime'] as num).toDouble(),
    categories: (json['categories'] as List<dynamic>)
        .map((e) => FoodCategory.fromJson(e as Map<String, dynamic>))
        .toList(),
    ingredients: (json['ingredients'] as List<dynamic>)
        .map((e) => Ingredient.fromJson(e as Map<String, dynamic>))
        .toList(),
    author: User.fromJson(json['author'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$RecipeToJson(Recipe instance) => <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'content': instance.content,
      'coverImgURL': instance.coverImgURL,
      'readTime': instance.readTime,
      'categories': instance.categories,
      'ingredients': instance.ingredients,
      'author': instance.author,
    };
