import 'package:json_annotation/json_annotation.dart';
import 'package:salt/models/user/user.dart';

part 'product_feedback.g.dart';

@JsonSerializable()
class ProductFeedback {
  final String id;
  final int rating;
  final String comment;
  final User user;

  ProductFeedback({
    required this.id,
    required this.rating,
    required this.comment,
    required this.user,
  });

  factory ProductFeedback.fromJson(Map<String, dynamic> json) {
    return _$ProductFeedbackFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ProductFeedbackToJson(this);
}
