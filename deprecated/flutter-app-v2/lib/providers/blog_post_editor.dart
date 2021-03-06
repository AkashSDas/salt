import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:salt/models/blog_post/blog_post.dart';
import 'package:salt/models/food_category/food_category.dart';
import 'package:salt/services/blog_post.dart';
import 'package:salt/services/food_category.dart';
import 'package:salt/utils/blog_post_editor.dart';
import 'package:salt/widgets/alerts/index.dart';

class BlogPostEditorCreateProvider extends ChangeNotifier {
  /// Form data
  String title = '';
  String description = '';
  String content = '';
  List<XFile> coverImgFile = []; // only single img
  List<FoodCategory> foodCategories = []; // fetched from backend
  List<FoodCategory> tags = []; // food category tags selected by user
  bool foodCategoriesLoading = false;
  bool saveLoading = false; // used when post is saved or updated

  bool previewContent = false;

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

  /// For creating post
  BlogPostEditorCreateProvider();

  /// For updating post
  BlogPostEditorCreateProvider.fromBlogPost({
    required this.title,
    required this.description,
    required this.content,
    required this.tags,
  });

  /// Toggle preview
  void togglePreviewContent() {
    previewContent = !previewContent;
    notifyListeners();
  }

  /// Save blog post
  Future<BlogPost?> saveBlogPost(
    BuildContext context,
    CreateBlogPost post,
    String token,
  ) async {
    BlogPostService _service = BlogPostService();

    setSaveLoading(true);
    var response = await _service.savePost(post, token);
    setSaveLoading(false);

    if (_service.error) {
      failedSnackBar(context: context, msg: _service.msg);
    } else {
      successSnackBar(context: context, msg: _service.msg);
      // return BlogPost.fromJson(response);
      /// TODO: from backend send food categories data instead id
      /// to make their objects here
      return null;
    }

    return null;
  }

  /// Update blog post
  Future<BlogPost?> updateBlogPost(
    BuildContext context,
    UpdateBlogPost post,
    String blogId,
    String userId,
    String token,
  ) async {
    BlogPostService _service = BlogPostService();

    setSaveLoading(true);
    await _service.updatePost(post, blogId, userId, token);
    setSaveLoading(false);

    if (_service.error) {
      failedSnackBar(context: context, msg: _service.msg);
    } else {
      successSnackBar(context: context, msg: _service.msg);
      // return BlogPost.fromJson(response);
      /// TODO: from backend send food categories data instead id
      /// to make their objects here
      return null;
    }

    return null;
  }
}
