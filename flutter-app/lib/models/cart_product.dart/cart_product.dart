import 'package:json_annotation/json_annotation.dart';
import 'package:salt/models/tag/tag.dart';
import 'package:salt/models/user/user.dart';

part 'cart_product.g.dart';

@JsonSerializable()
class CartProduct {
  final String id;
  final String title;
  final String description;
  final String info;
  final List<String> coverImgURLs;
  final double price;
  final int quantityLeft;
  final User user;
  final List<Tag> tags;
  int quantitySelected;

  CartProduct({
    required this.id,
    required this.title,
    required this.description,
    required this.info,
    required this.coverImgURLs,
    required this.price,
    required this.quantityLeft,
    required this.user,
    required this.tags,
    required this.quantitySelected,
  });

  factory CartProduct.fromJson(Map<String, dynamic> json) {
    return _$CartProductFromJson(json);
  }

  Map<String, dynamic> toJson() => _$CartProductToJson(this);
}
