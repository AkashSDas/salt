// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CartProduct _$CartProductFromJson(Map<String, dynamic> json) => CartProduct(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      info: json['info'] as String,
      coverImgURLs: (json['coverImgURLs'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      price: (json['price'] as num).toDouble(),
      quantityLeft: json['quantityLeft'] as int,
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      tags: (json['tags'] as List<dynamic>)
          .map((e) => Tag.fromJson(e as Map<String, dynamic>))
          .toList(),
      quantitySelected: json['quantitySelected'] as int,
    );

Map<String, dynamic> _$CartProductToJson(CartProduct instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'info': instance.info,
      'coverImgURLs': instance.coverImgURLs,
      'price': instance.price,
      'quantityLeft': instance.quantityLeft,
      'user': instance.user,
      'tags': instance.tags,
      'quantitySelected': instance.quantitySelected,
    };
