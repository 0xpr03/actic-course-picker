import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

import '../common/api.dart';
import 'state.dart';
import 'package:http/http.dart' as http;

class Classes extends ChangeNotifier {
  DateTime updated = DateTime.fromMillisecondsSinceEpoch(0);

  String from = 'Loading';
  String to = 'Loading';

  Map<String, List<Course>> courses = {};

  update(String newFrom, String newTo, Map<String, List<Course>> newCourses) {
    courses = newCourses;
    from = newFrom;
    to = newTo;
    updated = DateTime.now();
    //notifyListeners();
  }

  void book(AccountState model, Course course) async {
    // POST
    final url =
        'https://webapi.actic.se/persons/${model.account!.userId}/participations/${course.bookingIdCompound}';
  }
}

typedef ClassesFutureValue
    = Tuple2<Map<String, List<Course>>, Map<String, dynamic>>;

Future<ClassesFutureValue> fetchClasses(
    String token, String userId, int centerId, http.Client client) async {
  // get
  final url =
      'https://webapi.actic.se/persons/${userId}/centers/${centerId}/classes';

  final result = await client.get(
      Uri.parse(
        url,
      ),
      headers: {
        'Access-Token': token,
      });

  return compute(parseClasses, result.body);
}

Tuple2<Map<String, List<Course>>, Map<String, dynamic>> parseClasses(
    String responseBody) {
  final decoded = json.decode(responseBody);
  if (isLoggedOut(decoded)) {
    throw ApiLoginInvalidException();
  }
  final Map<String, dynamic> coursesRaw = decoded["classes"];
  final courses = coursesRaw.map<String, List<Course>>((k, v) {
    return MapEntry(k, v.map<Course>((json) => Course.fromJson(json)).toList());
  });
  return Tuple2(courses, decoded);
}

class Course {
  Course(this.name, this.startTime, this.bookingState, this.bookingIdCompound);
  String name;
  String startTime;
  String bookingState; // BOOKED BOOKABLE BOOKABLE_WAITINGLIST NOT_BOOKABLE_DATE

  /// ID for booking
  String bookingIdCompound;

  Course.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        startTime = json['startTime'],
        bookingState = json['bookingState'],
        bookingIdCompound = json['bookingIdCompound'];
}
