// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food-category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FoodCategory _$FoodCategoryFromJson(Map<String, dynamic> json) {
  return FoodCategory(
    id: json['_id'] as String,
    emoji: json['emoji'] as String,
    name: json['name'] as String,
    description: json['description'] as String,
  );
}

Map<String, dynamic> _$FoodCategoryToJson(FoodCategory instance) =>
    <String, dynamic>{
      'emoji': instance.emoji,
      'name': instance.name,
      'description': instance.description,
    };
