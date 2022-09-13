// Copyright 2020 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:convert';

import 'package:actic_booking/models/state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../common/api.dart';
import '../models/account.dart';
import '../common/dialog.dart';

class ReLoginWidget extends StatefulWidget {
  final http.Client? httpClient;

  static const routeName = '/relogin';

  const ReLoginWidget({
    this.httpClient,
    super.key,
  });

  @override
  ReLoginWidgetState createState() => ReLoginWidgetState();
}

class ReLoginWidgetState extends State<ReLoginWidget> {
  @override
  Widget build(BuildContext context) {
    var accountState = context.watch<AccountState>();

    return Scaffold(
      body: FutureBuilder<JSON>(
          future: fetchLogin(accountState.login!, http.Client()),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              accountState.removeLoginData();
              return const Center(
                child: Text('An error has occurred logging in!'),
              );
            } else if (snapshot.hasData) {
              final AccountData loginData =
                  AccountData.fromAPIJson(snapshot.data!);
              accountState.accountData = loginData;
              accountState.storeToPrefs();
              if (mounted) {
                Navigator.of(context).pop();
              }
              return const Center(child: Text('Finished'));
            } else {
              return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text('Logging in..'),
                    CircularProgressIndicator(),
                  ]);
            }
          }),
    );
  }
}
