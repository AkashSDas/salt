import 'package:flutter/cupertino.dart';
import 'package:salt/models/recipe/recipe.dart';
import 'package:salt/services/recipe.dart';

/// This provider will be used in case where the recipes listview
/// is wrapped with another listview and after reaching the end of
/// upper (parent) listview, more recipes will be called and once received
/// then notifying the child listview having recipes with the new recipes
class RecipesInfiniteScrollProvider extends ChangeNotifier {
  var limit = 2;

  RecipesInfiniteScrollProvider({int limit = 2}) {
    limit = limit;
  }

  List<Recipe> recipes = [];
  var loading = false;
  var reachedEnd = false;

  /// The firstLoading will be used for the first data fetching when
  /// the widget has mounted and then won't be used again during the
  /// lifecycle of that widget
  var firstLoading = false;
  var firstError = false;
  var firstApiResponseMsg = '';

  /// Info about next set of recipes to fetch from backend
  var hasNext = false;
  var nextId = '';

  /// ERROR & MSG
  var error = false;
  var apiResponseMsg = '';

  /// FETCHING DATA

  Future<void> initialFetch() async {
    RecipeService _service = RecipeService();

    setFirstLoading(true);
    var response = await _service.getPaginated(limit: limit);
    setFirstLoading(false);

    /// Checking for error
    if (_service.error) {
      firstError = true;
      firstApiResponseMsg = _service.msg;
    } else {
      recipes = [...recipes, ...response];
    }

    notifyListeners();
  }

  Future<void> fetchMore() async {
    RecipeService _service = RecipeService();

    setLoading(true);
    var response = await _service.getPaginated(
      limit: limit,
      hasNext: hasNext,
      nextId: nextId,
    );
    setLoading(false);

    /// Checking for error
    if (_service.error) {
      error = true;
      apiResponseMsg = _service.msg;
    } else {
      recipes = [...recipes, ...response];
    }

    notifyListeners();
  }

  /// LOADERS

  void setLoading(bool value) {
    loading = value;
    notifyListeners();
  }

  void setFirstLoading(bool value) {
    firstLoading = value;
    notifyListeners();
  }

  /// FETCHING DATA FOR LOGGED IN USER

  Future<void> initialFetchForLoggedInUser(String userId, String token) async {
    RecipeService _service = RecipeService();

    setFirstLoading(true);
    var response = await _service.getPaginatedForLoggedInUser(
      token: token,
      limit: limit,
      userId: userId,
    );
    setFirstLoading(false);

    /// Checking for error
    if (_service.error) {
      firstError = true;
      firstApiResponseMsg = _service.msg;
    } else {
      recipes = [...recipes, ...response];
    }

    notifyListeners();
  }

  Future<void> fetchMoreForLoggedInUser(String userId, String token) async {
    RecipeService _service = RecipeService();

    setLoading(true);
    var response = await _service.getPaginatedForLoggedInUser(
      limit: limit,
      token: token,
      userId: userId,
      hasNext: hasNext,
      nextId: nextId,
    );
    setLoading(false);

    /// Checking for error
    if (_service.error) {
      error = true;
      apiResponseMsg = _service.msg;
    } else {
      recipes = [...recipes, ...response];
    }

    notifyListeners();
  }
}
