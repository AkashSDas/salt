import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salt/providers/blog-post-editor.dart';
import 'package:salt/providers/food-categories.dart';
import 'package:salt/widgets/blog-post-editor/blog-post-editor.dart';

class BlogPostEditorScreen extends StatelessWidget {
  const BlogPostEditorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => FoodCategoriesProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => BlogPostEditorProvider(),
        ),
      ],
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(),
          body: BlogPostEditor(),
        ),
      ),
    );
  }
}
