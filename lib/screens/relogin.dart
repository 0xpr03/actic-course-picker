// Copyright 2020 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:convert';

import 'package:actic_booking/models/state.dart';
import 'package:actic_booking/screens/login.dart';
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
  bool finished = false;

  @override
  Widget build(BuildContext context) {
    var accountState = Provider.of<AccountState>(context, listen: false);
    return Scaffold(
      body: FutureBuilder<JSON>(
          future: fetchLogin(accountState.login, http.Client()),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                // can't keep the original login thingy..
                // otherwise would have to re-initialize possible courses view
                Navigator.of(context).pushNamedAndRemoveUntil(
                    LoginWidget.routeName, (route) => false);
              });
              return const Center(
                child: Text('An error has occurred logging in!'),
              );
            } else if (snapshot.hasData) {
              if (!finished) {
                final AccountData loginData =
                    AccountData.fromAPIJson(snapshot.data!);
                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  accountState.accountData = loginData;
                  accountState.storeToPrefs();
                  if (mounted) {
                    Navigator.of(context).pop();
                  }
                });
                finished = true;
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
