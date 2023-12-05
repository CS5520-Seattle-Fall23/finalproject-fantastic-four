import 'package:flutter/foundation.dart';
import 'package:sweetpet/model/userModel.dart';

class UserProvider extends ChangeNotifier {
  UserModel? _user; // 当前登录的用户

  UserModel? get user => _user;

  void setUser(UserModel user) {
    _user = user;
    notifyListeners();
  }

  void clearUser() {
    _user = null;
    notifyListeners();
  }
}
