import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// TODO: merge food categories provider for blog post editor
/// into this one

class BlogPostEditorProvider extends ChangeNotifier {
  String title = '';
  String description = '';
  String content = '';

  void updateTitle(String newTitle) {
    title = newTitle;
    notifyListeners();
  }

  void updateDescription(String newDescription) {
    description = newDescription;
    notifyListeners();
  }

  void updateContent(String newContent) {
    content = newContent;
    notifyListeners();
  }

  BlogPostEditorProvider();

  /// for updating post, initialize the post with this constructor
  BlogPostEditorProvider.fromBlogPost(
    String title,
    String description,
    String content,
  ) {
    this.title = title;
    this.description = description;
    this.content = content;
  }
}
