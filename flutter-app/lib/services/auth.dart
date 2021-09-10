import 'package:dio/dio.dart';
import 'package:salt/utils.dart';

Future<List<dynamic>> signup(Map<String, String> data) async {
  final result = await runAsync(Dio().post(
    'http://localhost:8000/api/main-user-auth/signup',
    data: data,
    options: Options(validateStatus: (int? status) {
      return status! < 500;
    }),
  ));
  if (result[0] != null) {
    /// Getting response data
    Response<dynamic> res = result[0] as Response<dynamic>;
    result[0] = res.data;
  }
  return result;
}
