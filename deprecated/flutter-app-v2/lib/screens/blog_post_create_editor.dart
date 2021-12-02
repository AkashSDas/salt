import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:provider/provider.dart';
import 'package:salt/design_system.dart';
import 'package:salt/providers/blog_post_editor.dart';
import 'package:salt/widgets/blog_post_editor/btns.dart';
import 'package:salt/widgets/blog_post_editor/food_category_dropdown.dart';
import 'package:salt/widgets/blog_post_editor/food_category_tag.dart';
import 'package:salt/widgets/blog_post_editor/form.dart';

class BlogPostCreateEditorScreen extends StatelessWidget {
  const BlogPostCreateEditorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => BlogPostEditorCreateProvider(),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TitleInputField(),
              const SizedBox(height: 32),
              DescriptionInputField(),
              const SizedBox(height: 32),
              const FoodCategoryDropDown(),
              const SizedBox(height: 8),
              const FoodCategoryTag(),
              const SizedBox(height: 32),
              const _CoverImgViewer(),
              const SizedBox(height: 8),
              SizedBox(
                height: 50,
                child: Row(
                  children: [
                    CoverImagePickerButton(),
                    const SizedBox(width: 8),
                    const PreviewContentButton(),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              const _ContentViewer(),
              const SizedBox(height: 32),
              const SizedBox(
                height: 54,
                width: double.infinity,
                child: SaveButton(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ContentViewer extends StatelessWidget {
  const _ContentViewer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BlogPostEditorCreateProvider _p = Provider.of<BlogPostEditorCreateProvider>(
      context,
    );

    if (_p.previewContent) {
      return Markdown(
        padding: const EdgeInsets.all(0),
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        data: '**${_p.content[0].toUpperCase()}**${_p.content.substring(1)}',
        styleSheet: MarkdownStyleSheet(
          h1: DesignSystem.heading1,
          h2: DesignSystem.heading2,
          h3: DesignSystem.heading3,
          h4: DesignSystem.heading4,
          p: DesignSystem.bodyIntro,
        ),
      );
    }

    return ContentInputField();
  }
}

class _CoverImgViewer extends StatelessWidget {
  const _CoverImgViewer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BlogPostEditorCreateProvider _p = Provider.of<BlogPostEditorCreateProvider>(
      context,
    );

    if (_p.coverImgFile.isEmpty) {
      return Container(
        height: 250,
        decoration: BoxDecoration(
          color: DesignSystem.gallery,
          borderRadius: BorderRadius.circular(20),
        ),
      );
    }
    return Container(
      height: 250,
      decoration: BoxDecoration(
        color: DesignSystem.gallery,
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          image: Image.file(File(_p.coverImgFile[0].path)).image,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
