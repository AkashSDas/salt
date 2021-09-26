import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:salt/models/product/product.dart';

import '../utils.dart';

Future<dynamic> getAllProducts(
    {int? limit, bool? hasNext, String? nextId}) async {
  limit = limit != null ? limit : 10;

  String baseURL = '${dotenv.env["BACKEND_API_BASE_URL"]}produc?limit=$limit';
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
      List<dynamic> products = response[0]['data']['products'];
      for (int i = 0; i < products.length; i++) {
        products[i] = Product.fromJson(products[i]);
      }
      response[0]['data']['products'] = products;
    }
  }

  return response;
}
