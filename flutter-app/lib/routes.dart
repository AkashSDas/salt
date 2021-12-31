import 'package:flutter/material.dart';
import 'package:salt/screens/app_splash_screen.dart';
import 'package:salt/screens/checkout.dart';
import 'package:salt/screens/create_post.dart';
import 'package:salt/screens/login.dart';
import 'package:salt/screens/posts.dart';
import 'package:salt/screens/products.dart';
import 'package:salt/screens/recipes_screen.dart';
import 'package:salt/screens/search_screen.dart';
import 'package:salt/screens/settings.dart';
import 'package:salt/screens/signup.dart';
import 'package:salt/screens/user_cart.dart';
import 'package:salt/screens/user_payments.dart';
import 'package:salt/screens/user_posts.dart';
import 'package:salt/screens/user_product_orders.dart';

Map<String, Widget Function(BuildContext)> getRoutes(BuildContext context) {
  return {
    '/': (context) => const AppSplashScreen(),
    '/auth/signup': (context) => const SignupScreen(),
    '/auth/login': (context) => const LoginScreen(),
    '/user/cart': (context) => const UserCartScreen(),
    '/user/checkout': (context) => const CheckoutScreen(),
    '/products': (context) => const ProductsScreen(),
    '/settings': (context) => const SettingsScreen(),
    '/user/payment': (context) => const UserPaymentsScreen(),
    '/user/post/create': (context) => const CreatePostScreen(),
    '/posts': (context) => const PostsScreen(),
    '/recipes': (context) => RecipesScreen(),
    '/user/posts': (context) => const UserPostsScreen(),
    '/user/product-orders': (context) => const UserProductOrdersScreen(),
    '/search': (context) => const SearchScreen(),
  };
}
