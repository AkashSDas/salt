import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salt/design_system.dart';
import 'package:salt/models/food_category/food_category.dart';
import 'package:salt/providers/recipe_editor.dart';

class FoodCategoryDropDown extends StatefulWidget {
  const FoodCategoryDropDown({Key? key}) : super(key: key);

  @override
  State<FoodCategoryDropDown> createState() => _FoodCategoryDropDownState();
}

class _FoodCategoryDropDownState extends State<FoodCategoryDropDown> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      Provider.of<RecipeEditorProvider>(
        context,
        listen: false,
      ).fetchAllFoodCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: DesignSystem.gallery,
        borderRadius: BorderRadius.circular(32),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: const _DropDownBtn(),
    );
  }
}

class _DropDownBtn extends StatelessWidget {
  const _DropDownBtn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    RecipeEditorProvider _p = Provider.of<RecipeEditorProvider>(context);

    var items = <FoodCategory>[..._p.foodCategories].map((FoodCategory value) {
      return DropdownMenuItem<String>(
        key: Key(value.id),
        value: value.id,
        child: Text(
          '${value.emoji} ${value.name[0].toUpperCase()}${value.name.substring(1)}',
          style: DesignSystem.bodyMain,
        ),
      );
    }).toList();

    return DropdownButton<String>(
      underline: const SizedBox(),
      isExpanded: true,
      icon: const _DropDownIcon(),
      elevation: 4,
      value: null,
      hint: Text('Select tags', style: DesignSystem.caption),
      items: items,
      onChanged: (id) {
        if (id != null) {
          var selectedCategory = _p.foodCategories
              .where(
                (category) => category.id == id,
              )
              .toList();

          if (selectedCategory.isNotEmpty) {
            _p.addTag(selectedCategory[0]);
            _p.removeFoodCategory(selectedCategory[0].id);
          }
        }
      },
      borderRadius: BorderRadius.circular(16),
      dropdownColor: DesignSystem.white,
    );
  }
}

class _DropDownIcon extends StatelessWidget {
  const _DropDownIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    RecipeEditorProvider _p = Provider.of<RecipeEditorProvider>(context);

    if (_p.foodCategoriesLoading) {
      return const SizedBox(
        height: 24,
        width: 24,
        child: CircularProgressIndicator(),
      );
    }

    return const Icon(Icons.arrow_drop_down_circle_outlined);
  }
}
