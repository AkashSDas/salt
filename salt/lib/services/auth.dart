import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:salt/utils/index.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as Storage;

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

  /// Login
  Future<dynamic> login(Map<String, String> data) async {
    var response = await runAsync(
      Dio().post('${baseURL}login', data: data, options: options),
    );

    if (response[0] != null) {
      /// No error in backend
      Response res = response[0] as Response;
      var data = res.data;
      error = data['error'];
      msg = data['message'];

      if (!error) {
        /// Save user data to secure storage
        var _storage = const Storage.FlutterSecureStorage();
        response = await runAsync(
          _storage.write(key: 'user', value: jsonEncode(data['data'])),
        );

        /// Couldn't save user info
        if (response[1] != null) {
          /// Making error true and response null
          error = true;
          msg = 'Something went wrong, Please try again';
        } else {
          return data['data'];
        }
      }
    } else {
      error = true;
      msg = 'Something went wrong, Please try again';
    }

    return null;
  }

  Future<dynamic> isAuthenticated() async {
    var _storage = const Storage.FlutterSecureStorage();
    final response = await runAsync(_storage.read(key: 'user'));

    if (response[1] != null) return null;
    if (response[0] == null) {
      return null;
    } else {
      response[0] = jsonDecode(response[0]);
      return response[0];
    }
  }
}
