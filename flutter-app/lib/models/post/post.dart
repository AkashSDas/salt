import 'package:json_annotation/json_annotation.dart';
import 'package:salt/models/tag/tag.dart';
import 'package:salt/models/user/user.dart';

part 'post.g.dart';

@JsonSerializable()
class Post {
  final String id;
  final String title;
  final String description;
  final String content;
  final double readTime;
  final int wordCount;
  final bool published;
  final String coverImgURL;
  final User user;
  final List<Tag> tags;
  final DateTime updatedAt;
  final DateTime createdAt;

  Post({
    required this.id,
    required this.title,
    required this.description,
    required this.content,
    required this.readTime,
    required this.wordCount,
    required this.published,
    required this.coverImgURL,
    required this.user,
    required this.tags,
    required this.updatedAt,
    required this.createdAt,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return _$PostFromJson(json);
  }

  Map<String, dynamic> toJson() => _$PostToJson(this);
}
