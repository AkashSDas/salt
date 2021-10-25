import 'package:flutter/material.dart';
import 'package:salt/design_system.dart';
import 'package:salt/models/food_category/food_category.dart';

class InlineFoodCategoryTags extends StatelessWidget {
  final List<FoodCategory> categories;

  const InlineFoodCategoryTags({
    required this.categories,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: List.generate(
        categories.length,
        (index) => Container(
          height: 44,
          padding: const EdgeInsets.only(top: 6, bottom: 6, left: 8, right: 16),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xffBDBDBD), width: 0.5),
            borderRadius: BorderRadius.circular(21),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 36,
                width: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      offset: const Offset(0, 0),
                      blurRadius: 4,
                      color: Colors.black.withOpacity(0.15),
                    ),
                  ],
                  color: Theme.of(context).primaryColor,
                ),
                child: Center(child: Text(categories[index].emoji)),
              ),
              const SizedBox(width: 8),
              Text(
                categories[index].name,
                style: DesignSystem.caption,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
