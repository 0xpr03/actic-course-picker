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

class LoginWidget extends StatefulWidget {
  final http.Client? httpClient;

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
    var data = context.watch<AccountModel>();
    var formData = LoginModel();

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
                    data.loginData = formData;
                    var result = await widget.httpClient!.post(
                        Uri.parse('https://webapi.actic.se/login'),
                        body: json.encode(formData),
                        headers: {'content-type': 'application/json'});
                    if (result.statusCode == 200) {
                      try {
                        final parsed = json.decode(result.body);
                        final loginData = LoginData.fromJson(parsed);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Welcome ${loginData.firstName}')));
                        data.token = loginData.accessToken;
                        await data.storeToPrefs();
                        await Navigator.of(context)
                            .pushReplacementNamed('/home');
                      } catch (e) {
                        dialogHelper('Failed to parse login data: $e', context);
                      }

                      //_showDialog('Successfully signed in.');
                      //_showDialog('Unable to sign in.');
                    } else {
                      dialogHelper('Something went wrong. ${result.statusCode}',
                          context);
                      //_showDialog('Something went wrong. Please try again.');
                    }
                    //Navigator.pushReplacementNamed(context, '/catalog');
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
