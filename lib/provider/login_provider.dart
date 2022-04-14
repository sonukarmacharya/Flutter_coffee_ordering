import 'package:flutter/cupertino.dart';

class LoginProvider with ChangeNotifier {
  String email = "";
  String password = "";

  saveLoginResponse({required String email, required String pass}) {
    email = email;
    password = pass;
    notifyListeners();
  }

  clearLogin() {
    email = "";
    password = "";
    notifyListeners();
  }
}
