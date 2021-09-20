// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blog-post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BlogPost _$BlogPostFromJson(Map<String, dynamic> json) {
  return BlogPost(
    id: json['_id'] as String,
    title: json['title'] as String,
    description: json['description'] as String,
    content: json['content'] as String,
    coverImgURL: json['coverImgURL'] as String,
    readTime: (json['readTime'] as num).toDouble(),
    createdAt: DateTime.parse(json['createdAt'] as String),
    updatedAt: DateTime.parse(json['updatedAt'] as String),
    categories: (json['categories'] as List<dynamic>)
        .map((e) => FoodCategory.fromJson(e as Map<String, dynamic>))
        .toList(),
    author: User.fromJson(json['author'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$BlogPostToJson(BlogPost instance) => <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'content': instance.content,
      'coverImgURL': instance.coverImgURL,
      'readTime': instance.readTime,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'categories': instance.categories,
      'author': instance.author,
    };
