import 'package:flutter/material.dart';
import 'package:salt/models/user/user.dart';

class UserProvider extends ChangeNotifier {
  User? user;
  String? token;

  UserProvider() {
    user = null;
    token = null;
  }

  /// Login user in the application by setting the [user] and [token]
  /// from [userData]
  void login(Object? userData) {
    user = User.fromJson((userData as Map<String, dynamic>)['user']);
    token = userData['token'];
    notifyListeners();
  }

  /// Logging user out of the application by setting the [user] and [token]
  /// to `null`
  void logout() {
    user = null;
    token = null;
    notifyListeners();
  }
}
