import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'
    as SecureStorage;
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

Future<List<dynamic>> login(Map<String, String> data) async {
  final result = await runAsync(Dio().post(
    'http://localhost:8000/api/main-user-auth/login',
    data: data,
    options: Options(validateStatus: (int? status) {
      return status! < 500;
    }),
  ));

  if (result[0] != null) {
    Response<dynamic> res = result[0] as Response<dynamic>;
    result[0] = res.data;

    if (!result[0]['error']) {
      /// Save user data to secure storage
      final _storage = SecureStorage.FlutterSecureStorage();
      final response = await runAsync(
        _storage.write(key: 'user', value: jsonEncode(res.data['data'])),
      );

      /// Couldn't save user info
      if (response[1] != null) {
        /// Making error true and response null
        result[1] = true;
        result[0] = null;
      }
    }
  }

  return result;
}

Future<void> isAuthenticated() async {
  final _storage = SecureStorage.FlutterSecureStorage();
  final response = await runAsync(_storage.read(key: 'user'));
  print(response);
}
