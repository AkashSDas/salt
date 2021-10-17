import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salt/models/blog-post/blog-post.dart';
import 'package:salt/providers/blog-post-editor.dart';
import 'package:salt/widgets/blog-post-editor/content-input.dart';
import 'package:salt/widgets/blog-post-editor/content-preview.dart';
import 'package:salt/widgets/blog-post-editor/description-input.dart';
import 'package:salt/widgets/blog-post-editor/food-categories-tags.dart';
import 'package:salt/widgets/blog-post-editor/image-picker.dart';
import 'package:salt/widgets/blog-post-editor/title-input.dart';
import 'package:salt/widgets/blog-post-editor/update-button.dart';
import 'package:salt/widgets/blog-post-editor/update-cover-image-viewer.dart';
import 'package:salt/widgets/blog-post-editor/update-food-categories.dart';
import 'package:salt/widgets/common/btns.dart';

/// ListView automatic alive is needed to keep the context in save button,
/// tags dropdown, food categories dropdown alive
/// and for that addAutomaticeKeepAlives is true
/// https://stackoverflow.com/questions/52541172/flutter-listview-keepalive-after-some-scroll

class UpdateBlogPostEditorScreen extends StatefulWidget {
  final BlogPost post;

  const UpdateBlogPostEditorScreen({
    required this.post,
    Key? key,
  }) : super(key: key);

  @override
  State<UpdateBlogPostEditorScreen> createState() =>
      _UpdateBlogPostEditorScreenState();
}

class _UpdateBlogPostEditorScreenState
    extends State<UpdateBlogPostEditorScreen> {
  bool previewContent = false;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => BlogPostEditorFormProvider.fromBlogPost(
        title: widget.post.title,
        description: widget.post.description,
        content: widget.post.content,
        tags: widget.post.categories,
      ),
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(),
          body: Padding(
            padding: EdgeInsets.all(16).copyWith(bottom: 32),
            child: ListView(
              addAutomaticKeepAlives: true,
              children: [
                BlogPostEditorFormTitleInput(),
                SizedBox(height: 16),
                BlogPostEditorFormDescriptionInput(),
                SizedBox(height: 16),
                UpdateBlogPostEditorFoodCategoriesDropDown(),
                SizedBox(height: 16),
                BlogPostEditorFoodCategoriesTags(),
                SizedBox(height: 16),
                BlogPostEditorImagePicker(),
                SizedBox(height: 16),
                UpdateBlogPostEditorCoverImageViewer(
                  coverImgURL: widget.post.coverImgURL,
                ),
                SizedBox(height: 16),
                ExpandedButton(
                  text: 'Preview',
                  onPressed: () => setState(
                    () => previewContent = !previewContent,
                  ),
                ),
                SizedBox(height: 16),
                previewContent
                    ? BlogPostEditorContentPreview()
                    : BlogPostEditorFormContentInput(),
                SizedBox(height: 16),
                BlogPostEditorUpdateButton(postId: widget.post.id),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
