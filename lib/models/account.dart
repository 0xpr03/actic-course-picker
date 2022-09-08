import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';

import '../common/storage.dart';

class AccountModel extends ChangeNotifier {
  LoginModel? _loginData;
  String? _accessToken;

  AccountModel(String? accessToken, LoginModel? loginData) {
    _accessToken = accessToken;
    _loginData = loginData;
  }

  LoginModel? get login => _loginData;

  String? get token => _accessToken;

  set loginData(LoginModel newLogin) {
    _loginData = newLogin;
    notifyListeners();
  }

  /// Store model to preferences
  Future<void> storeToPrefs() async {
    await tokenToPrefs(token);
    await loginToPrefs(login);
  }

  set token(String? token) {
    _accessToken = token;
    notifyListeners();
  }
}

@JsonSerializable()
class LoginModel {
  LoginModel({this.username, this.password});
  String? username;
  String? password;

  Map<String, dynamic> toJson() => {
        'username': username,
        'password': password,
      };

  LoginModel.fromJson(Map<String, dynamic> json)
      : username = json['username'],
        password = json['password'];
}

/// Load model data from preferences
Future<AccountModel> loadFromPrefs() async {
  final lToken = await tokenFromPrefs();
  final lModel = await loginFromPrefs();
  print('Loaded $lToken $lModel');
  var model = AccountModel(lToken, lModel);
  if (lModel != null) {
    model.loginData = lModel;
  }
  model.token = lToken;
  return model;
}
