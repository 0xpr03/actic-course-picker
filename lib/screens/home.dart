// Copyright 2020 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:convert';

import 'package:actic_booking/common/api.dart';
import 'package:actic_booking/models/state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:tuple/tuple.dart';

import '../models/account.dart';
import '../common/dialog.dart';
import '../models/classes.dart';

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
  late Future<ClassesFutureValue> _fetchFuture;
  final yourScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchFuture = fetch();
  }

  Future<ClassesFutureValue> fetch() async {
    final state = Provider.of<AccountState>(context, listen: false);
    var account = state.account!;
    return await fetchClasses(
        account.accessToken, account.userId, account.centerId, http.Client());
  }

  void refreshData() {
    // reload
    setState(() {
      _fetchFuture = fetch();
    });
  }

  Widget courseDayView(List<Course> courses) {
    return ListView.builder(
        controller: yourScrollController,
        physics:
            const AlwaysScrollableScrollPhysics(), // allow refresh with 0 elements
        itemCount: courses.length,
        itemBuilder: (context, index) {
          return CourseWidget(
            course: courses[index],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    var state = context.watch<AccountState>();
    var courses = context.watch<Classes>();

    return Scaffold(
        appBar: AppBar(title: const Text('Home')),
        drawer: Drawer(
            child: ListView(padding: EdgeInsets.zero, children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.blue,
            ),
            child:
                Text('${state.account!.firstName} ${state.account!.lastName}'),
          ),
          ListTile(
            title: const Text('Logout'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/logout');
            },
          ),
        ])),
        body: FutureBuilder<ClassesFutureValue>(
          future: _fetchFuture,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              if (snapshot.error! is ApiLoginInvalidException) {
                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  Navigator.of(context).pushNamed('/relogin');
                });
              }
              return const Center(
                child: Text('An error has occurred loading courses!'),
              );
            } else if (snapshot.hasData) {
              final data = snapshot.data!;
              courses.update(data.item2['from'], data.item2['to'], data.item1);
              return Scrollbar(
                  controller: yourScrollController,
                  child: RefreshIndicator(
                    child: courseDayView(data.item1['2022-09-11']!),
                    onRefresh: () {
                      refreshData();
                      return _fetchFuture;
                    },
                  ));
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ));
  }
}

class CourseWidget extends StatelessWidget {
  final Course course;
  const CourseWidget({required this.course, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
        child: ListTile(
      title: Text(course.name),
      subtitle: Text('${course.startTime}\n${course.bookingState}'),
      // trailing: Text(course.bookingState),
      leading: Text(course.startTime),
    ));
  }
}
