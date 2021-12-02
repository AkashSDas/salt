import 'package:json_annotation/json_annotation.dart';

part 'food-category.g.dart';

@JsonSerializable()
class FoodCategory {
  final String id;
  final String emoji;
  final String name;
  final String description;

  FoodCategory({
    required this.id,
    required this.emoji,
    required this.name,
    required this.description,
  });

  factory FoodCategory.fromJson(Map<String, dynamic> json) {
    return _$FoodCategoryFromJson(json);
  }

  Map<String, dynamic> toJson() => _$FoodCategoryToJson(this);
}
