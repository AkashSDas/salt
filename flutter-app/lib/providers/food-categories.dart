import 'package:flutter/material.dart';
import 'package:salt/models/food-category/food-category.dart';
import 'package:salt/services/food-categories.dart';

class FoodCategoriesProvider extends ChangeNotifier {
  List<dynamic> foodCategories = [];
  List<dynamic> tags = [];
  bool loading = false;

  Future<dynamic> fetchAllFoodCategories() async {
    setLoading(true);
    var response = await getAllFoodCategories();
    if (response[1] == null)
      setFoodCategories(response[0]['data']['categories']);
    setLoading(false);
  }

  /// Food Categories

  void setFoodCategories(List<dynamic> categories) {
    foodCategories = categories;
    notifyListeners();
  }

  List<dynamic> getFoodCategories() => foodCategories;

  void addFoodCategory(FoodCategory category) {
    foodCategories = [...foodCategories, category];
    notifyListeners();
  }

  void removeFoodCategory(String categoryId) {
    foodCategories = foodCategories
        .where(
          (category) => category.id != categoryId,
        )
        .toList();
    notifyListeners();
  }

  /// Tags

  void addTag(FoodCategory tag) {
    tags = [...tags, tag];
    notifyListeners();
  }

  void removeTag(String tagId) {
    tags = tags.where((tag) => tag.id != tagId).toList();
    notifyListeners();
  }

  /// Loading

  void setLoading(value) {
    loading = value;
    notifyListeners();
  }

  bool isLoading() => loading;
}
