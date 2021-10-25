import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:salt/providers/blog_post_editor.dart';
import 'package:salt/providers/user.dart';
import 'package:salt/utils/blog_post_editor.dart';
import 'package:salt/widgets/alerts/index.dart';
import 'package:salt/widgets/buttons/index.dart';

class CoverImagePickerButton extends StatelessWidget {
  final ImagePicker _picker = ImagePicker();
  CoverImagePickerButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BlogPostEditorCreateProvider _p = Provider.of<BlogPostEditorCreateProvider>(
      context,
    );

    return Expanded(
      child: RoundedCornerIconButton(
        onPressed: () async {
          try {
            final pickedFile = await _picker.pickImage(
              source: ImageSource.gallery,
            );

            if (pickedFile != null) _p.updateCoverImg(pickedFile);
          } catch (e) {
            failedSnackBar(
              context: context,
              msg: 'Something went wrong, Please try again',
            );
          }
        },
        text: 'Cover Image',
        icon: const AspectRatio(
          aspectRatio: 1,
          child: FlareActor(
            'assets/flare-icons/image.flr',
            alignment: Alignment.center,
            fit: BoxFit.contain,
            animation: 'idle',
          ),
        ),
      ),
    );
  }
}

class PreviewContentButton extends StatelessWidget {
  const PreviewContentButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BlogPostEditorCreateProvider _p = Provider.of<BlogPostEditorCreateProvider>(
      context,
    );

    return Expanded(
      child: RoundedCornerIconButton(
        onPressed: () {
          _p.togglePreviewContent();
        },
        text: _p.previewContent ? 'Edit' : 'Preview',
        icon: AspectRatio(
          aspectRatio: 1,
          child: FlareActor(
            _p.previewContent
                ? 'assets/flare-icons/hide.flr'
                : 'assets/flare-icons/show.flr',
            alignment: Alignment.center,
            fit: BoxFit.contain,
            animation: 'idle',
          ),
        ),
      ),
    );
  }
}

class SaveButton extends StatelessWidget {
  const SaveButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BlogPostEditorCreateProvider _p = Provider.of<BlogPostEditorCreateProvider>(
      context,
    );
    UserProvider _user = Provider.of<UserProvider>(context);

    return RoundedCornerButton(
      onPressed: () async {
        if (_user.token == null) {
          failedSnackBar(
            context: context,
            msg: 'You must be logged in to do that',
          );
          return;
        }

        if (_p.coverImgFile.isEmpty) {
          failedSnackBar(context: context, msg: 'Add cover image');
          return;
        }

        CreateBlogPost post = CreateBlogPost(
          title: _p.title,
          description: _p.description,
          content: _p.content,
          categories: _p.getAllTagIds(),
          authorId: _user.user!.id,
          coverImg: _p.coverImgFile[0],
        );

        var savedPost = await _p.saveBlogPost(
          context,
          post,
          _user.token.toString(),
        );

        if (savedPost != null) {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => BlogPostViewScreen(post: savedPost),
          //   ),
          // );
        } else {
          Navigator.pop(context);
        }
      },
      text: _p.saveLoading ? 'Loading...' : 'Save',
    );
  }
}
