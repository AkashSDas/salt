import 'package:flutter/material.dart';
import 'package:salt/services/auth.dart';
import 'package:salt/widgets/alerts/index.dart';

class LoginFormProvider extends ChangeNotifier {
  String email = '';
  String password = '';

  bool loading = false;

  void updateFormValue(String name, String value) {
    if (name == 'email') {
      email = value;
    } else if (name == 'password') {
      password = value;
    }
    notifyListeners();
  }

  /// LOGIN THE USER
  Future<dynamic> loginUser(BuildContext context) async {
    AuthService _service = AuthService();

    setLoading(true);
    var data = await _service.login({'email': email, 'password': password});
    setLoading(false);

    if (_service.error) {
      failedSnackBar(context: context, msg: _service.msg);
    } else {
      successSnackBar(context: context, msg: _service.msg);
      return data;
    }

    return null;
  }

  void setLoading(bool value) {
    loading = value;
    notifyListeners();
  }

  void reset() {
    email = '';
    password = '';

    loading = false;
    notifyListeners();
  }
}
