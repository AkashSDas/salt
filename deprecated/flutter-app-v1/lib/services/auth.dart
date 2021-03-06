import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'
    as SecureStorage;
import 'package:salt/utils.dart';

Future<List<dynamic>> signup(Map<String, String> data) async {
  final result = await runAsync(Dio().post(
    '${dotenv.env["BACKEND_API_BASE_URL"]}main-user-auth/signup',
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
    '${dotenv.env["BACKEND_API_BASE_URL"]}main-user-auth/login',
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

Future<dynamic> isAuthenticated() async {
  final _storage = SecureStorage.FlutterSecureStorage();
  final response = await runAsync(_storage.read(key: 'user'));

  if (response[1] != null) return null;
  if (response[0] == null)
    return null;
  else {
    response[0] = jsonDecode(response[0]);
    return response[0];
  }
}

Future<dynamic> logout() async {
  var result = await runAsync(Dio().get(
    '${dotenv.env["BACKEND_API_BASE_URL"]}main-user-auth/logout',
    options: Options(validateStatus: (int? status) {
      return status! < 500;
    }),
  ));

  if (result[1] == null) {
    Response<dynamic> res = result[0] as Response<dynamic>;
    result[0] = res.data;

    if (!result[0]['error']) {
      /// Logout user in this device
      final _storage = SecureStorage.FlutterSecureStorage();
      await runAsync(_storage.delete(key: 'user'));
    }
  }

  return result;
}
