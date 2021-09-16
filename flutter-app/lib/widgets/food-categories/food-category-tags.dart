import 'package:flutter/material.dart';
import 'package:salt/models/food-category/food-category.dart';

class FoodCategoryTags extends StatelessWidget {
  final List<FoodCategory> categories;
  const FoodCategoryTags({
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
          padding: EdgeInsets.only(top: 6, bottom: 6, left: 8, right: 16),
          decoration: BoxDecoration(
            border: Border.all(color: Color(0xffBDBDBD), width: 0.5),
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
                      offset: Offset(0, 0),
                      blurRadius: 4,
                      color: Colors.black.withOpacity(0.15),
                    ),
                  ],
                  color: Theme.of(context).primaryColor,
                ),
                child: Center(child: Text(categories[index].emoji)),
              ),
              SizedBox(width: 8),
              Text(
                categories[index].name,
                style: Theme.of(context).textTheme.caption,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
