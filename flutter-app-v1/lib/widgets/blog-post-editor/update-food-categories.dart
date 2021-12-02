import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salt/designs/designs.dart';
import 'package:salt/models/food-category/food-category.dart';
import 'package:salt/providers/blog-post-editor.dart';

class UpdateBlogPostEditorFoodCategoriesDropDown extends StatefulWidget {
  const UpdateBlogPostEditorFoodCategoriesDropDown({Key? key})
      : super(key: key);

  @override
  UpdateBlogPostEditorFoodCategoriesDropDownState createState() =>
      UpdateBlogPostEditorFoodCategoriesDropDownState();
}

class UpdateBlogPostEditorFoodCategoriesDropDownState
    extends State<UpdateBlogPostEditorFoodCategoriesDropDown>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      Provider.of<BlogPostEditorFormProvider>(
        context,
        listen: false,
      ).fetchAllFoodCategoriedFiltered();
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: DesignSystem.grey3, width: 1),
        borderRadius: BorderRadius.circular(4),
      ),
      padding: EdgeInsets.symmetric(horizontal: 4),
      child: _buildDropDown(),
    );
  }

  Widget _buildDropDown() {
    return Builder(
      builder: (context) {
        BlogPostEditorFormProvider _provider =
            Provider.of<BlogPostEditorFormProvider>(context);

        var icon = !_provider.foodCategoriesLoading
            ? Icon(Icons.arrow_drop_down)
            : Container(
                child: Center(
                  child: CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              );

        var items = <FoodCategory>[..._provider.foodCategories]
            .map((FoodCategory value) {
          return DropdownMenuItem<String>(
            key: Key(value.id),
            value: value.id,
            child: Text(
              '${value.emoji} ${value.name[0].toUpperCase()}${value.name.substring(1)}',
            ),
          );
        }).toList();

        var onChanged = (id) {
          if (id != null) {
            var selectedCategory = _provider.foodCategories
                .where((element) => element.id == id)
                .toList();

            if (selectedCategory.length > 0) {
              _provider.addTag(selectedCategory[0]);
              _provider.removeFoodCategory(selectedCategory[0].id);
            }
          }
        };

        return DropdownButton<String>(
          underline: SizedBox(),
          isExpanded: true,
          icon: icon,
          elevation: 4,
          value: null,
          hint: Text('Select tags'),
          items: items,
          onChanged: onChanged,
        );
      },
    );
  }
}
