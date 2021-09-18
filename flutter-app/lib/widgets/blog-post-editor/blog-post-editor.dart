import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:provider/provider.dart';
import 'package:salt/providers/food-categories.dart';
import 'package:salt/widgets/blog-post-editor/description-input.dart';
import 'package:salt/widgets/blog-post-editor/food-categories-dropdown.dart';
import 'package:salt/widgets/blog-post-editor/food-categories-tags.dart';
import 'package:salt/widgets/blog-post-editor/title-input.dart';

class BlogPostEditor extends StatefulWidget {
  BlogPostEditor({Key? key}) : super(key: key);

  @override
  _BlogPostEditorState createState() => _BlogPostEditorState();
}

class _BlogPostEditorState extends State<BlogPostEditor> {
  Map<String, String> _formData = {'title': '', 'description': ''};

  final _titleValidator = MultiValidator([
    RequiredValidator(errorText: 'Title is required'),
    MinLengthValidator(
      6,
      errorText: 'Title should be atleast 6 characters long',
    ),
  ]);

  final _descriptionValidator = MultiValidator([
    RequiredValidator(errorText: 'Description is required'),
    MinLengthValidator(
      6,
      errorText: 'Description should be atleast 6 characters long',
    ),
  ]);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => FoodCategoriesProvider(),
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(),
          body: Padding(
            padding: EdgeInsets.all(16),
            child: ListView(
              children: [
                TitleFormInput(
                  name: 'title',
                  label: 'Title',
                  hintText: 'Cool foodo',
                  formData: _formData,
                  validator: _titleValidator,
                ),
                SizedBox(height: 16),
                DescriptionFormInput(
                  name: 'description',
                  label: 'Description',
                  hintText: 'This is how we do it',
                  formData: _formData,
                  validator: _descriptionValidator,
                ),
                SizedBox(height: 16),
                FoodCategoriesDropDown(),
                SizedBox(height: 16),
                FoodCategoriesTags(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
