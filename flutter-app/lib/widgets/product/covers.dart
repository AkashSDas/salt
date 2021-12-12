import 'package:flutter/material.dart';
// import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

/// There is a [RenderFlex] overflowed by 5.0 pixels on the right error
class GroceriesCovers extends StatelessWidget {
  const GroceriesCovers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          SizedBox(
            height: 284 + 8,
            child: Column(
              children: [
                GroceriesCoverImage(
                  imgPath: 'dairy-products',
                  width: MediaQuery.of(context).size.width * 0.5 - 16 - 3,
                  height: 138,
                ),
                const SizedBox(height: 8),
                GroceriesCoverImage(
                  imgPath: 'fresh-fruities',
                  width: MediaQuery.of(context).size.width * 0.5 - 16 - 3,
                  height: 138,
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          GroceriesCoverImage(
            imgPath: 'fresh-veggies',
            width: MediaQuery.of(context).size.width * 0.5 - 16 - 3,
            height: 284,
          ),
        ],
      ),
    );
  }
}

class GroceriesCoverImage extends StatelessWidget {
  final String imgPath;
  final double width;
  final double height;

  const GroceriesCoverImage({
    required this.imgPath,
    required this.width,
    required this.height,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(32),
        image: DecorationImage(
          image: AssetImage('assets/images/$imgPath.png'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

/// In [GroceriesCovers], instead of [Row] the below code grid view can be used.
/// The only issue it faces is the image height (cover/contain) issue. This won't
/// solve the [RenderFlex] overflowed error on [GroceriesCovers]
//
// StaggeredGridView.countBuilder(
//         shrinkWrap: true,
//         physics: const NeverScrollableScrollPhysics(),
//         crossAxisCount: 2,
//         itemCount: 3,
//         itemBuilder: (context, idx) {
//           double height = 138;
//           if (idx == 1) height = 284;
//           const imgs = ['dairy-products', 'fresh-veggies', 'fresh-fruities'];
//           return GroceriesCoverImage(
//             imgPath: imgs[idx],
//             width: 178,
//             height: height,
//           );
//         },
//         staggeredTileBuilder: (idx) {
//           return StaggeredTile.count(1, idx == 1 ? 2 : 1);
//         },
//         mainAxisSpacing: 8,
//         crossAxisSpacing: 8,
//       ),
