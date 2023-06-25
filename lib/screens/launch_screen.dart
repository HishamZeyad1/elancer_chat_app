import 'dart:async';

import 'package:elancer_chat_app/controllers/fb_auth_controller.dart';
import 'package:elancer_chat_app/screens/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class LaunchScreen extends StatefulWidget {
  const LaunchScreen({Key? key}) : super(key: key);

  @override
  State<LaunchScreen> createState() => _LaunchScreenState();
}

class _LaunchScreenState extends State<LaunchScreen> {
  late StreamSubscription _streamSubscription;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(Duration(seconds: 3),
    () {
    //Solution 1
    //   _streamSubscription =
    //       FbAuthController().checkUserStatus(authStateCallback: (loggedIn) =>
    //           Navigator.pushReplacementNamed(context, '/login_screen'),);

    // Solution 2
      Navigator.pushReplacementNamed(context, FbAuthController().loggedIn?'/main_screen':'/login_screen');

    });



  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: InkWell(
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: AlignmentDirectional.topStart,
              end: AlignmentDirectional.bottomEnd,
              colors: <Color>[
                Colors.pink.shade100,
                Colors.blue.shade100,
              ],
            ),
          ),
          child: Text(
            "CHAT",
            style: GoogleFonts.lato(
              fontWeight: FontWeight.bold,
              fontSize: 30.sp,
            ),
          ),
        ),
      ),
    );
  }
}
