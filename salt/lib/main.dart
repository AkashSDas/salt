import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:salt/design_system.dart';
import 'package:salt/providers/user.dart';
import 'package:salt/screens/blog_post_create_editor.dart';
import 'package:salt/screens/blog_posts.dart';
import 'package:salt/screens/home.dart';
import 'package:salt/screens/login.dart';
import 'package:salt/screens/recipes.dart';
import 'package:salt/screens/signup.dart';
import 'package:salt/widgets/animated_drawer/animated_drawer.dart';
import 'package:salt/widgets/blog_post/blog_posts_listview_utils.dart';
import 'package:salt/widgets/recipe/recipes_listview_utils.dart';

void main() async {
  /// Loading env variables
  await dotenv.load(fileName: '.env');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserProvider(),
      child: MaterialApp(
        title: 'Salt',
        debugShowCheckedModeBanner: false,
        theme: DesignSystem.theme,
        routes: {
          '/': (context) => const BlogPostsInfiniteScrollWrapper(
                child: AnimatedDrawer(
                  body: HomeScreen(),
                  tag: 'home-screen',
                ),
              ),
          '/blog-posts': (context) => const BlogPostsInfiniteScrollWrapper(
                child: AnimatedDrawer(
                  body: BlogPostsScreen(),
                  tag: 'blog-posts-screen',
                ),
              ),
          '/recipes': (context) => const RecipesInfiniteScrollWrapper(
                child: AnimatedDrawer(
                  body: RecipesScreen(),
                  tag: 'recipes-screen',
                ),
              ),
          '/auth/signup': (context) => AnimatedDrawer(
                body: SignUpScreen(),
                tag: 'auth-signup-screen',
              ),
          '/auth/login': (context) => AnimatedDrawer(
                body: LoginScreen(),
                tag: 'auth-login-screen',
              ),
          '/blog-post/create': (context) => const AnimatedDrawer(
                body: BlogPostCreateEditorScreen(),
                tag: 'blog-post-create-screen',
              ),
        },
      ),
    );
  }
}
