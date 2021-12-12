import 'package:flutter/material.dart';

class GroceriesCovers extends StatelessWidget {
  const GroceriesCovers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
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
