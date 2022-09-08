// Copyright 2020 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:convert';

import 'package:actic_booking/models/account.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../models/login.dart';
import 'dialog.dart';

class LogoutWidget extends StatefulWidget {
  final http.Client? httpClient;

  const LogoutWidget({
    this.httpClient,
    super.key,
  });

  @override
  LogoutWidgetState createState() => LogoutWidgetState();
}

class LogoutWidgetState extends State<LogoutWidget> {
  @override
  Widget build(BuildContext context) {
    var data = context.watch<AccountModel>();

    return Scaffold(
      body: Text('Logout'),
    );
  }
}
