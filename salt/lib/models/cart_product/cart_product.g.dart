// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CartProduct _$CartProductFromJson(Map<String, dynamic> json) {
  return CartProduct(
    id: json['id'] as String,
    title: json['title'] as String,
    description: json['description'] as String,
    coverImgURLs: (json['coverImgURLs'] as List<dynamic>)
        .map((e) => e as String)
        .toList(),
    quantity: json['quantity'] as int,
    price: (json['price'] as num).toDouble(),
  );
}

Map<String, dynamic> _$CartProductToJson(CartProduct instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'coverImgURLs': instance.coverImgURLs,
      'quantity': instance.quantity,
      'price': instance.price,
    };
