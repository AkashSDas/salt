import 'package:dio/dio.dart';
import 'package:salt/models/food-category/food-category.dart';
import 'package:salt/utils.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<dynamic> getAllFoodCategories() async {
  var response = await runAsync(
    Dio().get(
      '${dotenv.env["BACKEND_API_BASE_URL"]}food-category/',
      options: Options(validateStatus: (int? status) {
        return status! < 500;
      }),
    ),
  );

  if (response[0] != null) {
    Response<dynamic> res = response[0] as Response<dynamic>;
    response[0] = res.data;

    if (!response[0]['error']) {
      List<dynamic> categories = response[0]['data']['categories'];
      for (int i = 0; i < categories.length; i++) {
        categories[i] = FoodCategory.fromJson(categories[i]);
      }
      response[0]['data']['categories'] = categories;
    }
  }

  return response;
}
