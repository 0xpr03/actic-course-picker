import 'dart:convert';

import 'package:actic_booking/models/account.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/login.dart';

const loginData = 'login_data';
const accessToken = 'access_token';

Future<LoginModel?> loginFromPrefs() async {
  final prefs = await SharedPreferences.getInstance();

  final String? dataRaw = prefs.getString(loginData);
  if (dataRaw != null) {
    final decoded = json.decode(dataRaw);
    if (decoded != null) {
      final data = LoginModel.fromJson(decoded);
      return data;
    }
  }
  return null;
}

Future<void> loginToPrefs(LoginModel? model) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(loginData, json.encode(model?.toJson()));
}

Future<String?> tokenFromPrefs() async {
  final prefs = await SharedPreferences.getInstance();

  return prefs.getString(accessToken);
}

Future<void> tokenToPrefs(String? token) async {
  if (token == null) return;
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(accessToken, token);
}
