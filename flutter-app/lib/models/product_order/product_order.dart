import 'package:json_annotation/json_annotation.dart';
import 'package:salt/models/product/product.dart';
import 'package:salt/models/user_feedback/user_feedback.dart';

part 'product_order.g.dart';

@JsonSerializable()
class ProductOrder {
  final String id;
  final double price;
  final int quantity;
  final Product product;
  final UserFeedback? feedback;

  ProductOrder({
    required this.id,
    required this.price,
    required this.quantity,
    required this.product,
    this.feedback,
  });

  factory ProductOrder.fromJson(Map<String, dynamic> json) {
    return _$ProductOrderFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ProductOrderToJson(this);
}
