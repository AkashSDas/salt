import 'package:flutter/material.dart';
import 'package:salt/services/auth.dart';
import 'package:salt/utils/api.dart';

class LoginFormProvider extends ChangeNotifier {
  /// Form data
  String email = '';
  String password = '';

  var loading = false;
  var animation = 'idle';

  /// Update string values
  void updateStringFormValue(String name, String value) {
    if (name == 'email') {
      email = value;
    } else if (name == 'password') {
      password = value;
    }
    notifyListeners();
  }

  /// Form reset
  void formReset() {
    email = '';
    password = '';
    notifyListeners();
  }

  void setLoading(bool value) {
    loading = value;
    notifyListeners();
  }

  /// Sign up user
  Future<ApiResponse> signupUser() async {
    setLoading(true);
    var result = await AuthService.login({
      'email': email,
      'password': password,
    });
    updateAnimation(!result.error);
    setLoading(false);

    return result;
  }

  void updateAnimation(bool success) {
    if (success) {
      if (animation == 'idle') {
        animation = 'normal to success';
      } else {
        animation = 'error to success';
      }
    } else {
      if (animation == 'idle') {
        animation = 'normal to error';
      } else {
        animation = 'success to error';
      }
    }

    notifyListeners();
  }
}
