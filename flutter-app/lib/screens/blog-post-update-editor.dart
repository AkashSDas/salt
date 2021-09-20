import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salt/models/blog-post/blog-post.dart';
import 'package:salt/providers/blog-post-editor.dart';
import 'package:salt/providers/food-categories.dart';
import 'package:salt/widgets/update-blog-post-editor/update-blog-post-editor.dart';

class UpdateBlogPostEditorScreen extends StatelessWidget {
  final BlogPost post;
  const UpdateBlogPostEditorScreen({
    required this.post,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => BlogPostEditorProvider.fromBlogPost(
            post.title,
            post.description,
            post.content,
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => FoodCategoriesProvider.fromBlogPost(
            post.categories,
          ),
        ),
      ],
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(),
          body: UpdateBlogPostEditor(),
        ),
      ),
    );
  }
}
