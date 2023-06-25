import 'dart:io';

import 'package:elancer_chat_app/controllers/fb_auth_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class Setting extends StatefulWidget {
  const Setting({Key? key}) : super(key: key);

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  bool _notificationStatus = false;
  bool _darkThemeMode = false;
  late User _user;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _user=FbAuthController().user;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            //shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            children: [
              Row(
                // mainAxisAlignment: MainAxisAlignment.start,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 35.w,
                    backgroundColor: Colors.grey.shade200,
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _user.displayName??"User Name",
                        style: GoogleFonts.acme(
                            fontSize: 16.sp, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        _user.email??"user@gmail.com",
                        style: GoogleFonts.acme(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w300,
                            color: Colors.black45),
                      ),
                    ],
                  )
                ],
              ),
              Divider(
                height: 40.h,
                thickness: 1,
              ),
              Text(
                "App Settings",
                style: GoogleFonts.acme(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                    color: Colors.black),
              ),
              SwitchListTile(
                value: _notificationStatus,
                onChanged: (value) {
                  // throw Exception();
                  setState((){
                    _notificationStatus = !_notificationStatus;
                  });
                },
                selected: _notificationStatus,
                title: Text(
                  "Notification",
                ),
                subtitle: Text("Enable/Disable Notifications"),
              ),
              SwitchListTile(
                value: _darkThemeMode,
                onChanged: (value) {
                  setState(() {
                    _darkThemeMode = !_darkThemeMode;
                  });
                },
                selected: _darkThemeMode,
                title: Text(
                  "Dark Theme Mode",
                ),
                subtitle: Text("Light/Dark Theme"),
              ),
              Divider(
                thickness: 1,
                height: 40.h,
              ),
              Text(
                "User Settings",
                style: GoogleFonts.acme(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                    color: Colors.black),
              ),
              ListTile(
                leading: Icon(Icons.block),
                title: Text("Blocked Accounts"),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 14.w,
                ),
              ),
              ListTile(
                leading: Icon(Icons.language),
                title: Text("Language"),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 14.w,
                ),
              ),
              ListTile(
                leading: Icon(Icons.info),
                title: Text("About App"),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 14.w,
                ),
              ),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text("Logout"),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 14.w,
                ),
                onTap: () async => await _confirmLogoutDialog(),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8.0),
          color: Colors.grey.shade300,
          alignment: Alignment.center,
          child: Text(
            "Version: 1.0.0 - 2023",
            style: GoogleFonts.acme(
                fontSize: 13.sp,
                fontWeight: FontWeight.w100,
                color: Colors.black45),
          ),
        ),
        // SizedBox(height: 10.h,)
      ],
    );
  }

  Future<void> _confirmLogoutDialog() async {
    bool? confirmStatus = await showDialog<bool>(
      context: context,
      builder: (context) {
        return Platform.isAndroid
            ? AlertDialog(
                title: Text("Are you sure?"),
                content: Text("Do you want to logout from app?"),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: Text("Yes"),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: Text("No"),
                  ),
                ],
              )
            : CupertinoAlertDialog(
                title: Text("Are you sure?"),
                content: Text("Do you want to logout from app?"),
                actions: [
                  TextButton(
                    onPressed: ()async=> await FbAuthController().signOut(),
                    child: Text("Yes"),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: Text("No"),
                  ),
                ],
              );
      },
    );
    print(confirmStatus);
    if(confirmStatus??false){
      bool signedOut = await FbAuthController().signOut();
      if (signedOut) {
        Navigator.pushReplacementNamed(context, '/login_screen');
      }
    }
  }

}
