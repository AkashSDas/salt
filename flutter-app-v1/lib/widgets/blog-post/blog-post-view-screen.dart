import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:salt/designs/designs.dart';
import 'package:salt/models/blog-post/blog-post.dart';
import 'package:salt/widgets/food-categories/food-category-tags.dart';

class BlogPostViewScreen extends StatelessWidget {
  final BlogPost post;
  const BlogPostViewScreen({required this.post, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: Padding(padding: EdgeInsets.all(16), child: _buildBody()),
      ),
    );
  }

  Widget _buildBody() {
    return Builder(
      builder: (context) {
        var _title = Text(
          post.title,
          style: Theme.of(context).textTheme.headline2,
        );

        var _description = Text(
          post.description,
          style: Theme.of(context).textTheme.bodyText1,
        );

        return ListView(
          children: [
            _title,
            _buildSpace(),
            _description,
            _buildSpace(),
            _buildCoverImg(),
            _buildSpace(),
            FoodCategoryTags(categories: post.categories),
            _buildSpace(),
            _buildPostMarkdownView(),
          ],
        );
      },
    );
  }

  Widget _buildPostMarkdownView() {
    return Builder(builder: (context) {
      return Markdown(
        // selectable: true,
        padding: EdgeInsets.all(0),

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
        physics: ClampingScrollPhysics(),

        data: post.content,
        styleSheet: MarkdownStyleSheet(
          h2: Theme.of(context).textTheme.headline2,
          p: Theme.of(context).textTheme.bodyText2,
        ),
      );
    });
  }

  Widget _buildCoverImg() {
    return Container(
      height: 220,
      decoration: BoxDecoration(
        color: DesignSystem.grey1,
        image: DecorationImage(
          image: NetworkImage(post.coverImgURL),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  Widget _buildSpace() => SizedBox(height: 16);
}
