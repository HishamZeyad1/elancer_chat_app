import 'package:elancer_chat_app/screens/app/main_screen.dart';
import 'package:elancer_chat_app/screens/auth/forget_password_screen.dart';
import 'package:elancer_chat_app/screens/auth/login_screen.dart';
import 'package:elancer_chat_app/screens/auth/register_screen.dart';
import 'package:elancer_chat_app/screens/launch_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'firebase_options.dart';

void main() async{
  print("object");
  WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp(
     options: DefaultFirebaseOptions.currentPlatform,
   );
  // Pass all uncaught "fatal" errors from the framework to Crashlytics
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute:'/launch_screen',
        routes: {
          '/launch_screen':(BuildContext)=>LaunchScreen(),
          '/login_screen':(BuildContext)=>LoginScreen(),
          '/register_screen':(BuildContext)=>RegisterScreen(),
          '/forget_password_screen':(BuildContext)=>ForgetPasswordScreen(),
          '/main_screen':(BuildContext)=>MainScreen()
        },
      );},
    );
  }
}
