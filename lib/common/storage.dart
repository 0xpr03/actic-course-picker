import 'dart:convert';

import 'package:actic_booking/models/state.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/account.dart';

const loginData = 'login_data';
const accountData = 'account_data';
const storeLogin = 'store_login';

Future<LoginData?> loginDataFromPrefs() async {
  final prefs = await SharedPreferences.getInstance();

  final String? dataRaw = prefs.getString(loginData);
  if (dataRaw != null) {
    final decoded = json.decode(dataRaw);
    if (decoded != null) {
      final data = LoginData.fromJson(decoded);
      return data;
    }
  }
  return null;
}

Future<void> loginDataToPrefs(LoginData? model) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(loginData, json.encode(model?.toFullJson()));
}

Future<void> accountDataToPrefs(AccountData? model) async {
  final prefs = await SharedPreferences.getInstance();
  if (model == null) {
    await prefs.remove(accountData);
  } else {
    await prefs.setString(accountData, json.encode(model.toJson()));
  }
}

Future<AccountData?> accountDataFromPrefs() async {
  final prefs = await SharedPreferences.getInstance();

  final String? dataRaw = prefs.getString(accountData);
  if (dataRaw != null) {
    final decoded = json.decode(dataRaw);
    if (decoded != null) {
      final data = AccountData.fromJson(decoded);
      return data;
    }
  }
  return null;
}
