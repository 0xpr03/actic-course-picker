import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/classes.dart';

class ScreenArguments {
  final Course course;

  ScreenArguments(this.course);
}

class CourseDetailWidget extends StatefulWidget {
  final http.Client? httpClient;

  static const routeName = '/coursedetail';

  const CourseDetailWidget({
    this.httpClient,
    super.key,
  });

  @override
  CourseDetailWidgetState createState() => CourseDetailWidgetState();
}

class CourseDetailWidgetState extends State<CourseDetailWidget> {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ScreenArguments;

    return Scaffold(
        appBar: AppBar(
          shadowColor: null,
          elevation: 0,
          title: Text(args.course.name),
        ),
        body: SafeArea(
            child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(
                    child: Column(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() async {});
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Book'),
                    ),
                    Text(args.course.startTime),
                    Text('${args.course.instructorNames}'),
                    Text(args.course.bookingState),
                    Text(
                        '${args.course.bookedCount} / ${args.course.classCapacity}'),
                    Divider(),
                    Text('${args.course.description}'),
                  ],
                )))));
  }
}
