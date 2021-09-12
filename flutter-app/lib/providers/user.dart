import 'package:flutter/material.dart';
import 'package:salt/models/user/user.dart';

class UserProvider extends ChangeNotifier {
  User? user;
  String? token;

  UserProvider()
      : this.user = null,
        this.token = null;

  void login(User userData) {
    user = userData;
    notifyListeners();
  }
}
