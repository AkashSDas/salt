import 'package:json_annotation/json_annotation.dart';

part 'product.g.dart';

@JsonSerializable()
class Product {
  final String id;
  final String title;
  final String description;
  final List<String> coverImgURLs;
  final int quantityLeft;
  final int quantitySold;
  final double price;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.coverImgURLs,
    required this.quantityLeft,
    required this.quantitySold,
    required this.price,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return _$ProductFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ProductToJson(this);
}
