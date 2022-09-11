import 'package:flutter/foundation.dart';
import 'dart:convert';

import 'package:http/http.dart';

import '../models/state.dart';

bool isLoggedOut(Map<String, dynamic> json) {
  var error = json["error"];
  return error != null && error == "NotAuthorized";
}
// success":false,"error":"NotAuthorized

Future<Map<String, dynamic>> fetchLogin(LoginData login, Client client) async {
  final result = await client.post(Uri.parse('https://webapi.actic.se/login'),
      body: json.encode(login), headers: {'content-type': 'application/json'});

  return compute((value) {
    return json.decode(result.body);
  }, result);
}

class ApiLoginInvalidException implements Exception {}
