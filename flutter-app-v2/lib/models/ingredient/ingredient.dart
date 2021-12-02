import 'package:json_annotation/json_annotation.dart';

part 'ingredient.g.dart';

@JsonSerializable()
class Ingredient {
  final String name;
  final String description;
  final String quantity;

  Ingredient({
    required this.name,
    required this.description,
    required this.quantity,
  });

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return _$IngredientFromJson(json);
  }

  Map<String, dynamic> toJson() => _$IngredientToJson(this);
}
