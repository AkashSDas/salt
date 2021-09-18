// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food-category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

/// The code here is modified by `hand`
/// as id field of FoodCategory will be populated from _id and not id
/// similarly while converting to json id field is removed
/// Note: after making these changes the JsonSerializable decorator
/// from FoodCategory in 'food-category.dart' is removed so that builder
/// doesn't re-generate this 'food-category.g.dart' file, overwritting the
/// changes made here
/// If you want to make any changes then first change FoodCategory and
/// add JsonSerializable decorator on it and then see what changes are
/// made in 'food-category.g.dart' by you and then run the builder and
/// then remove JsonSerializable on FoodCategory and then make the changes
/// that are were made in food-category.g.dart (OR just get the errors and
/// resolve it)

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
