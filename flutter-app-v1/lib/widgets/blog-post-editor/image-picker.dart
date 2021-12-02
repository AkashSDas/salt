import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:salt/providers/blog-post-editor.dart';
import 'package:salt/widgets/common/btns.dart';

class BlogPostEditorImagePicker extends StatelessWidget {
  final ImagePicker _picker = ImagePicker();
  BlogPostEditorImagePicker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BlogPostEditorFormProvider _provider =
        Provider.of<BlogPostEditorFormProvider>(context);

    return ExpandedButton(
      text: 'Choose cover image',
      onPressed: () async {
        try {
          final pickedFile = await _picker.pickImage(
            source: ImageSource.gallery,
          );

          if (pickedFile != null) _provider.updateCoverImgFile(pickedFile);
        } catch (err) {}
      },
    );
  }
}
