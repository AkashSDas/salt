import 'package:flutter/material.dart';
import 'package:salt/services/auth.dart';
import 'package:salt/widgets/common/snackbar.dart';

class LoginFormProvider extends ChangeNotifier {
  String email = '';
  String password = '';

  bool loading = false;

  void updateFormValue(String name, String value) {
    if (name == 'email')
      updateEmail(value);
    else if (name == 'password') updatePassword(value);
  }

  void updateEmail(String value) {
    email = value;
    notifyListeners();
  }

  void updatePassword(String value) {
    password = value;
    notifyListeners();
  }

  /// LOGIN THE USER
  Future<List<dynamic>> userLogin(BuildContext context) async {
    setLoading(true);
    final response = await login({
      'email': email,
      'password': password,
    });
    setLoading(false);

    if (response[1] != null)
      failedSnackBar(
        context: context,
        msg: 'Something went wrong, Please try again',
      );
    else {
      if (response[0]['error'])
        failedSnackBar(context: context, msg: response[0]['message']);
      else {
        successSnackBar(context: context, msg: response[0]['message']);
        return [true, response[0]['data']];
      }
    }

    return [false, null];
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
