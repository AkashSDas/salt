import 'package:flutter/material.dart';
import 'package:salt/models/food-category/food-category.dart';

class FoodCategoryListItem extends StatelessWidget {
  final FoodCategory foodCategory;
  const FoodCategoryListItem({
    required this.foodCategory,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 24),
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 2),
            blurRadius: 4,
            color: Color(0xff585858).withOpacity(0.12),
          ),
        ],
        borderRadius: BorderRadius.circular(32),
      ),
      child: Column(
        children: [
          Text(
            foodCategory.emoji,
            style: TextStyle(fontSize: 30),
          ),
          SizedBox(height: 10),
          Text(
            '${foodCategory.name.toUpperCase()[0]}${foodCategory.name.substring(1)}',
            style: TextStyle(fontSize: 11),
          ),
        ],
      ),
    );
  }
}
