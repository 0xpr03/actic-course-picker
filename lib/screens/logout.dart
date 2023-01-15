// Copyright 2020 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:convert';

import 'package:actic_booking/models/state.dart';
import 'package:actic_booking/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../models/account.dart';
import '../common/dialog.dart';

class LogoutWidget extends StatefulWidget {
  final http.Client? httpClient;

  static const routeName = '/logout';

  const LogoutWidget({
    this.httpClient,
    super.key,
  });

  @override
  LogoutWidgetState createState() => LogoutWidgetState();
}

class LogoutWidgetState extends State<LogoutWidget> {
  bool initialized = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var state = Provider.of<AccountState>(context, listen: false);
    if (!initialized) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        state.removeAccountData().then((value) =>
            Navigator.of(context).pushReplacementNamed(LoginWidget.routeName));
      });
      initialized = true;
    }
    return const Scaffold(
      body: Text('Logging out..'),
    );
  }
}
