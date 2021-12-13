import 'package:flutter/material.dart';
import 'package:salt/services/auth.dart';
import 'package:salt/utils/api.dart';

class SignupFormProvider extends ChangeNotifier {
  /// Form data
  String username = '';
  String email = '';
  String password = '';
  DateTime? dateOfBirth;

  var loading = false;
  var animation = 'idle';

  /// Update string values
  void updateStringFormValue(String name, String value) {
    if (name == 'username') {
      username = value;
    } else if (name == 'email') {
      email = value;
    } else if (name == 'password') {
      password = value;
    }
    notifyListeners();
  }

  /// Update date of birth
  void updateDateOfBirth(DateTime? dt) {
    dateOfBirth = dt;
    notifyListeners();
  }

  /// Form reset
  void formReset() {
    username = '';
    email = '';
    password = '';
    dateOfBirth = null;
    notifyListeners();
  }

  void setLoading(bool value) {
    loading = value;
    notifyListeners();
  }

  /// Sign up user
  Future<ApiResponse> signupUser() async {
    setLoading(true);
    var result = await AuthService.signup({
      'username': username,
      'email': email,
      'password': password,
      'dateOfBirth': dateOfBirth.toString().split(' ')[0],
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
