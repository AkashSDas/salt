import 'package:json_annotation/json_annotation.dart';

part 'cart_product.g.dart';

@JsonSerializable()
class CartProduct {
  final String id;
  final String title;
  final String description;
  final List<String> coverImgURLs;
  int quantity;
  final double price;

  CartProduct({
    required this.id,
    required this.title,
    required this.description,
    required this.coverImgURLs,
    required this.quantity,
    required this.price,
  });

  factory CartProduct.fromJson(Map<String, dynamic> json) {
    return _$CartProductFromJson(json);
  }

  Map<String, dynamic> toJson() => _$CartProductToJson(this);
}
