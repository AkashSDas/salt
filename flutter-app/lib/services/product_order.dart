import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:salt/utils/api.dart';
import 'package:salt/utils/index.dart';

class ProductOrderService {
  static var baseURL = '${dotenv.env["BACKEND_API_BASE_URL"]}product-order';
  static var options = Options(validateStatus: (int? status) {
    return status! < 500;
  });

  /// Get user's all product order (paginated)
  Future<ApiResponse> getUserProductOrders(
    String userId,
    String token,
    int? limit,
    String? nextId,
  ) async {
    var url = '$baseURL/$userId';
    if (limit != null) url = '$baseURL/$userId?limit=$limit';
    if (nextId != null) url = '$baseURL/$userId?nextId=$nextId';
    if (limit != null && nextId != null) {
      url = '$baseURL/$userId?limit=$limit&next=$nextId';
    }
    var res = await runAsync(Dio().get(
      url,
      options: Options(
        validateStatus: (int? status) => status! < 500,
        headers: {'Authorization': 'Bearer $token'},
      ),
    ));

    if (res[0] == null) {
      return ApiResponse(error: true, msg: ApiMessages.wentWrong, data: null);
    }

    Response apiRes = res[0] as Response;
    var result = apiRes.data;
    return ApiResponse(
      error: result['error'],
      msg: result['msg'],
      data: result['data'],
    );
  }
}
