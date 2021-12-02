// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Product _$ProductFromJson(Map<String, dynamic> json) {
  return Product(
    id: json['id'] as String,
    title: json['title'] as String,
    description: json['description'] as String,
    coverImgURLs: (json['coverImgURLs'] as List<dynamic>)
        .map((e) => e as String)
        .toList(),
    quantity_left: json['quantity_left'] as int,
    quantity_sold: json['quantity_sold'] as int,
    price: (json['price'] as num).toDouble(),
  );
}

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'coverImgURLs': instance.coverImgURLs,
      'quantity_left': instance.quantity_left,
      'quantity_sold': instance.quantity_sold,
      'price': instance.price,
    };
