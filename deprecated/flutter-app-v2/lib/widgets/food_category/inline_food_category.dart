import 'package:flutter/material.dart';
import 'package:salt/design_system.dart';
import 'package:salt/models/food_category/food_category.dart';
import 'package:salt/services/food_category.dart';
import 'package:shimmer/shimmer.dart';

class InlineCategory extends StatefulWidget {
  const InlineCategory({Key? key}) : super(key: key);

  @override
  State<InlineCategory> createState() => _State();
}

class _State extends State<InlineCategory> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final FoodCategoryService _service = FoodCategoryService();

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return FutureBuilder(
      future: _service.getAll(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const _Loader();
        } else if (_service.error) {
          return const _Loader();
        }

        List<FoodCategory> categories = snapshot.data as List<FoodCategory>;
        return SizedBox(
          height: 94,
          child: ListView.builder(
            clipBehavior: Clip.none,
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, idx) => _ListItem(
              key: Key(idx.toString()),
              category: categories[idx],
            ),
          ),
        );
      },
    );
  }
}

class _ListItem extends StatelessWidget {
  final FoodCategory category;
  const _ListItem({required this.category, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 24),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: DesignSystem.boxShadow4,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Column(
        children: [
          Text(category.emoji, style: const TextStyle(fontSize: 30)),
          const SizedBox(height: 10),
          Text(
            '${category.name.toUpperCase()[0]}${category.name.substring(1)}',
            style: Theme.of(context).textTheme.caption?.copyWith(
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0,
                  color: Theme.of(context).iconTheme.color,
                  fontFamily: DesignSystem.fontBody,
                ),
          ),
        ],
      ),
    );
  }
}

class _Loader extends StatelessWidget {
  const _Loader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 94,
      child: ListView.builder(
          clipBehavior: Clip.none,
          scrollDirection: Axis.horizontal,
          itemCount: 8,
          itemBuilder: (context, idx) {
            return Shimmer.fromColors(
              key: Key(idx.toString()),
              child: Container(
                height: 94,
                width: 58,
                margin: const EdgeInsets.only(right: 24),
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 8,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(32),
                ),
              ),
              baseColor: DesignSystem.gallery,
              highlightColor: DesignSystem.alabaster,
            );
          }),
    );
  }
}
