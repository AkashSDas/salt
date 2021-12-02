// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    id: json['_id'] as String,
    username: json['username'] as String,
    email: json['email'] as String,
    profilePicURL: json['profilePicURL'] as String,
    role: json['role'] as int,
  );
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'username': instance.username,
      'email': instance.email,
      'profilePicURL': instance.profilePicURL,
      'role': instance.role,
    };
