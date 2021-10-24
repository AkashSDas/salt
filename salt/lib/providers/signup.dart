import 'package:flutter/material.dart';
import 'package:salt/services/auth.dart';
import 'package:salt/widgets/alerts/index.dart';

class SignUpFormProvider extends ChangeNotifier {
  String username = '';
  String email = '';
  String password = '';

  bool loading = false;

  /// UPDATE FORM DATA
  /// Form data includes - username, email, password

  void updateFormValue(String name, String value) {
    if (name == 'username') {
      username = value;
    } else if (name == 'email') {
      email = value;
    } else if (name == 'password') {
      password = value;
    }
    notifyListeners();
  }

  /// SIGN UP THE USER
  void signupUser(BuildContext context) async {
    AuthService _service = AuthService();

    setLoading(true);
    await _service.signup({
      'username': username,
      'email': email,
      'password': password,
    });
    setLoading(false);

    if (_service.error) {
      failedSnackBar(
        context: context,
        msg: _service.msg,
      );
    } else {
      successSnackBar(context: context, msg: _service.msg);
    }
  }

  void setLoading(bool value) {
    loading = value;
    notifyListeners();
  }

  void reset() {
    username = '';
    email = '';
    password = '';

    loading = false;
    notifyListeners();
  }
}
