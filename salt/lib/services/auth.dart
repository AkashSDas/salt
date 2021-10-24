import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:salt/utils/index.dart';

class AuthService {
  late bool error;
  late String msg;

  var baseURL = '${dotenv.env["BACKEND_API_BASE_URL"]}main-user-auth/';
  var options = Options(validateStatus: (int? status) {
    return status! < 500;
  });

  AuthService() {
    error = false;
    msg = '';
  }

  /// Sign up
  Future<void> signup(Map<String, String> data) async {
    var response = await runAsync(
      Dio().post('${baseURL}signup', data: data, options: options),
    );

    if (response[0] != null) {
      /// No error in backend
      Response res = response[0] as Response;
      var data = res.data;
      error = data['error'];
      msg = data['message'];
    } else {
      error = true;
      msg = 'Something went wrong, Please try again';
    }
  }
}
