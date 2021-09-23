import 'package:json_annotation/json_annotation.dart';

part 'product.g.dart';

@JsonSerializable()
class Product {
  final String id;
  final String title;
  final String description;
  final List<String> coverImgURLs;
  final int quantity_left;
  final int quantity_sold;
  final double price;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.coverImgURLs,
    required this.quantity_left,
    required this.quantity_sold,
    required this.price,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return _$ProductFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ProductToJson(this);
}
