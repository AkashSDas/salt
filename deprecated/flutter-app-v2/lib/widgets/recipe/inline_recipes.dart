import 'package:flutter/material.dart';
import 'package:salt/design_system.dart';
import 'package:salt/models/recipe/recipe.dart';
import 'package:salt/services/recipe.dart';
import 'package:salt/widgets/headers/index.dart';
import 'package:shimmer/shimmer.dart';

class InlineRecipes extends StatefulWidget {
  const InlineRecipes({Key? key}) : super(key: key);

  @override
  State<InlineRecipes> createState() => _State();
}

class _State extends State<InlineRecipes> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final RecipeService _service = RecipeService();

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return FutureBuilder(
      future: _service.getPaginated(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const _Loader();
        } else if (_service.error) {
          return const _Loader();
        }

        List<Recipe> recipes = snapshot.data as List<Recipe>;
        return _BodyWrapper(
          child: SizedBox(
            height: 204,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: recipes.length,
              itemBuilder: (context, idx) => _ListItem(
                key: Key(idx.toString()),
                recipe: recipes[idx],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ListItem extends StatelessWidget {
  final Recipe recipe;
  const _ListItem({required this.recipe, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 179,
      height: 204,
      margin: const EdgeInsets.only(right: 24),
      child: Stack(
        children: [
          /// Image
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                image: NetworkImage(recipe.coverImgURL),
                fit: BoxFit.cover,
              ),
            ),
          ),

          /// Mask
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [Colors.black, Colors.transparent],
              ),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              alignment: Alignment.bottomLeft,

              /// Title
              child: Text(
                // clampText(recipe.title),
                recipe.title,
                style: DesignSystem.bodyMain.copyWith(
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          )
        ],
      ),
    );
  }

  String clampText(String text) {
    int upto = 35;
    if (text.length > upto) return text.substring(0, upto) + '...';
    return text;
  }
}

class _BodyWrapper extends StatelessWidget {
  final Widget child;
  const _BodyWrapper({required this.child, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 204 + 16 + 28, // card height + space + font size
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Heading(title: 'Trending Recipes'),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

class _Loader extends StatelessWidget {
  const _Loader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _BodyWrapper(
      child: SizedBox(
        height: 204,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 8,
          itemBuilder: (context, idx) {
            return Shimmer.fromColors(
              key: Key(idx.toString()),
              child: Container(
                width: 179,
                height: 204,
                margin: const EdgeInsets.only(right: 24),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(32),
                ),
              ),
              baseColor: DesignSystem.gallery,
              highlightColor: DesignSystem.alabaster,
            );
          },
        ),
      ),
    );
  }
}
