// Copyright 2020 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:convert';

import 'package:actic_booking/models/state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../models/account.dart';
import 'dialog.dart';

class HomeWidget extends StatefulWidget {
  final http.Client? httpClient;

  const HomeWidget({
    this.httpClient,
    super.key,
  });

  @override
  HomeWidgetState createState() => HomeWidgetState();
}

class HomeWidgetState extends State<HomeWidget> {
  @override
  Widget build(BuildContext context) {
    var data = context.watch<AccountState>();

    return Scaffold(
      body: Text('Home'),
    );
  }
}
