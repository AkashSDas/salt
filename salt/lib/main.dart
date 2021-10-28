import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:salt/design_system.dart';
import 'package:salt/providers/cart.dart';
import 'package:salt/providers/user.dart';
import 'package:salt/screens/blog_post_create_editor.dart';
import 'package:salt/screens/blog_posts.dart';
import 'package:salt/screens/cart.dart';
import 'package:salt/screens/home.dart';
import 'package:salt/screens/login.dart';
import 'package:salt/screens/products.dart';
import 'package:salt/screens/recipe_create_editor.dart';
import 'package:salt/screens/recipes.dart';
import 'package:salt/screens/settings.dart';
import 'package:salt/screens/signup.dart';
import 'package:salt/screens/user_blog_posts.dart';
import 'package:salt/screens/user_recipes.dart';
import 'package:salt/widgets/animated_drawer/animated_drawer.dart';
import 'package:salt/widgets/blog_post/blog_posts_listview_utils.dart';
import 'package:salt/widgets/product/products_listview_utils.dart';
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
                child: AnimatedDrawer(body: HomeScreen()),
              ),
          '/blog-posts': (context) => const BlogPostsInfiniteScrollWrapper(
                child: AnimatedDrawer(body: BlogPostsScreen()),
              ),
          '/recipes': (context) => const RecipesInfiniteScrollWrapper(
                child: AnimatedDrawer(body: RecipesScreen()),
              ),
          '/auth/signup': (context) => AnimatedDrawer(body: SignUpScreen()),
          '/auth/login': (context) => AnimatedDrawer(body: LoginScreen()),
          '/blog-post/create': (context) => const AnimatedDrawer(
                body: BlogPostCreateEditorScreen(),
              ),
          '/settings': (context) => const AnimatedDrawer(
                body: SettingsScreen(),
              ),
          '/blog-posts/user': (context) => const BlogPostsInfiniteScrollWrapper(
                child: AnimatedDrawer(body: UserBlogPostsScreen()),
              ),
          '/recipe/create': (context) => const AnimatedDrawer(
                body: RecipeCreateEditorScreen(),
              ),
          '/recipes/user': (context) => const RecipesInfiniteScrollWrapper(
                child: AnimatedDrawer(body: UserRecipesScreen()),
              ),
          '/products': (context) => const ProductsInfiniteScrollWrapper(
                child: AnimatedDrawer(body: ProductsScreen()),
              ),
          '/cart': (context) => ChangeNotifierProvider(
                create: (context) => UserCartProvider(),
                child: const AnimatedDrawer(body: CartScreen()),
              ),
        },
      ),
    );
  }
}
