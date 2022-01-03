import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:salt/utils/api.dart';
import 'package:salt/utils/index.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as storage;

class AuthService {
  static var baseURL = '${dotenv.env["BACKEND_API_BASE_URL"]}auth/';
  static var options = Options(validateStatus: (int? status) {
    return status! < 500;
  });

  /// Sign up
  static Future<ApiResponse> signup(Map<String, dynamic> data) async {
    var res = await runAsync(
      Dio().post('${baseURL}signup', data: data, options: options),
    );

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

  /// Login
  static Future<ApiResponse> login(Map<String, dynamic> data) async {
    var res = await runAsync(
      Dio().post('${baseURL}login', data: data, options: options),
    );

    if (res[0] == null) {
      return ApiResponse(error: true, msg: ApiMessages.wentWrong, data: null);
    }

    Response apiRes = res[0] as Response;
    var result = apiRes.data;
    var apiResponse = ApiResponse(
      error: result['error'],
      msg: result['msg'],
      data: result['data'],
    );

    if (!apiResponse.error) {
      /// Save user data to secure storage
      var _storage = const storage.FlutterSecureStorage();
      var isSaved = await runAsync(
        _storage.write(key: 'user', value: jsonEncode(apiResponse.data)),
      );

      /// Couldn't save user info
      if (isSaved[1] != null) {
        /// Making error true and response null
        apiResponse.error = true;
        apiResponse.msg = 'Something went wrong, Please try again';
      }
    }

    return apiResponse;
  }

  /// Is user authenticated. It returns [Map] which has user's data and token
  Future<dynamic> isAuthenticated() async {
    var _storage = const storage.FlutterSecureStorage();
    final response = await runAsync(_storage.read(key: 'user'));

    if (response[1] != null) return null;
    if (response[0] == null) {
      return null;
    } else {
      response[0] = jsonDecode(response[0]);
      return response[0];
    }
  }

  Future<void> logout() async {
    var result = await runAsync(Dio().get('$baseURL/logout', options: options));

    if (result[1] == null) {
      Response<dynamic> res = result[0] as Response<dynamic>;
      result[0] = res.data;

      if (!result[0]['error']) {
        /// Logout user in this device
        const _storage = storage.FlutterSecureStorage();
        await runAsync(_storage.delete(key: 'user'));
      }
    }
  }
}
