import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salt/providers/blog-post-editor.dart';
import 'package:salt/providers/user.dart';
import 'package:salt/services/blog-post.dart';
import 'package:salt/widgets/common/btns.dart';
import 'package:salt/widgets/common/snackbar.dart';

class BlogPostEditorSaveButton extends StatefulWidget {
  const BlogPostEditorSaveButton({Key? key}) : super(key: key);

  @override
  State<BlogPostEditorSaveButton> createState() =>
      _BlogPostEditorSaveButtonState();
}

class _BlogPostEditorSaveButtonState extends State<BlogPostEditorSaveButton>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    UserProvider _user = Provider.of<UserProvider>(context);
    BlogPostEditorFormProvider _provider =
        Provider.of<BlogPostEditorFormProvider>(context);

    return ExpandedButton(
      text: _provider.saveLoading ? 'Loading...' : 'Save',
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
        } else if (_provider.coverImgFile.length > 0) {
          NewBlogPost post = NewBlogPost(
            title: _provider.title,
            description: _provider.description,
            content: _provider.content,
            categories: _provider.getAllTagIds(),
            authorId: _user.user!.id,
            coverImg: _provider.coverImgFile[0],
          );

          print('saving started ${_provider.getAllTagIds()}');
          var res = await saveBlogPost(post, _user.token.toString());
          print('saving done');
          if (res[1] != null)
            failedSnackBar(
              context: context,
              msg: 'Something went wrong, Please try again',
            );
          else if (res[0]['error'])
            failedSnackBar(
              context: context,
              msg: res[0]['message'],
            );
          else
            successSnackBar(
              context: context,
              msg: 'Successfully created post',
            );
        }
      },
    );
  }
}
