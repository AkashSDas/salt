import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:salt/utils/index.dart';

class PaymentService {
  static var baseURL = '${dotenv.env["BACKEND_API_BASE_URL"]}payment';
  static var options = Options(validateStatus: (int? status) {
    return status! < 500;
  });

  /// Get all user's payment cards
  Future<Map> getUserPaymentCards(String userId, String token) async {
    var res = await runAsync(
      Dio().get(
        '$baseURL/wallet/$userId',
        options: Options(
          validateStatus: (int? status) => status! < 500,
          headers: {
            'Authorization': 'Bearer $token',
          },
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
    } else {
      return {
        'error': false,
        'msg': data['msg'],
        'cards': data['data']['cards'],
      };
    }
  }
}
