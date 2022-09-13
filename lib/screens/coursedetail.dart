import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../models/classes.dart';
import '../models/state.dart';

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
  Course? courseRef;

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) async {
    //   final args =
    //       ModalRoute.of(context)!.settings.arguments as ScreenArguments;
    //   coaurseRef = args.course;
    // });
  }

  @override
  Widget build(BuildContext context) {
    if (courseRef == null) {
      final args =
          ModalRoute.of(context)!.settings.arguments as ScreenArguments;
      courseRef = args.course;
    }
    final Course course = courseRef!;
    var state = context.watch<AccountState>();
    Widget button;

    switch (course.bookingState) {
      case 'BOOKABLE':
        button = ElevatedButton.icon(
          onPressed: () async {
            final res = await book(state, course, widget.httpClient!);
            setState(() {
              courseRef = res;
            });
          },
          icon: const Icon(Icons.add),
          label: const Text('Book'),
        );
        break;
      case 'BOOKED':
        button = ElevatedButton.icon(
          onPressed: () async {
            final res = await unbook(state, course, widget.httpClient!);
            setState(() {
              courseRef!.unbookingIdCompound = null;
              courseRef!.bookedCount--;
              courseRef!.bookingState = 'BOOKABLE';
            });
          },
          icon: const Icon(Icons.remove),
          label: const Text('Unbook'),
        );
        break;
      case 'NOT_BOOKABLE_DATE':
      default:
        button = const Text("Can't book this course");
    }

    return Scaffold(
        appBar: AppBar(
          shadowColor: null,
          elevation: 0,
          title: Text(course.name),
        ),
        body: SafeArea(
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                    child: Column(
                  children: [
                    button,
                    Text(course.startTime),
                    Text('${course.instructorNames}'),
                    Text(course.bookingState),
                    Text('${course.bookedCount} / ${course.classCapacity}'),
                    const Divider(),
                    Text('${course.description}'),
                  ],
                )))));
  }
}
