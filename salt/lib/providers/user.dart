import 'package:flutter/material.dart';
import 'package:salt/models/user/user.dart';

class UserProvider extends ChangeNotifier {
  User? user;
  String? token;

  UserProvider() {
    user = null;
    token = null;
  }

  void login(Object? userData) {
    user = User.fromJson((userData as Map<String, dynamic>)['user']);
    token = userData['token'];
    notifyListeners();
  }

  void logout() {
    user = null;
    token = null;
    notifyListeners();
  }
}
