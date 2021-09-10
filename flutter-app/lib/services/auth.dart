import 'package:dio/dio.dart';

void signup(Map<String, String> data) async {
  try {
    var response = await Dio().post(
      'http://localhost:8000/api/main-user-auth/signup',
      data: data,
      options: Options(validateStatus: (int? status) {
        return status! < 500;
      }),
    );
    print(response);
  } catch (err) {
    print(err);
  }
}
