import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:salt/screens/tag_products.dart';
import 'package:salt/utils/tags.dart';

class GroceriesCovers extends StatelessWidget {
  const GroceriesCovers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: StaggeredGridView.countBuilder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        itemCount: 3,
        itemBuilder: (context, idx) {
          double height = 138;
          if (idx == 1) height = 284;
          const imgs = ['dairy-products', 'fresh-veggies', 'fresh-fruities'];
          const names = ['dairy', 'veggies', 'fruits'];
          const ids = [
            TagMongoDBIds.dairy,
            TagMongoDBIds.greenVeggies,
            TagMongoDBIds.fruits,
          ];
          return GroceriesCoverImage(
            imgPath: imgs[idx],
            width: 178,
            height: height,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TagProductsScreen(
                    tagId: ids[idx],
                    tagName: names[idx],
                  ),
                ),
              );
            },
          );
        },
        staggeredTileBuilder: (idx) {
          /// StaggeredTile.count(x, x*h/w)
          return StaggeredTile.count(1, idx == 1 ? 284 / 178 : 138 / 178);
        },
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
    );
  }
}

class GroceriesCoverImage extends StatelessWidget {
  final String imgPath;
  final double width;
  final double height;
  final void Function()? onTap;

  const GroceriesCoverImage({
    this.onTap,
    required this.imgPath,
    required this.width,
    required this.height,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(32),
          image: DecorationImage(
            image: AssetImage('assets/images/$imgPath.png'),
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
