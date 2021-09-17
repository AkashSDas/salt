import 'package:flutter/material.dart';
import 'package:salt/models/user/user.dart';

class UserProvider extends ChangeNotifier {
  User? user;
  String? token;

  UserProvider()
      : this.user = null,
        this.token = null;

  void login(Object? userData) {
    this.user = User.fromJson((userData as Map<String, dynamic>)['user']);
    this.token = userData['token'];
    notifyListeners();
  }

  void logout() {
    this.user = null;
    this.token = null;
    notifyListeners();
  }
}
