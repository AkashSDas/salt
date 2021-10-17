import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salt/providers/blog-post-editor.dart';
import 'package:salt/providers/user.dart';
import 'package:salt/services/auth.dart';
import 'package:salt/services/blog-post.dart';
import 'package:salt/widgets/common/btns.dart';
import 'package:salt/widgets/common/snackbar.dart';

class BlogPostEditorUpdateButton extends StatefulWidget {
  final String postId;
  const BlogPostEditorUpdateButton({required this.postId, Key? key})
      : super(key: key);

  @override
  State<BlogPostEditorUpdateButton> createState() =>
      _BlogPostEditorUpdateButtonState();
}

class _BlogPostEditorUpdateButtonState extends State<BlogPostEditorUpdateButton>
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
      text: _provider.saveLoading ? 'Loading...' : 'Update',
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
          UpdateBlogPost post;

          if (_provider.coverImgFile.isEmpty) {
            post = UpdateBlogPost(
              title: _provider.title,
              description: _provider.description,
              content: _provider.content,
              categories: _provider.getAllTagIds(),
              authorId: _user.user!.id,
            );
          } else {
            post = UpdateBlogPost(
              title: _provider.title,
              description: _provider.description,
              content: _provider.content,
              categories: _provider.getAllTagIds(),
              authorId: _user.user!.id,
              coverImg: _provider.coverImgFile[0],
            );
          }

          var user = await isAuthenticated();
          if (user == null) {
            displaySnackBar(
              context: context,
              success: false,
              msg: 'Not authenticated user',
            );
            return;
          }

          var res = await updateBlogPost(
            post,
            user['token'],
            widget.postId,
            user['user']['_id'],
          );

          if (res[1] != null)
            displaySnackBar(
              context: context,
              success: false,
              msg: 'Something went wrong, Please try again',
            );
          else if (res[0]['error'])
            displaySnackBar(
              context: context,
              success: false,
              msg: res[0]['message'],
            );
          else {
            /// TODO: after successful update, update the states in user
            /// blog post screen and also may be redirect user to updated post
            displaySnackBar(
              context: context,
              success: true,
              msg: 'Successfully updated the post',
            );
          }
        }
      },
    );
  }
}
