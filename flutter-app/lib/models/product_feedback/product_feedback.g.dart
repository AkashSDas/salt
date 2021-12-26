// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_feedback.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductFeedback _$ProductFeedbackFromJson(Map<String, dynamic> json) =>
    ProductFeedback(
      id: json['id'] as String,
      rating: json['rating'] as int,
      comment: json['comment'] as String,
      user: User.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ProductFeedbackToJson(ProductFeedback instance) =>
    <String, dynamic>{
      'id': instance.id,
      'rating': instance.rating,
      'comment': instance.comment,
      'user': instance.user,
    };
