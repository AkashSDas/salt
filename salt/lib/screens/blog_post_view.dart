import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:provider/provider.dart';
import 'package:salt/design_system.dart';
import 'package:salt/models/blog_post/blog_post.dart';
import 'package:salt/providers/animated_drawer.dart';
import 'package:salt/widgets/animated_drawer/animated_drawer.dart';
import 'package:salt/widgets/food_category/inline_food_category_tags.dart';

class BlogPostViewScreen extends StatelessWidget {
  final BlogPost post;
  const BlogPostViewScreen({required this.post, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _Warpper(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: _Body(post: post),
      ),
    );
  }
}

class _Warpper extends StatelessWidget {
  final Widget child;
  const _Warpper({required this.child, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedDrawer(body: child, tag: 'blog-post-view-screen');
  }
}

class _Body extends StatefulWidget {
  final BlogPost post;
  const _Body({required this.post, Key? key}) : super(key: key);

  @override
  __BodyState createState() => __BodyState();
}

class __BodyState extends State<_Body> {
  final ScrollController _ctrl = ScrollController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      /// Scroll event for fetching more posts
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

  Widget _buildSpace() => const SizedBox(height: 32);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _ctrl,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.post.title, style: DesignSystem.heading1),
          _buildSpace(),
          Text(widget.post.description, style: DesignSystem.bodyIntro),
          _buildSpace(),
          InlineFoodCategoryTags(categories: widget.post.categories),
          _buildSpace(),
          _CoverImg(imgURL: widget.post.coverImgURL),
          _buildSpace(),
          _Content(content: widget.post.content),
        ],
      ),
    );
  }
}

class _CoverImg extends StatelessWidget {
  final String imgURL;
  const _CoverImg({required this.imgURL, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      decoration: BoxDecoration(
        color: DesignSystem.gallery,
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(image: NetworkImage(imgURL), fit: BoxFit.cover),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  final String content;
  const _Content({required this.content, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Markdown(
      // selectable: true,
      padding: const EdgeInsets.all(0),

      /// Below 2 properties are needed for having only the parent
      /// scrollable widget (ListView here to scroll) and the child
      /// scrollable widget to take its height as content height and
      /// not scroll separately
      ///
      /// This is a great working solution when you have 2 unbounded
      /// widgets (one parent and the other as child). Because here
      /// you've to wrap child with either Container, SizedBox or some
      /// widget with constraint in height propert (height: 300), so
      /// the child scrollable widget will now have a height of 300px
      /// but What if you want to display the entire content and not
      /// just 300px of it? For this add the below 2 lines in your child
      /// scrollable whidget
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),

      data: '**${content[0].toUpperCase()}**${content.substring(1)}',
      styleSheet: MarkdownStyleSheet(
        h1: DesignSystem.heading1,
        h2: DesignSystem.heading2,
        h3: DesignSystem.heading3,
        h4: DesignSystem.heading4,
        p: DesignSystem.bodyIntro,
      ),
    );
  }
}
