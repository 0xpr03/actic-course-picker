import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';

import '../common/storage.dart';
import 'account.dart';

class AccountState extends ChangeNotifier {
  LoginData? _loginData;
  AccountData? _accountData;

  AccountState(this._loginData, this._accountData);

  LoginData? get login => _loginData;
  AccountData? get account => _accountData;

  set loginData(LoginData newLogin) {
    _loginData = newLogin;
    notifyListeners();
  }

  set accountData(AccountData accountData) {
    _accountData = accountData;
    notifyListeners();
  }

  /// Store model to preferences
  Future<void> storeToPrefs() async {
    await loginDataToPrefs(login);
    await accountDataToPrefs(account);
  }
}

@JsonSerializable()
class LoginData {
  LoginData({this.username, this.password});
  String? username;
  String? password;

  Map<String, dynamic> toJson() => {
        'username': username,
        'password': password,
      };

  LoginData.fromJson(Map<String, dynamic> json)
      : username = json['username'],
        password = json['password'];
}

/// Load model data from preferences
Future<AccountState> loadFromPrefs() async {
  final llogin = await loginDataFromPrefs();
  final lacc = await accountDataFromPrefs();
  print('Loaded $llogin $lacc');
  var model = AccountState(llogin, lacc);
  if (llogin != null) {
    model.loginData = llogin;
  }
  if (lacc != null) {
    model.accountData = lacc;
  }
  return model;
}
