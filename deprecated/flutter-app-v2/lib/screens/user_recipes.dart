import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salt/design_system.dart';
import 'package:salt/providers/animated_drawer.dart';
import 'package:salt/providers/recipes_infinite_scroll.dart';
import 'package:salt/providers/user.dart';
import 'package:salt/widgets/buttons/index.dart';
import 'package:salt/widgets/recipe/recipes_listview_utils.dart';
import 'package:salt/widgets/recipe/user_recipes_listview.dart';

class UserRecipesScreen extends StatefulWidget {
  const UserRecipesScreen({Key? key}) : super(key: key);

  @override
  _UserRecipesScreenState createState() => _UserRecipesScreenState();
}

class _UserRecipesScreenState extends State<UserRecipesScreen> {
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
      Provider.of<RecipesInfiniteScrollProvider>(
        context,
        listen: false,
      ).initialFetchForLoggedInUser(
        Provider.of<UserProvider>(context, listen: false).user!.id.toString(),
        Provider.of<UserProvider>(context, listen: false).token.toString(),
      );

      /// Scroll event for fetching more recipes
      _ctrl.addListener(() {
        var loading = Provider.of<RecipesInfiniteScrollProvider>(
          context,
          listen: false,
        ).loading;

        var reachedEnd = Provider.of<RecipesInfiniteScrollProvider>(
          context,
          listen: false,
        ).reachedEnd;

        var pixels = _ctrl.position.pixels;
        var maxScrollExtent = _ctrl.position.maxScrollExtent;

        if (pixels >= maxScrollExtent && !loading && !reachedEnd) {
          /// fetch more
          Provider.of<RecipesInfiniteScrollProvider>(
            context,
            listen: false,
          ).fetchMoreForLoggedInUser(
            Provider.of<UserProvider>(context, listen: false)
                .user!
                .id
                .toString(),
            Provider.of<UserProvider>(context, listen: false).token.toString(),
          );
        }

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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: ListView(
        controller: _ctrl,
        clipBehavior: Clip.none,
        children: [
          Text(
            'All your recipes',
            style: DesignSystem.heading2,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 72),
            child: RoundedCornerButton(
              onPressed: () => Navigator.pushNamed(context, '/recipe/create'),
              text: 'Create',
            ),
          ),
          const SizedBox(height: 32),
          const UserRecipesListView(),
          const RecipesListViewEnd(),
        ],
      ),
    );
  }
}
