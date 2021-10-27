import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:salt/models/recipe/recipe.dart';
import 'package:salt/utils/index.dart';
import 'package:salt/utils/recipe_editor.dart';

class RecipeService {
  late bool error;
  late String msg;

  var baseURL = '${dotenv.env["BACKEND_API_BASE_URL"]}recipe/';
  var options = Options(validateStatus: (int? status) {
    return status! < 500;
  });

  RecipeService() {
    error = false;
    msg = '';
  }

  /// return [error, data]
  Future<List<dynamic>> sanitizeResponse(Future dioPromise) async {
    var result = await runAsync(dioPromise);

    /// No error
    if (result[0] != null) {
      Response<dynamic> response = result[0] as Response;
      var data = response.data;
      msg = data['message'];

      if (data['error']) {
        /// Error in backend
        error = true;
      } else {
        return [false, data['data']];
      }
    } else {
      error = true;
      msg = 'Something went wrong';
    }

    return [true, null];
  }

  /// Get all categories (paginated)
  Future<List<Recipe>> getPaginated({
    int limit = 10,
    bool? hasNext,
    String? nextId,
  }) async {
    var result = await sanitizeResponse(
      Dio().get('$baseURL?limit=$limit', options: options),
    );

    if (result[0]) return [];
    var data = result[1];

    List<Recipe> recipes = [];
    for (int i = 0; i < data['recipes'].length; i++) {
      recipes.add(Recipe.fromJson(data['recipes'][i]));
    }
    return recipes;
  }

  /// Save recipe
  Future<dynamic> saveRecipe(CreateRecipe recipe, String token) async {
    /// read time
    int wordCount = recipe.content.trim().split(' ').length;
    double readTime = (wordCount / 100 + 1).roundToDouble();

    /// image
    String filename = recipe.coverImg.path.split('/').last;

    FormData formData = FormData.fromMap({
      'title': recipe.title,
      'description': recipe.description,
      'content': recipe.content,
      'readTime': readTime,
      'author': recipe.authorId,
      'coverImg': await MultipartFile.fromFile(
        recipe.coverImg.path,
        filename: filename,
      ),
      'categories': jsonEncode(recipe.categories),
      'ingredients': jsonEncode(
        recipe.ingredients.map((ingredient) => ingredient.toMap()).toList(),
      ),
    });

    var response = await sanitizeResponse(
      Dio().post(
        '$baseURL/${recipe.authorId}',
        data: formData,
        options: Options(
          validateStatus: (int? status) => status! < 500,
          headers: {'Authorization': 'Bearer $token'},
        ),
      ),
    );

    if (response[0]) return null;
    return response[1]['recipe'];
  }
}
