import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:elancer_chat_app/models/bn_screen.dart';
import 'package:elancer_chat_app/screens/app/bn_screens/chats_screen.dart';
import 'package:elancer_chat_app/screens/app/bn_screens/setting.dart';
import 'package:elancer_chat_app/screens/app/bn_screens/stories_screen.dart';
import 'package:elancer_chat_app/screens/app/bn_screens/users_screen.dart';
import 'package:elancer_chat_app/utils/fb_notifications.dart';

// import 'package:elancer_chat_app/utils/fb_notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with FbNotifications {
  int _selectedIndex = 0;
  List<BnScreen> bnScreens = [
    BnScreen(title: "Chats", widget: ChatsScreen()),
    BnScreen(title: "Users", widget: UsersScreen()),
    BnScreen(title: "Stories", widget: StoriesScreen()),
    BnScreen(title: "Setting", widget: Setting()),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // AwesomeNotifications().requestPermissionToSendNotifications();
    requestNotificationPermissions();
    initializeForegroundNotificationForAndroid();
    // configureFCM(context: context);
    // manageNotificationAction();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          // "Chats",
          bnScreens[_selectedIndex].title.toUpperCase(),
          style: GoogleFonts.acme(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: bnScreens[_selectedIndex].widget,

      // Center(
      //   child: Text(
      //     // "Chats",
      //     bnScreens[_selectedIndex].title,
      //     style: GoogleFonts.acme(
      //       fontWeight: FontWeight.bold,
      //     ),
      //   ),
      // ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.chat_outlined),
              activeIcon: Icon(Icons.chat),
              label: "Chats"),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: "users"),
          BottomNavigationBarItem(
              icon: Icon(Icons.motion_photos_on),
              activeIcon: Icon(Icons.motion_photos_on_sharp),
              label: "stories"),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined),
              activeIcon: Icon(Icons.settings),
              label: "setting"),
        ],
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        currentIndex: _selectedIndex,
        onTap: (value) {
          setState(() {
            _selectedIndex = value;
          });
        },
        // backgroundColor: Colors.grey,

        // selectedItemColor: ,
        // selectedIconTheme: ,
        // selectedFontSize: ,
      ),
    );
  }
}
