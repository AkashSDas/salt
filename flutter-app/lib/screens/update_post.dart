import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salt/models/post/post.dart';
import 'package:salt/providers/animated_drawer.dart';
import 'package:salt/providers/post_editor.dart';
import 'package:salt/widgets/drawer/animated_drawer.dart';
import 'package:salt/widgets/post_editor/form.dart';
import 'package:salt/widgets/post_editor/selected_tags.dart';
import 'package:salt/widgets/post_editor/tag_dropdown.dart';

import '../design_system.dart';
import 'create_post.dart';

class UpdatePostScreen extends StatelessWidget {
  final Post post;
  const UpdatePostScreen({required this.post, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PostEditorProvider.fromPost(
        title: post.title,
        description: post.description,
        content: post.content,
        selectedTags: post.tags,
        published: post.published,
      ),
      child: AnimatedDrawer(child: _ListView(post: post), bottomNavIdx: 2),
    );
  }
}

class _ListView extends StatefulWidget {
  final Post post;
  const _ListView({required this.post, Key? key}) : super(key: key);

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
          const SelectedTagDropDown(),
          const SizedBox(height: 10),
          const SelectedTags(),
          const SizedBox(height: 20),
          _CoverImgViewer(coverImgURL: widget.post.coverImgURL),
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
          const SizedBox(height: 20),
        ],
      ),
    );
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
    final _p = Provider.of<PostEditorProvider>(context);

    return Container(
      height: 250,
      decoration: BoxDecoration(
        color: DesignSystem.card,
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          image: _p.coverImg.isNotEmpty
              ? Image.file(File(_p.coverImg[0].path)).image
              : NetworkImage(coverImgURL),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
