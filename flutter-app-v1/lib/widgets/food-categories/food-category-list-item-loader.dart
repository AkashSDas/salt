import 'package:flutter/material.dart';
import 'package:salt/designs/designs.dart';
import 'package:shimmer/shimmer.dart';

class FoodCategoryListItemLoader extends StatelessWidget {
  const FoodCategoryListItemLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 94,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 10,
        itemBuilder: (context, idx) => Shimmer.fromColors(
          key: Key(idx.toString()),
          child: Container(
            height: 94,
            width: 58,
            margin: EdgeInsets.only(right: 24),
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(32),
            ),
          ),
          baseColor: DesignSystem.grey2,
          highlightColor: DesignSystem.grey1,
        ),
      ),
    );
  }
}
