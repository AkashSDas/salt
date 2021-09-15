import 'package:flutter/material.dart';
import 'package:salt/designs/designs.dart';
import 'package:salt/services/blog-post.dart';
import 'package:salt/widgets/food-categories/food-category-list-item-loader.dart';

class BlogPostList extends StatefulWidget {
  const BlogPostList({Key? key}) : super(key: key);

  @override
  _BlogPostListState createState() => _BlogPostListState();
}

class _BlogPostListState extends State<BlogPostList> {
  late Future<dynamic> _getAllBlogPosts;

  @override
  void initState() {
    super.initState();
    _getAllBlogPosts = getAllBlogPostsPaginated(limit: 10);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getAllBlogPosts,
      builder: (context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) return FoodCategoryListItemLoader();

        var error = snapshot.data[1];
        var data = snapshot.data[0];

        if (error != null || data['error']) return FoodCategoryListItemLoader();

        List<dynamic> posts = data['data']['posts'];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...posts
                .map(
                  (post) => Container(
                    color: Theme.of(context).primaryColor,
                    margin: EdgeInsets.only(bottom: 16),
                    child: Column(
                      children: [
                        Container(
                          height: 16 * 10,
                          decoration: BoxDecoration(
                            color: DesignSystem.grey1,
                            image: DecorationImage(
                              image: NetworkImage(post.coverImgURL),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          post.title,
                          style:
                              Theme.of(context).textTheme.bodyText1?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: Theme.of(context)
                                        .textTheme
                                        .headline1
                                        ?.color,
                                  ),
                          textAlign: TextAlign.left,
                        ),
                        Row(
                          children: [
                            Container(
                              height: 38,
                              width: 38,
                              margin: EdgeInsets.only(right: 8),
                              decoration: BoxDecoration(
                                color: DesignSystem.grey1,
                                borderRadius: BorderRadius.circular(12),
                                image: DecorationImage(
                                  image: NetworkImage(
                                    post.author.profilePicURL,
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Column(
                              children: [
                                Text(post.author.username),
                                Text(
                                  '${post.updatedAt} - ${post.readTime}min read',
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ],
        );
      },
    );
  }
}
