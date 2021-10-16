import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salt/designs/designs.dart';
import 'package:salt/models/food-category/food-category.dart';
import 'package:salt/providers/food-categories.dart';

class FoodCategoriesDropDown extends StatefulWidget {
  const FoodCategoriesDropDown({Key? key}) : super(key: key);

  @override
  _FoodCategoriesDropDownState createState() => _FoodCategoriesDropDownState();
}

class _FoodCategoriesDropDownState extends State<FoodCategoriesDropDown> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      Provider.of<FoodCategoriesProvider>(
        context,
        listen: false,
      ).fetchAllFoodCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    FoodCategoriesProvider _provider = Provider.of<FoodCategoriesProvider>(
      context,
    );

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: DesignSystem.grey3, width: 1),
        borderRadius: BorderRadius.circular(4),
      ),
      padding: EdgeInsets.symmetric(horizontal: 4),
      child: DropdownButton<String>(
        underline: SizedBox(),
        isExpanded: true,
        icon: !_provider.isLoading()
            ? Icon(Icons.arrow_drop_down)
            : Container(
                child: Center(
                  child: CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),
        elevation: 4,
        value: null,
        hint: Text('Select tags'),
        items: <FoodCategory>[..._provider.getFoodCategories()]
            .map((FoodCategory value) {
          return DropdownMenuItem<String>(
            key: Key(value.id),
            value: value.id,
            child: Text(
              '${value.emoji} ${value.name[0].toUpperCase()}${value.name.substring(1)}',
            ),
          );
        }).toList(),
        onChanged: (_id) {
          if (_id != null) {
            var selectedCategory = _provider.foodCategories
                .where(
                  (element) => element.id == _id,
                )
                .toList();

            if (selectedCategory.length > 0) {
              _provider.addTag(selectedCategory[0]);
              _provider.removeFoodCategory(selectedCategory[0].id);
            }
          }
        },
      ),
    );
  }
}
