import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final String id;
  final String email;
  final String username;
  final String profilePicURL;
  final DateTime dateOfBirth;
  final List<String> roles;

  User({
    required this.id,
    required this.email,
    required this.username,
    required this.profilePicURL,
    required this.dateOfBirth,
    required this.roles,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return _$UserFromJson(json);
  }

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
