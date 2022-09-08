import 'package:actic_booking/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
//import 'package:window_size/window_size.dart';

import 'common/theme.dart';
import 'models/account.dart';
import 'screens/home.dart';
import 'screens/logout.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var state = await loadFromPrefs();
  //setupWindow();
  runApp(MyApp(
    model: state,
  ));
}

const double windowWidth = 360;
const double windowHeight = 640;

// void setupWindow() {
//   if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
//     WidgetsFlutterBinding.ensureInitialized();
//     setWindowTitle('Provider Counter');
//     setWindowMinSize(const Size(windowWidth, windowHeight));
//     setWindowMaxSize(const Size(windowWidth, windowHeight));
//     getCurrentScreen().then((screen) {
//       setWindowFrame(Rect.fromCenter(
//         center: screen!.frame.center,
//         width: windowWidth,
//         height: windowHeight,
//       ));
//     });
//   }
// }

class MyApp extends StatelessWidget {
  final AccountModel model;
  const MyApp({required this.model, super.key});

  @override
  Widget build(BuildContext context) {
    final String initialRoute;
    if (model.token != null) {
      initialRoute = '/home';
    } else {
      initialRoute = '/login';
    }

    return ChangeNotifierProvider(
        create: (context) => model,
        child: MaterialApp(
          title: 'Actic Course Booking',
          theme: appTheme,
          initialRoute: initialRoute,
          routes: {
            '/home': (context) => HomeWidget(httpClient: http.Client()),
            '/login': (context) => LoginWidget(httpClient: http.Client()),
            '/logout': (context) => LogoutWidget(httpClient: http.Client())
          },
        ));
  }
}
