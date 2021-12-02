import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salt/designs/designs.dart';
import 'package:salt/providers/blog-post-editor.dart';

class UpdateBlogPostEditorCoverImageViewer extends StatelessWidget {
  final String coverImgURL;

  const UpdateBlogPostEditorCoverImageViewer({
    required this.coverImgURL,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BlogPostEditorFormProvider _provider =
        Provider.of<BlogPostEditorFormProvider>(context);

    return Container(
      height: 160,
      decoration: BoxDecoration(
        color: DesignSystem.grey2,
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: _provider.coverImgFile.length > 0
              ? Image.file(File(_provider.coverImgFile[0].path)).image
              : NetworkImage(coverImgURL),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
