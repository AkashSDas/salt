import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:provider/provider.dart';
import 'package:salt/providers/blog-post-editor.dart';

class PreviewBlogPost extends StatelessWidget {
  const PreviewBlogPost({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BlogPostEditorProvider _provider = Provider.of<BlogPostEditorProvider>(
      context,
    );

    return Markdown(
      data: _provider.content,
      padding: EdgeInsets.all(0),
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      styleSheet: MarkdownStyleSheet(
        h1: Theme.of(context).textTheme.headline1,
        h2: Theme.of(context).textTheme.headline2,
        p: Theme.of(context).textTheme.bodyText2,
      ),
    );
  }
}
