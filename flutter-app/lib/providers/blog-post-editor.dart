import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:salt/models/food-category/food-category.dart';
import 'package:salt/services/food-categories.dart';

/// TODO: merge food categories provider for blog post editor
/// into this one
/// TODO: Resolve the dispose error
class BlogPostEditorFormProvider extends ChangeNotifier {
  /// Form data
  String title = '';
  String description = '';
  String content = '';
  List<XFile> coverImgFile = []; // only single img
  List<dynamic> foodCategories = []; // fetched from backend
  List<dynamic> tags = []; // food category tags selected by user
  bool foodCategoriesLoading = false;
  bool saveLoading = false; // used when post is saved or updated

  /// UPDATE TEXT INPUT

  void updateTextInput(String field, String newValue) {
    if (field == 'title')
      title = newValue;
    else if (field == 'description')
      description = newValue;
    else if (field == 'content') content = newValue;

    notifyListeners();
  }

  void updateCoverImgFile(XFile file) {
    coverImgFile = [file];
    notifyListeners();
  }

  void setFoodCategoriesLoading(bool value) {
    foodCategoriesLoading = value;
    notifyListeners();
  }

  void setSaveLoading(bool value) {
    saveLoading = value;
    notifyListeners();
  }

  /// FOOD CATEGORIES

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

  /// TAGS

  void addTag(FoodCategory tag) {
    tags = [...tags, tag];
    notifyListeners();
  }

  void removeTag(String tagId) {
    tags = tags.where((tag) => tag.id != tagId).toList();
    notifyListeners();
  }

  List<String> getAllTagIds() {
    return tags.map((tag) => tag.id.toString()).toList();
  }

  /// BACKEND

  Future<void> fetchAllFoodCategories() async {
    setFoodCategoriesLoading(true);
    var response = await getAllFoodCategories();
    if (response[1] == null) foodCategories = response[0]['data']['categories'];
    notifyListeners();
    setFoodCategoriesLoading(false);
  }

  /// For updating blog post, filtering out categories
  /// that are in tags
  Future<void> fetchAllFoodCategoriedFiltered() async {
    setFoodCategoriesLoading(true);
    var response = await getAllFoodCategories();

    if (response[1] == null) {
      List<dynamic> data = response[0]['data']['categories'];
      var newCategories = [];

      data.forEach((category) {
        final categoryExists = tags
            .where(
              (tag) => category.id == tag.id,
            )
            .isNotEmpty;

        if (!categoryExists) newCategories.add(category);
      });

      foodCategories = newCategories;
      notifyListeners();
    }

    setFoodCategoriesLoading(false);
  }

  /// CONSTRUCTORS

  BlogPostEditorFormProvider();

  /// For updating post
  BlogPostEditorFormProvider.fromBlogPost({
    required this.title,
    required this.description,
    required this.content,
    required this.tags,
  });
}
