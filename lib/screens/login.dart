// Copyright 2020 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:convert';

import 'package:actic_booking/models/state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../models/account.dart';
import '../common/dialog.dart';
import 'courses.dart';

class LoginWidget extends StatefulWidget {
  final http.Client? httpClient;

  static const routeName = '/login';

  const LoginWidget({
    this.httpClient,
    super.key,
  });

  @override
  LoginWidgetState createState() => LoginWidgetState();
}

class LoginWidgetState extends State<LoginWidget> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var accountState = context.watch<AccountState>();
    var formData = LoginData();

    return Scaffold(
        body: Form(
      key: _formKey,
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(80.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Please Login',
                style: Theme.of(context).textTheme.displayLarge,
              ),
              TextFormField(
                initialValue: accountState.login?.username,
                decoration: const InputDecoration(
                  hintText: 'Actic Email',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
                onChanged: (value) {
                  formData.username = value;
                },
              ),
              TextFormField(
                initialValue: accountState.login?.password,
                decoration: const InputDecoration(
                  hintText: 'Password',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
                onChanged: (value) {
                  formData.password = value;
                },
                obscureText: true,
              ),
              const SizedBox(
                height: 24,
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Processing Data')));
                    var result = await widget.httpClient!.post(
                        Uri.parse('https://webapi.actic.se/login'),
                        body: json.encode(formData),
                        headers: {'content-type': 'application/json'});
                    if (!mounted) return;
                    if (result.statusCode == 200) {
                      try {
                        final parsed = json.decode(result.body);
                        final AccountData loginData =
                            AccountData.fromAPIJson(parsed);
                        accountState.accountData = loginData;
                        accountState.loginData = formData;
                        await accountState.storeToPrefs();
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Welcome ${loginData.firstName}')));
                        await Navigator.of(context).pushReplacementNamed(
                            CoursesOverviewWidget.routeName);
                      } catch (e) {
                        dialogHelper('Failed to parse login data: $e', context);
                      }
                    } else {
                      dialogHelper('Something went wrong. ${result.statusCode}',
                          context);
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                ),
                child: const Text('Login'),
              )
            ],
          ),
        ),
      ),
    ));
  }
}
