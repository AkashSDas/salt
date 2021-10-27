import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:salt/models/food_category/food_category.dart';
import 'package:salt/models/recipe/recipe.dart';
import 'package:salt/services/food_category.dart';
import 'package:salt/services/recipe.dart';
import 'package:salt/utils/recipe_editor.dart';
import 'package:salt/widgets/alerts/index.dart';

class RecipeEditorProvider extends ChangeNotifier {
  /// Form data
  String title = '';
  String description = '';
  String content = '';
  List<XFile> coverImgFile = []; // only single img
  List<FoodCategory> foodCategories = []; // fetched from backend
  List<FoodCategory> tags = []; // food category tags selected by user
  bool foodCategoriesLoading = false;
  bool saveLoading = false; // used when post is saved or updated
  List<RecipeIngredient> ingredients = [];

  bool previewContent = false;

  // DataTable.columnSpacing default height which is 56.0
  double tableHeight = 56;

  /// Add ingredient
  void addIngredient(RecipeIngredient ingredient) {
    ingredients.add(ingredient);
    tableHeight = tableHeight + 44;
    notifyListeners();
  }

  /// Remove ingredient
  void removeIngredient(int index) {
    ingredients.removeAt(index);
    tableHeight = tableHeight - 44;
    notifyListeners();
  }

  /// Update text values
  void updateFormValue(String name, String value) {
    if (name == 'title') {
      title = value;
    } else if (name == 'description') {
      description = value;
    } else if (name == 'content') {
      content = value;
    }
    notifyListeners();
  }

  /// Update cover img
  void updateCoverImg(XFile file) {
    coverImgFile = [file];
    notifyListeners();
  }

  /// LOADERS

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
    FoodCategoryService _service = FoodCategoryService();

    setFoodCategoriesLoading(true);
    var response = await _service.getAll();

    /// TODO: if some error then notify user

    if (!_service.error) foodCategories = response;
    setFoodCategoriesLoading(false);
    notifyListeners();
  }

  /// For updating blog post, filtering out categories
  /// that are in tags
  Future<void> fetchAllFoodCategoriedFiltered() async {
    FoodCategoryService _service = FoodCategoryService();

    setFoodCategoriesLoading(true);
    var response = await _service.getAll();

    if (!_service.error) {
      List<FoodCategory> filteredCategories = [];
      for (final category in response) {
        final exists = tags.where((tag) => category.id == tag.id).isNotEmpty;
        if (!exists) filteredCategories.add(category);
      }
      foodCategories = filteredCategories;
      notifyListeners();
    }

    setFoodCategoriesLoading(false);
  }

  /// CONSTRUCTORS

  /// For creating recipe
  RecipeEditorProvider();

  /// For updating recipe
  RecipeEditorProvider.fromRecipe({
    required this.title,
    required this.description,
    required this.content,
    required this.tags,
    required this.ingredients,
    required this.tableHeight,
  });

  /// Toggle preview
  void togglePreviewContent() {
    previewContent = !previewContent;
    notifyListeners();
  }

  /// Save recipe
  Future<Recipe?> saveRecipe(
    BuildContext context,
    CreateRecipe recipe,
    String token,
  ) async {
    RecipeService _service = RecipeService();

    setSaveLoading(true);
    await _service.saveRecipe(recipe, token);
    setSaveLoading(false);

    if (_service.error) {
      failedSnackBar(context: context, msg: _service.msg);
    } else {
      successSnackBar(context: context, msg: _service.msg);
      return null;
    }

    return null;
  }
}

class IngredientFormProvider extends ChangeNotifier {
  String name = '';
  String quantity = '';
  String description = '';

  void updateFormValue(String field, String value) {
    if (field == 'name') {
      name = value;
    } else if (field == 'quantity') {
      quantity = value;
    } else if (field == 'description') {
      description = value;
    }

    notifyListeners();
  }

  void reset() {
    name = '';
    quantity = '';
    description = '';
    notifyListeners();
  }
}
