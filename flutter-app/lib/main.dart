import 'package:flare_splash_screen/flare_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:salt/designs/designs.dart';
import 'package:salt/providers/user.dart';
import 'package:salt/screens/auth.dart';
import 'package:salt/screens/blog-post-editor.dart';
import 'package:salt/screens/blog-posts.dart';
import 'package:salt/screens/cart.dart';
import 'package:salt/screens/home.dart';
import 'package:salt/screens/products.dart';
import 'package:salt/screens/recipes.dart';
import 'package:salt/screens/settings.dart';
import 'package:salt/screens/user-blog-post-screen.dart';

/// Run app
Future<void> main() async {
  /// Loading env variables
  await dotenv.load(fileName: '.env');

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => UserProvider()),
        ],
        child: MaterialApp(
          title: 'Salt',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: DesignSystem.grey0,
            accentColor: DesignSystem.orange,
            textTheme: DesignSystem.textTheme,
          ),
          routes: _getRoutes(context),
        ),
      );

  Map<String, Widget Function(BuildContext)> _getRoutes(BuildContext context) {
    return {
      '/': (context) => SplashScreen.navigate(
            height: 90,
            width: 90,
            name: 'assets/flare/logo.flr',
            next: (context) => HomeScreen(),
            until: () => Future.delayed(Duration(seconds: 3)),
            startAnimation: 'idle',
            backgroundColor: Theme.of(context).primaryColor,
          ),

      /// Home screen without splash screen
      '/home': (context) => HomeScreen(),

      '/auth': (context) => AuthScreen(),
      '/blog-posts': (context) => BlogPostsScreen(),
      '/settings': (context) => SettingsScreen(),
      '/recipes': (context) => RecipesScreen(),
      '/blog-post/create': (context) => BlogPostEditorScreen(),
      '/blog-posts/user': (context) => UserBlogPostsScreen(),
      '/products': (context) => ProductsScreen(),
      '/cart': (context) => CartScreen(),
    };
  }
}
