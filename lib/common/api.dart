import 'package:flutter/foundation.dart';
import 'dart:convert';

import 'package:http/http.dart';

import '../models/state.dart';

typedef JSON = Map<String, dynamic>;

bool isLoggedOut(JSON json) {
  var error = json["error"];
  return error != null && error == "NotAuthorized";
}

/// Verify that a success:true is set otherwise throws
void assertSuccess(JSON json) {
  bool? success = json['success'];
  if (success == null || !success) {
    String? details = json['error'];
    throw ApiNoSuccessException(success, details);
  }
}
// success":false,"error":"NotAuthorized

Future<JSON> fetchLogin(LoginData login, Client client) async {
  final result = await client.post(Uri.parse('https://webapi.actic.se/login'),
      body: json.encode(login), headers: {'content-type': 'application/json'});

  return compute((value) {
    return json.decode(result.body);
  }, result);
}

class ApiLoginInvalidException implements Exception {}

class ApiNoSuccessException implements Exception {
  final bool? success;
  final String? error;

  String get message => 'Expected success response, got $success with $error';

  ApiNoSuccessException(this.success, this.error);
}
