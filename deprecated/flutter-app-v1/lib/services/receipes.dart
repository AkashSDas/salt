import 'package:dio/dio.dart';
import 'package:salt/models/recipe/recipe.dart';
import 'package:salt/utils.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<dynamic> getAllRecipesPaginated({
  int? limit,
  bool? hasNext,
  String? nextId,
}) async {
  limit = limit != null ? limit : 10;

  String baseURL = '${dotenv.env["BACKEND_API_BASE_URL"]}recipe?limit=$limit';
  if (hasNext == true) {
    baseURL = '$baseURL&next=$nextId';
  }

  var response = await runAsync(
    Dio().get(
      baseURL,
      options: Options(validateStatus: (int? status) {
        return status! < 500;
      }),
    ),
  );

  if (response[0] != null) {
    Response<dynamic> res = response[0] as Response<dynamic>;
    response[0] = res.data;

    if (!response[0]['error']) {
      List<dynamic> recipes = response[0]['data']['recipes'];
      for (int i = 0; i < recipes.length; i++) {
        recipes[i] = Recipe.fromJson(recipes[i]);
      }
      response[0]['data']['recipes'] = recipes;
    }
  }

  return response;
}
