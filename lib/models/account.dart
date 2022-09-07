import 'package:flutter/cupertino.dart';

class AccountModel extends ChangeNotifier {
  late LoginModel _loginData;
  String? _accessToken;

  LoginModel get login => _loginData;

  String? get token => _accessToken;

  set loginData(LoginModel newLogin) {
    _loginData = newLogin;
    notifyListeners();
  }

  set accesstoken(String accesstoken) {
    _accessToken = accesstoken;
    notifyListeners();
  }
}

class LoginModel {
  late String username;
  late String password;
}
