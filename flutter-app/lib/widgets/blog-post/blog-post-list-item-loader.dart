import 'package:flutter/material.dart';
import 'package:salt/designs/designs.dart';
import 'package:shimmer/shimmer.dart';

class BlogPostListLoader extends StatelessWidget {
  const BlogPostListLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 3,
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      itemBuilder: (_, idx) {
        return Shimmer.fromColors(
          key: Key(idx.toString()),
          child: Container(
            height: 271,
            margin: EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(32),
            ),
          ),
          baseColor: DesignSystem.grey2,
          highlightColor: DesignSystem.grey1,
        );
      },
    );
  }
}
