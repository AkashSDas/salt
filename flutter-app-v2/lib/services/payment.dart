import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:salt/utils/index.dart';

class PaymentService {
  late bool error;
  late String msg;

  var baseURL = '${dotenv.env["BACKEND_API_BASE_URL"]}payment/stripe/payment/';

  PaymentService() {
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

  /// Products checkout
  Future<void> productsCheckout(
    String userId,
    String token,
    double amount,
    String paymentMethodId,
  ) async {
    await sanitizeResponse(
      Dio().post(
        '$baseURL$userId',
        data: {
          'amount': amount * 100,
          'payment_method': paymentMethodId,
        },
        options: Options(
          validateStatus: (int? status) => status! < 500,
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      ),
    );
  }
}
