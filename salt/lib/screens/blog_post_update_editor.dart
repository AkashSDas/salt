import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:provider/provider.dart';
import 'package:salt/design_system.dart';
import 'package:salt/models/blog_post/blog_post.dart';
import 'package:salt/models/food_category/food_category.dart';
import 'package:salt/providers/blog_post_editor.dart';
import 'package:salt/widgets/animated_drawer/animated_drawer.dart';
import 'package:salt/widgets/blog_post_editor/btns.dart';
import 'package:salt/widgets/blog_post_editor/food_category_tag.dart';
import 'package:salt/widgets/blog_post_editor/form.dart';

class BlogPostUpdateEditorScreen extends StatelessWidget {
  final BlogPost post;

  const BlogPostUpdateEditorScreen({
    required this.post,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedDrawer(
      body: ChangeNotifierProvider(
        create: (context) => BlogPostEditorCreateProvider.fromBlogPost(
          title: post.title,
          description: post.description,
          content: post.content,
          tags: post.categories,
        ),
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
                const _FoodCategoryDropDown(),
                const SizedBox(height: 8),
                const FoodCategoryTag(),
                const SizedBox(height: 32),
                _CoverImgViewer(coverImgURL: post.coverImgURL),
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
                SizedBox(
                  height: 54,
                  width: double.infinity,
                  child: UpdateButton(blogId: post.id),
                ),
              ],
            ),
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
  final String coverImgURL;

  const _CoverImgViewer({
    required this.coverImgURL,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BlogPostEditorCreateProvider _p = Provider.of<BlogPostEditorCreateProvider>(
      context,
    );

    return Container(
      height: 250,
      decoration: BoxDecoration(
        color: DesignSystem.gallery,
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          image: _p.coverImgFile.isNotEmpty
              ? Image.file(File(_p.coverImgFile[0].path)).image
              : NetworkImage(coverImgURL),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

/// FOOD CATEGORY

class _FoodCategoryDropDown extends StatefulWidget {
  const _FoodCategoryDropDown({Key? key}) : super(key: key);

  @override
  State<_FoodCategoryDropDown> createState() => __FoodCategoryDropDownState();
}

class __FoodCategoryDropDownState extends State<_FoodCategoryDropDown> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      Provider.of<BlogPostEditorCreateProvider>(
        context,
        listen: false,
      ).fetchAllFoodCategoriedFiltered();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: DesignSystem.gallery,
        borderRadius: BorderRadius.circular(32),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: const _DropDownBtn(),
    );
  }
}

class _DropDownBtn extends StatelessWidget {
  const _DropDownBtn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BlogPostEditorCreateProvider _p = Provider.of<BlogPostEditorCreateProvider>(
      context,
    );

    var items = <FoodCategory>[..._p.foodCategories].map((FoodCategory value) {
      return DropdownMenuItem<String>(
        key: Key(value.id),
        value: value.id,
        child: Text(
          '${value.emoji} ${value.name[0].toUpperCase()}${value.name.substring(1)}',
          style: DesignSystem.bodyMain,
        ),
      );
    }).toList();

    return DropdownButton<String>(
      underline: const SizedBox(),
      isExpanded: true,
      icon: const _DropDownIcon(),
      elevation: 4,
      value: null,
      hint: Text('Select tags', style: DesignSystem.caption),
      items: items,
      onChanged: (id) {
        if (id != null) {
          var selectedCategory = _p.foodCategories
              .where(
                (category) => category.id == id,
              )
              .toList();

          if (selectedCategory.isNotEmpty) {
            _p.addTag(selectedCategory[0]);
            _p.removeFoodCategory(selectedCategory[0].id);
          }
        }
      },
      borderRadius: BorderRadius.circular(16),
      dropdownColor: DesignSystem.white,
    );
  }
}

class _DropDownIcon extends StatelessWidget {
  const _DropDownIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BlogPostEditorCreateProvider _p = Provider.of<BlogPostEditorCreateProvider>(
      context,
    );

    if (_p.foodCategoriesLoading) {
      return const SizedBox(
        height: 24,
        width: 24,
        child: CircularProgressIndicator(),
      );
    }

    return const Icon(Icons.arrow_drop_down_circle_outlined);
  }
}
