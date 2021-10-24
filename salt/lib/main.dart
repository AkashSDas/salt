import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:salt/design_system.dart';
import 'package:salt/providers/user.dart';
import 'package:salt/screens/home.dart';
import 'package:salt/widgets/animated_drawer/animated_drawer.dart';
import 'package:salt/widgets/blog_post/blog_post_listview_utils.dart';

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
          '/': (context) => const BlogPostInfiniteScrollWrapper(
                child: AnimatedDrawer(body: HomeScreen()),
              ),
        },
      ),
    );
  }
}
