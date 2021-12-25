// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_feedback.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserFeedback _$UserFeedbackFromJson(Map<String, dynamic> json) => UserFeedback(
      id: json['id'] as String,
      rating: json['rating'] as int,
      comment: json['comment'] as String,
    );

Map<String, dynamic> _$UserFeedbackToJson(UserFeedback instance) =>
    <String, dynamic>{
      'id': instance.id,
      'rating': instance.rating,
      'comment': instance.comment,
    };
