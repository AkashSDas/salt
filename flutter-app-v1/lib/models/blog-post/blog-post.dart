import 'package:json_annotation/json_annotation.dart';
import 'package:salt/models/food-category/food-category.dart';
import 'package:salt/models/user/user.dart';

part 'blog-post.g.dart';

@JsonSerializable()
class BlogPost {
  final String id;
  final String title;
  final String description;
  final String content;
  final String coverImgURL;
  final double readTime;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<FoodCategory> categories;
  final User author;

  BlogPost({
    required this.id,
    required this.title,
    required this.description,
    required this.content,
    required this.coverImgURL,
    required this.readTime,
    required this.createdAt,
    required this.updatedAt,
    required this.categories,
    required this.author,
  });

  factory BlogPost.fromJson(Map<String, dynamic> json) {
    return _$BlogPostFromJson(json);
  }

  Map<String, dynamic> toJson() => _$BlogPostToJson(this);
}
