import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:salt/utils/index.dart';

class FeedbackService {
  static var baseURL = '${dotenv.env["BACKEND_API_BASE_URL"]}feedback';
  static var options = Options(validateStatus: (int? status) {
    return status! < 500;
  });

  Future<Map> saveFeedback(
    int rating,
    String comment,
    String orderId,
    String productId,
    String userId,
    String token,
  ) async {
    var res = await runAsync(
      Dio().post(
        '$baseURL/$userId/$orderId/$productId',
        data: {'rating': rating, 'comment': comment},
        options: Options(
          validateStatus: (int? status) => status! < 500,
          headers: {'Authorization': 'Bearer $token'},
        ),
      ),
    );

    if (res[1] != null) {
      return {
        'error': true,
        'msg': 'Something went wrong, Please try again',
      };
    }

    var response = res[0] as Response;
    var data = response.data;
    if (data['error']) {
      return {'error': true, 'msg': data['msg']};
    }
    return {
      'error': false,
      'msg': data['msg'],
      'data': data['data'],
    };
  }
}
