import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:salt/providers/blog-post-editor.dart';
import 'package:salt/providers/food-categories.dart';
import 'package:salt/providers/user.dart';
import 'package:salt/widgets/blog-post-editor/description-input.dart';
import 'package:salt/widgets/blog-post-editor/food-categories-tags.dart';
import 'package:salt/widgets/blog-post-editor/title-input.dart';
import 'package:salt/widgets/update-blog-post-editor/food-categories-dropdown.dart';

class UpdateBlogPostEditor extends StatefulWidget {
  const UpdateBlogPostEditor({Key? key}) : super(key: key);

  @override
  _UpdateBlogPostEditorState createState() => _UpdateBlogPostEditorState();
}

class _UpdateBlogPostEditorState extends State<UpdateBlogPostEditor> {
  final ImagePicker _picker = ImagePicker();

  List<XFile> _imageFiles = [];

  bool preview = false;

  @override
  Widget build(BuildContext context) {
    BlogPostEditorProvider _provider = Provider.of<BlogPostEditorProvider>(
      context,
    );
    FoodCategoriesProvider _fcProvider = Provider.of<FoodCategoriesProvider>(
      context,
    );
    UserProvider _user = Provider.of<UserProvider>(
      context,
    );

    return Padding(
      padding: EdgeInsets.all(16).copyWith(bottom: 32),
      child: ListView(
        children: [
          TitleFormInput(),
          SizedBox(height: 16),
          DescriptionFormInput(),
          SizedBox(height: 16),
          FoodCategoriesDropDown(),
          SizedBox(height: 16),
          FoodCategoriesTags(),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}
