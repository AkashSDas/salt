import 'package:flutter/material.dart';
import 'package:salt/models/user/user.dart';

class UserProvider extends ChangeNotifier {
  User? user;
  String? token;

  UserProvider() {
    user = null;
    token = null;
  }
}
