import 'package:json_annotation/json_annotation.dart';

part 'user_feedback.g.dart';

@JsonSerializable()
class UserFeedback {
  final String id;
  final int rating;
  final String comment;

  UserFeedback({
    required this.id,
    required this.rating,
    required this.comment,
  });

  factory UserFeedback.fromJson(Map<String, dynamic> json) {
    return _$UserFeedbackFromJson(json);
  }

  Map<String, dynamic> toJson() => _$UserFeedbackToJson(this);
}
