import 'package:flutter/material.dart';
import 'package:salt/services/receipes.dart';
import 'package:salt/widgets/blog-post/blog-post-list-item-loader.dart';
import 'package:salt/widgets/common/bottom-nav.dart';
import 'package:salt/widgets/recipes/card.dart';

class RecipesScreen extends StatefulWidget {
  const RecipesScreen({Key? key}) : super(key: key);

  @override
  _RecipesScreenState createState() => _RecipesScreenState();
}

class _RecipesScreenState extends State<RecipesScreen> {
  final ScrollController _ctrl = ScrollController();

  List<dynamic> recipes = [];
  bool loading = false;
  bool reachedEnd = false;
  bool firstLoading = false;
  bool hasNext = false;
  String nextId = '';

  @override
  void initState() {
    super.initState();
    _fetch();
    _ctrl.addListener(() {
      if (_ctrl.position.pixels >= _ctrl.position.maxScrollExtent &&
          !loading &&
          !reachedEnd) {
        _fetchMore();
      }
    });
  }

  Future<void> _fetch() async {
    setState(() {
      firstLoading = true;
    });

    var data = await getAllRecipesPaginated(limit: 10);
    List<dynamic> newRecipes = data[0]['data']['recipes'];
    setState(() {
      recipes = [...recipes, ...newRecipes];
      firstLoading = false;
      hasNext = data[0]['data']['hasNext'];
      nextId = data[0]['data']['next'];
    });

    if (hasNext == false)
      setState(() {
        reachedEnd = true;
      });
  }

  Future<void> _fetchMore() async {
    setState(() {
      loading = true;
    });

    var data = await getAllRecipesPaginated(
      limit: 10,
      hasNext: hasNext,
      nextId: nextId,
    );
    List<dynamic> newRecipes = data[0]['data']['recipes'];
    setState(() {
      recipes = [...recipes, ...newRecipes];
      loading = false;
      hasNext = data[0]['data']['hasNext'];
      nextId = data[0]['data']['next'];
    });

    if (hasNext == false)
      setState(() {
        reachedEnd = true;
      });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        bottomNavigationBar: AppBottomNav(currentIndex: 1),
        body: Container(
          clipBehavior: Clip.antiAlias,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(color: Theme.of(context).primaryColor),
          child: _buildBody(),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (firstLoading) return BlogPostListItemLoader();
    return ListView(
      clipBehavior: Clip.none,
      controller: _ctrl,
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          itemCount: recipes.length,
          itemBuilder: (context, idx) => RecipeCard(
            recipe: recipes[idx],
          ),
        ),
        SizedBox(height: 16),
        _buildTheEnd(),
      ],
    );
  }

  Widget _buildTheEnd() {
    if (reachedEnd) return Text("You've reached the end");
    if (loading)
      return Container(child: Center(child: CircularProgressIndicator()));
    return SizedBox(height: 32);
  }
}
