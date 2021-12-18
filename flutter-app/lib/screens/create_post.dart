import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:salt/providers/animated_drawer.dart';
import 'package:salt/providers/post_editor.dart';
import 'package:salt/providers/user_provider.dart';
import 'package:salt/services/post.dart';
import 'package:salt/utils/post_editor.dart';
import 'package:salt/widgets/common/alert.dart';
import 'package:salt/widgets/common/buttons.dart';
import 'package:salt/widgets/drawer/animated_drawer.dart';
import 'package:salt/widgets/post_editor/form.dart';
import 'package:salt/widgets/post_editor/selected_tags.dart';
import 'package:salt/widgets/post_editor/tag_dropdown.dart';

import '../design_system.dart';

class CreatePostScreen extends StatelessWidget {
  const CreatePostScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PostEditorProvider(),
      child: const AnimatedDrawer(
        child: _ListView(),
        bottomNavIdx: 2,
      ),
    );
  }
}

class _ListView extends StatefulWidget {
  const _ListView({Key? key}) : super(key: key);

  @override
  __ListViewState createState() => __ListViewState();
}

class __ListViewState extends State<_ListView> {
  final ScrollController _ctrl = ScrollController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      _ctrl.addListener(() {
        var pixels = _ctrl.position.pixels;
        if (pixels >= 0) {
          /// Listview has be scrolled (when == 0 you're at top)
          Provider.of<AnimatedDrawerProvider>(
            context,
            listen: false,
          ).animateAppBar(pixels);
        }
      });
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _ctrl,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          const SizedBox(height: 20),
          TitleInputField(),
          const SizedBox(height: 20),
          DescriptionInputField(),
          const SizedBox(height: 20),
          const TagDropDown(),
          const SizedBox(height: 10),
          const SelectedTags(),
          const SizedBox(height: 20),
          const CoverImgViewer(),
          const SizedBox(height: 20),
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
          const SizedBox(height: 20),
          const ContentViewer(),
          const SizedBox(height: 20),
          const PublishPost(),
          const SizedBox(height: 40),
          _SaveButton(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

/// Publish
class PublishPost extends StatelessWidget {
  const PublishPost({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _p = Provider.of<PostEditorProvider>(context);

    return SizedBox(
      height: 50,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Transform.scale(
            scale: 1.2,
            child: Theme(
              data: ThemeData(unselectedWidgetColor: DesignSystem.secondary),
              child: Checkbox(
                checkColor: Colors.white,
                onChanged: (value) => _p.setPublished(value ?? false),
                activeColor: DesignSystem.success,
                value: _p.published,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
          ),
          const SizedBox(width: 6),
          Text('Publish', style: DesignSystem.medium)
        ],
      ),
    );
  }
}

/// Content view
class ContentViewer extends StatelessWidget {
  const ContentViewer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _p = Provider.of<PostEditorProvider>(context);

    if (_p.preview) {
      return Markdown(
        padding: const EdgeInsets.all(0),
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        data: _p.content,
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

/// Cover image viewer
class CoverImgViewer extends StatelessWidget {
  const CoverImgViewer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _p = Provider.of<PostEditorProvider>(context);

    if (_p.coverImg.isEmpty) {
      return Container(
        height: 250,
        decoration: BoxDecoration(
          color: DesignSystem.card,
          borderRadius: BorderRadius.circular(20),
        ),
      );
    }
    return Container(
      height: 250,
      decoration: BoxDecoration(
        color: DesignSystem.card,
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          image: Image.file(File(_p.coverImg[0].path)).image,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class CoverImagePickerButton extends StatelessWidget {
  final ImagePicker _picker = ImagePicker();
  CoverImagePickerButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _p = Provider.of<PostEditorProvider>(context);

    return Expanded(
      child: SecondaryButton(
        onPressed: () async {
          try {
            final pickedFile = await _picker.pickImage(
              source: ImageSource.gallery,
            );

            if (pickedFile != null) _p.setCoverImg(pickedFile);
          } catch (e) {
            failedSnackBar(
              context: context,
              msg: 'Something went wrong, Please try again',
            );
          }
        },
        text: 'Cover Image',
      ),
    );
  }
}

class PreviewContentButton extends StatelessWidget {
  const PreviewContentButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _p = Provider.of<PostEditorProvider>(context);

    return Expanded(
      child: SecondaryButton(
        onPressed: () => _p.setPreview(_p.preview ? false : true),
        text: _p.preview ? 'Edit' : 'Preview',
      ),
    );
  }
}

class _SaveButton extends StatelessWidget {
  final _service = PostService();
  _SaveButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _p = Provider.of<PostEditorProvider>(context);
    final _user = Provider.of<UserProvider>(context);

    return PrimaryButton(
      horizontalPadding: 100,
      onPressed: () async {
        if (_user.token == null) {
          failedSnackBar(
            context: context,
            msg: 'You must be logged in to do that',
          );
          return;
        }

        if (_p.coverImg.isEmpty) {
          failedSnackBar(context: context, msg: 'Add cover image');
          return;
        }

        final post = CreatePost(
          title: _p.title,
          description: _p.description,
          content: _p.content,
          tags: _p.getSelectsTagsIds(),
          coverImg: _p.coverImg[0],
          published: _p.published,
        );

        _p.setLoading(true);
        var response = await _service.savePost(
          post,
          _user.user?.id ?? '',
          _user.token ?? '',
        );
        _p.setLoading(false);

        if (response['error']) {
          failedSnackBar(context: context, msg: response['msg']);
        } else {
          // TODO: Move to post screen
          successSnackBar(context: context, msg: response['msg']);
        }
      },
      text: _p.loading ? 'Saving...' : 'Save',
    );
  }
}
