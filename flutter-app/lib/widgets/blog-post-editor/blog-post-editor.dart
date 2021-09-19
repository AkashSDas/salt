import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:salt/designs/designs.dart';
import 'package:salt/providers/blog-post-editor.dart';
import 'package:salt/providers/food-categories.dart';
import 'package:salt/widgets/blog-post-editor/description-input.dart';
import 'package:salt/widgets/blog-post-editor/editor.dart';
import 'package:salt/widgets/blog-post-editor/food-categories-dropdown.dart';
import 'package:salt/widgets/blog-post-editor/food-categories-tags.dart';
import 'package:salt/widgets/blog-post-editor/title-input.dart';

class BlogPostEditor extends StatefulWidget {
  BlogPostEditor({Key? key}) : super(key: key);

  @override
  _BlogPostEditorState createState() => _BlogPostEditorState();
}

class _BlogPostEditorState extends State<BlogPostEditor> {
  Map<String, String> _formData = {
    'title': '',
    'description': '',
    'content': ''
  };

  final ImagePicker _picker = ImagePicker();
  List<XFile>? _imageFiles;

  bool preview = false;

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

  final _contentValidator = MultiValidator([
    RequiredValidator(errorText: 'Content is required'),
    MinLengthValidator(
      6,
      errorText: 'Content should be atleast 6 characters long',
    ),
  ]);

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
                SizedBox(height: 16),

                /// Wrapping text button with column to avoid text button
                /// taking entire width and then fixing the its width with padding
                /// and content width
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextButton(
                      onPressed: () async {
                        try {
                          final pickedFile = await _picker.pickImage(
                            source: ImageSource.gallery,
                          );

                          if (pickedFile != null)
                            setState(() {
                              _imageFiles = [pickedFile];
                            });
                        } catch (err) {}
                      },
                      child: Text(
                        'Choose cover image',
                        style: TextStyle(
                          color: DesignSystem.grey4,
                          fontFamily: 'Sofia Pro',
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                        ),
                      ),
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        backgroundColor: MaterialStateProperty.all(
                          Theme.of(context).accentColor.withOpacity(0.6),
                        ),
                        padding: MaterialStateProperty.all(
                          EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                _imageFiles != null
                    ? Container(
                        height: 16 * 10,
                        decoration: BoxDecoration(
                          color: DesignSystem.grey2,
                          borderRadius: BorderRadius.circular(12),
                          image: DecorationImage(
                            image: Image.file(
                              File(_imageFiles![0].path),
                            ).image,
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    : SizedBox(),

                SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextButton(
                      onPressed: () {
                        setState(() {
                          preview = !preview;
                        });
                      },
                      child: Text(
                        'Preview',
                        style: TextStyle(
                          color: DesignSystem.grey4,
                          fontFamily: 'Sofia Pro',
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                        ),
                      ),
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        backgroundColor: MaterialStateProperty.all(
                          Theme.of(context).accentColor.withOpacity(0.6),
                        ),
                        padding: MaterialStateProperty.all(
                          EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                preview
                    ? Markdown(data: _formData['content'] ?? '')
                    : BlogEditor(
                        name: 'content',
                        label: 'Content',
                        hintText: 'Amazing content goes here',
                        formData: _formData,
                        validator: _contentValidator,
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
