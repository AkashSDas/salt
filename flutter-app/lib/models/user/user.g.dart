// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: json['id'] as String,
      email: json['email'] as String,
      username: json['username'] as String,
      profilePicURL: json['profilePicURL'] as String,
      dateOfBirth: DateTime.parse(json['dateOfBirth'] as String),
      roles: (json['roles'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'username': instance.username,
      'profilePicURL': instance.profilePicURL,
      'dateOfBirth': instance.dateOfBirth.toIso8601String(),
      'roles': instance.roles,
    };
