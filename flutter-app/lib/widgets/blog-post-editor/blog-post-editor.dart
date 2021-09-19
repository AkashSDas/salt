import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:salt/designs/designs.dart';
import 'package:salt/providers/blog-post-editor.dart';
import 'package:salt/providers/food-categories.dart';
import 'package:salt/providers/user.dart';
import 'package:salt/services/blog-post.dart';
import 'package:salt/widgets/blog-post-editor/description-input.dart';
import 'package:salt/widgets/blog-post-editor/editor.dart';
import 'package:salt/widgets/blog-post-editor/food-categories-dropdown.dart';
import 'package:salt/widgets/blog-post-editor/food-categories-tags.dart';
import 'package:salt/widgets/blog-post-editor/preview.dart';
import 'package:salt/widgets/blog-post-editor/title-input.dart';
import 'package:salt/widgets/blog-post/blog-post.dart';
import 'package:salt/widgets/common/snackbar.dart';

class BlogPostEditor extends StatefulWidget {
  BlogPostEditor({Key? key}) : super(key: key);

  @override
  _BlogPostEditorState createState() => _BlogPostEditorState();
}

class _BlogPostEditorState extends State<BlogPostEditor> {
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
          _imageFiles.length > 0
              ? Container(
                  height: 16 * 10,
                  decoration: BoxDecoration(
                    color: DesignSystem.grey2,
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: Image.file(
                        File(_imageFiles[0].path),
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
          preview ? PreviewBlogPost() : BlogEditor(),
          SizedBox(height: 32),
          TextButton(
            style: ButtonStyle(
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32),
                ),
              ),
              backgroundColor: MaterialStateProperty.all(
                Theme.of(context).accentColor,
              ),
              padding: MaterialStateProperty.all(
                EdgeInsets.symmetric(vertical: 20, horizontal: 56),
              ),
            ),
            onPressed: () async {
              if (_user.token == null) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                    'You must be logged in to upload your post ${_user.token}',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        ?.copyWith(color: Colors.white),
                  ),
                  backgroundColor: Colors.red,
                ));
              } else if (_imageFiles.length > 0) {
                NewBlogPost post = NewBlogPost(
                  title: _provider.title,
                  description: _provider.description,
                  content: _provider.content,
                  categories: _fcProvider.getAllTagIds(),
                  authorId: _user.user!.id,
                  coverImg: _imageFiles[0],
                );

                var res = await saveBlogPost(post, _user.token.toString());
                if (res[1] != null)
                  displaySnackBar(
                    context: context,
                    success: false,
                    msg: 'Something went wrong, Please try again',
                  );
                else if (res[0]['error'])
                  displaySnackBar(
                    context: context,
                    success: false,
                    msg: res[0]['message'],
                  );
                else
                  displaySnackBar(
                    context: context,
                    success: true,
                    msg: 'Successfully created post',
                  );
              }
            },
            child: Text(
              'Save',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Sofia Pro',
                fontWeight: FontWeight.w900,
                letterSpacing: 2,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
