import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salt/designs/designs.dart';
import 'package:salt/providers/blog-post-editor.dart';

class BlogPostEditorCoverImageViewer extends StatelessWidget {
  const BlogPostEditorCoverImageViewer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BlogPostEditorFormProvider _provider =
        Provider.of<BlogPostEditorFormProvider>(context);

    if (_provider.coverImgFile.length == 0) return SizedBox();

    return Container(
      height: 160,
      decoration: BoxDecoration(
        color: DesignSystem.grey2,
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: Image.file(File(_provider.coverImgFile[0].path)).image,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
