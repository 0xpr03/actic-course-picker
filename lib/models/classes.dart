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
}

typedef ClassesFutureValue = Tuple2<Map<String, List<Course>>, JSON>;

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

  // otherwise we will try to parse HTML 401 unathorized as json..
  if (result.statusCode >= 400) {
    throw ApiLoginInvalidException('status code $result.statusCode');
  }

  return compute(parseClasses, result.body);
}

Future<Course> book(
    AccountState state, Course course, http.Client client) async {
  // POST
  final url =
      'https://webapi.actic.se/persons/${state.account!.userId}/participations/${course.bookingIdCompound}';
  final result = await client.post(
      Uri.parse(
        url,
      ),
      headers: {
        'Access-Token': state.account!.accessToken,
      });
  return await compute((value) {
    final decoded = json.decode(value);
    if (kDebugMode) {
      print(decoded);
    }
    if (isLoggedOut(decoded)) {
      throw ApiLoginInvalidException('logged out');
    }
    assertSuccess(decoded);
    return Course.fromJson(decoded['classData']!);
  }, result.body);
}

Future<void> unbook(
    AccountState state, Course course, http.Client client) async {
  if (course.unbookingIdCompound == null) {
    throw Exception(
        'No unbookingIdCompound for course ${course.bookingIdCompound}');
  }
  // POST
  final url =
      'https://webapi.actic.se/persons/${state.account!.userId}/participations/${course.bookingIdCompound}/${course.unbookingIdCompound}';
  final result = await client.delete(
      Uri.parse(
        url,
      ),
      headers: {
        'Access-Token': state.account!.accessToken,
      });
  return await compute((value) {
    final decoded = json.decode(value);
    if (kDebugMode) {
      print(decoded);
    }
    if (isLoggedOut(decoded)) {
      throw ApiLoginInvalidException('logged out');
    }
    assertSuccess(decoded);
    return decoded;
  }, result.body);
}

Tuple2<Map<String, List<Course>>, JSON> parseClasses(String responseBody) {
  final decoded = json.decode(responseBody);
  if (isLoggedOut(decoded)) {
    throw ApiLoginInvalidException('logged out');
  }
  final JSON coursesRaw = decoded["classes"];
  final courses = coursesRaw.map<String, List<Course>>((k, v) {
    return MapEntry(k, v.map<Course>((json) => Course.fromJson(json)).toList());
  });
  return Tuple2(courses, decoded);
}

class Course {
  String name;
  String startTime;

  /// BOOKED BOOKABLE BOOKABLE_WAITINGLIST NOT_BOOKABLE_DATE
  String bookingState;
  String? description;
  int classCapacity;
  int bookedCount;
  int duration;
  int timestamp;
  String? instructorNames;

  /// ID for booking, essentially '{json['bookingId']['center']}p{json['bookingId']['id']}'
  String bookingIdCompound;
  String? unbookingIdCompound;

  Course.fromJson(JSON json)
      : name = json['name'],
        startTime = json['startTime'],
        bookingState = json['bookingState'],
        bookingIdCompound = json['bookingIdCompound'],
        description = json['description'],
        classCapacity = json['classCapacity'],
        bookedCount = json['bookedCount'],
        duration = json['duration'],
        timestamp = json['timestamp'],
        instructorNames = json['instructorNames'],
        unbookingIdCompound = _unbookingIdCompound(json);
}

String? _unbookingIdCompound(JSON json) {
  final participation = json['participation'];
  if (participation != null) {
    final participationId = participation['participationId'];
    if (participationId != null) {
      return '${participationId['center']}p${participationId['id']}';
    }
  }
  return null;
}
