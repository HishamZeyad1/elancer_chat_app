// import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:elancer_chat_app/screens/app/main_screen.dart';
import 'package:elancer_chat_app/screens/auth/forget_password_screen.dart';
import 'package:elancer_chat_app/screens/auth/login_screen.dart';
import 'package:elancer_chat_app/screens/auth/register_screen.dart';
import 'package:elancer_chat_app/screens/launch_screen.dart';
import 'package:elancer_chat_app/utils/fb_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'controllers/notification_controller.dart';
import 'firebase_options.dart';
import 'dart:io';

void main() async {
  print("object");
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FbNotifications.initNotifications();
  // Pass all uncaught "fatal" errors from the framework to Crashlytics
// Always initialize Awesome Notifications
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
// The navigator key is necessary to navigate using static methods
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          navigatorKey: MyApp.navigatorKey,
          debugShowCheckedModeBanner: false,
          initialRoute: '/launch_screen',
          routes: {
            '/launch_screen': (BuildContext) => LaunchScreen(),
            '/login_screen': (BuildContext) => LoginScreen(),
            '/register_screen': (BuildContext) => RegisterScreen(),
            '/forget_password_screen': (BuildContext) => ForgetPasswordScreen(),
            '/main_screen': (BuildContext) => MainScreen()
          },
        );
      },
    );
  }
}

// class MyHttpOverrides extends HttpOverrides {
//   @override
//   HttpClient createHttpClient(SecurityContext? context) {
//     return super.createHttpClient(context)
//       ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
//   }
// }
