import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:salt/models/food_category/food_category.dart';
import 'package:salt/utils/index.dart';

class FoodCategoryService {
  late bool error;
  late String msg;

  var baseURL = '${dotenv.env["BACKEND_API_BASE_URL"]}food-category/';
  var options = Options(validateStatus: (int? status) {
    return status! < 500;
  });

  FoodCategoryService() {
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

  /// Get all categories
  Future<List<FoodCategory>> getAll() async {
    var result = await sanitizeResponse(Dio().get(baseURL, options: options));
    if (result[0]) return [];
    var data = result[1];

    List<FoodCategory> categories = [];
    for (int i = 0; i < data['categories'].length; i++) {
      categories.add(FoodCategory.fromJson(data['categories'][i]));
    }
    return categories;
  }
}
