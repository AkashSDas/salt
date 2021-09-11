import 'package:flutter/material.dart';
import 'package:salt/services/food-categories.dart';
import 'package:salt/widgets/food-categories/food-category-list-item-loader.dart';
import 'package:salt/widgets/food-categories/food-category-list-item.dart';

class CategoriesList extends StatefulWidget {
  const CategoriesList({Key? key}) : super(key: key);

  @override
  _CategoriesListState createState() => _CategoriesListState();
}

class _CategoriesListState extends State<CategoriesList> {
  late Future<dynamic> _getAllFoodCategories;

  @override
  void initState() {
    super.initState();
    _getAllFoodCategories = getAllFoodCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Categories',
          style: Theme.of(context).textTheme.bodyText2?.copyWith(
                color: Theme.of(context).textTheme.headline1?.color,
                fontWeight: FontWeight.w700,
              ),
        ),
        SizedBox(height: 16),
        FutureBuilder(
          future: _getAllFoodCategories,
          builder: (context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) return FoodCategoryListItemLoader();

            var error = snapshot.data[1];
            var data = snapshot.data[0];

            if (error != null || data['error'])
              return FoodCategoryListItemLoader();

            List<dynamic> categories = data['data']['categories'];
            return Container(
              height: 94,
              // padding: EdgeInsets.only(left: 16),
              child: ListView.builder(
                clipBehavior: Clip.none,
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, idx) => FoodCategoryListItem(
                  foodCategory: categories[idx],
                  key: Key(idx.toString()),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
