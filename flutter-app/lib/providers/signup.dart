import 'package:flutter/material.dart';
import 'package:salt/services/auth.dart';
import 'package:salt/widgets/common/snackbar.dart';

class SignUpFormProvider extends ChangeNotifier {
  String username = '';
  String email = '';
  String password = '';

  bool loading = false;

  /// UPDATE FORM DATA
  /// Form data includes - username, email, password

  void updateFormValue(String name, String value) {
    if (name == 'username')
      updateUsername(value);
    else if (name == 'email')
      updateEmail(value);
    else if (name == 'password') updatePassword(value);
  }

  void updateUsername(String value) {
    username = value;
    notifyListeners();
  }

  void updateEmail(String value) {
    email = value;
    notifyListeners();
  }

  void updatePassword(String value) {
    password = value;
    notifyListeners();
  }

  /// SIGN UP THE USER
  void userSignUp(BuildContext context) async {
    setLoading(true);
    final response = await signup({
      'username': username,
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
      else
        successSnackBar(context: context, msg: response[0]['message']);
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
