import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:window_size/window_size.dart';

import 'common/theme.dart';
import 'models/classes.dart';
import 'models/state.dart';
import 'screens/login.dart';
import 'screens/coursedetail.dart';
import 'screens/courses.dart';
import 'screens/logout.dart';
import 'screens/relogin.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var state = await loadFromPrefs();
  setupWindow();
  runApp(MyApp(
    model: state,
  ));
}

const double windowWidth = 360;
const double windowHeight = 640;

void setupWindow() {
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    WidgetsFlutterBinding.ensureInitialized();
    setWindowTitle('Actic Course Booking');
    setWindowMinSize(const Size(windowWidth, windowHeight));
    //setWindowMaxSize(const Size(windowWidth, windowHeight));
    getCurrentScreen().then((screen) {
      setWindowFrame(Rect.fromCenter(
        center: screen!.frame.center,
        width: windowWidth,
        height: windowHeight,
      ));
    });
  }
}

class MyApp extends StatelessWidget {
  final AccountState model;
  const MyApp({required this.model, super.key});

  @override
  Widget build(BuildContext context) {
    final String initialRoute;
    if (model.account != null) {
      initialRoute = CoursesOverviewWidget.routeName;
    } else {
      initialRoute = LoginWidget.routeName;
    }

    return MultiProvider(
        providers: [
          ChangeNotifierProvider<AccountState>(
            create: (context) => model,
          ),
          ChangeNotifierProvider<Classes>(
            create: (context) => Classes(),
          )
        ],
        child: MaterialApp(
          title: 'Actic Course Booking',
          theme: appTheme,
          darkTheme: ThemeData.dark(), // standard dark theme
          themeMode: ThemeMode.system,
          initialRoute: initialRoute,
          routes: {
            CoursesOverviewWidget.routeName: (context) =>
                CoursesOverviewWidget(httpClient: http.Client()),
            CourseDetailWidget.routeName: (context) =>
                CourseDetailWidget(httpClient: http.Client()),
            LoginWidget.routeName: (context) =>
                LoginWidget(httpClient: http.Client()),
            LogoutWidget.routeName: (context) =>
                LogoutWidget(httpClient: http.Client()),
            ReLoginWidget.routeName: (context) =>
                ReLoginWidget(httpClient: http.Client())
          },
        ));
  }
}
