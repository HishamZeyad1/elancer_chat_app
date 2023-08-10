import 'dart:convert';

// import 'package:audioplayers/audioplayers.dart';
// import 'package:audioplayers/audioplayers.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:elancer_chat_app/utils/audioplayer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

// typedef BackgroundMessageHandler = Future<void> Function(RemoteMessage message);
Future<void> firebaseMessagingBackgroundHandler(
    RemoteMessage remoteMessage) async {
  //BACKGROUND Notifications - iOS & Android
  await Firebase.initializeApp();
  print('Message: ${remoteMessage.messageId}');
  // AwesomeNotifications().createNotification(
  //   content: NotificationContent(
  //     id: 1,
  //     channelKey: "call channel",
  //     title: remoteMessage.notification!.title,
  //     body:remoteMessage.notification!.body,
  //   ),
  // );

}

// late AndroidNotificationChannel channel;
// late FlutterLocalNotificationsPlugin localNotificationsPlugin;

// List<int> myVibrationPattern = [100, 5000, 300, 9000];
// // Convert the List<int> to Int64List
// Int64List myVibrationPatternInt64 = Int64List.fromList(myVibrationPattern);

// AudioPlayer audioPlayer = AudioPlayer();

final String serverToken =
    "AAAAoLFSvlA:APA91bErcdYytSaKkv5YMP9d5dWu1kKHQqXtxMzRFXTddHi6bl-e0YLH-ZJyQZNnYzbktTnzQtFEGWGPsdeclEkPKcD0HRv9eqhbM-35WxZCBqyjOycIpPiBZGD06QB3Lzkq-lyODiVd"; //'AAAAbzRpdjY:APA91bFMniaxvu1MpX5eyAJAWi_RgDQS3Pq3Zi1lSaFujasohdKhjXt9R1L3QxUF9BdxVqFf4EU2eqbxq36jpcNgrTqtZ3k54zTkJuDAPKY79D2XGUrYDDnO5HfCn-u5WvCczNLst0Xi';
mixin FbNotifications {
  /// CALLED IN main function between ensureInitialized <-> runApp(widget);
  static Future<void> initNotifications() async {
    //Connect the previous created function with onBackgroundMessage to enable
    //receiving notification when app in Background.
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    await AwesomeNotifications().initialize(null, [
      NotificationChannel(
        channelKey: "call channel",
        channelName: "call channel",
        channelDescription: "call channel des",
        channelShowBadge: true,
        playSound: true,
      )
    ]);

    // //Channel
    // if (!kIsWeb) {
    //   channel = const AndroidNotificationChannel(
    //     'FLUTTER_NOTIFICATION_CLICK',
    //     'FLUTTER_NOTIFICATION_CLICK',
    //     description:
    //         'This channel will receive notifications specific to news-app',
    //     importance: Importance.high,
    //     enableLights: true,
    //     enableVibration: true,
    //     ledColor: Colors.orange,
    //     showBadge: true,
    //     playSound: true,
    //   );
    //   print("channel");
    // }
    //
    // //Flutter Local Notifications Plugin (FOREGROUND) - ANDROID CHANNEL
    //
    // localNotificationsPlugin = FlutterLocalNotificationsPlugin();
    // await localNotificationsPlugin
    //     .resolvePlatformSpecificImplementation<
    //         AndroidFlutterLocalNotificationsPlugin>()
    //     ?.createNotificationChannel(channel);

    //iOS Notification Setup (FOREGROUND)
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  //iOS Notification Permission
  Future<void> requestNotificationPermissions() async {
    print('requestNotificationPermissions');
    NotificationSettings notificationSettings =
        await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      carPlay: false,
      announcement: false,
      provisional: false,
      criticalAlert: false,
    );
    if (notificationSettings.authorizationStatus ==
        AuthorizationStatus.authorized) {
      print('GRANT PERMISSION');
    } else if (notificationSettings.authorizationStatus ==
        AuthorizationStatus.denied) {
      print('Permission Denied');
    }
  }

  //ANDROID
  void initializeForegroundNotificationForAndroid() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: 1,
            channelKey: "call channel",
            title: message.notification!.title,
            body:message.notification!.body,
        ),
      );
      // print('Message Received: ${message.messageId}');
      // RemoteNotification? notification = message.notification;
      // AndroidNotification? androidNotification = notification?.android;
      // if (notification != null && androidNotification != null) {
      //   localNotificationsPlugin.show(
      //     notification.hashCode,
      //     notification.title,
      //     notification.body,
      //     NotificationDetails(
      //       android: AndroidNotificationDetails(
      //         channel.id,
      //         channel.name,
      //         channelDescription: channel.description,
      //         // vibrationPattern:myVibrationPatternInt64,
      //         icon: 'launch_background',
      //         fullScreenIntent: true,
      //         // Show as heads-up notification on Android
      //         showWhen: false,
      //         ongoing: true, // Set to true to make the notification non-dismissable
      //         autoCancel: false,
      //
      //         actions: [
      //           AndroidNotificationAction(
      //             "accept",
      //             "Accept",),
      //           AndroidNotificationAction(
      //             "decline",
      //             "Decline",
      //           ),
      //         ],
      //       ),
      //     ),
      //   );
      //   showNotificationMusicAndHideAfter30Seconds(notification.hashCode);
      // }
      // Show the notification
    });
  }

  void configureFCM({required BuildContext context}) {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("FCM Message Received: ${message.notification?.body}");

      // showDialog(
      //   context: context,
      //   builder: (context) => AlertDialog(
      //     title: Text('Incoming Notification'),
      //     content: Text(message.notification?.body ?? ''),
      //     actions: [
      //       TextButton(
      //         onPressed: () {
      //           // Handle the Accept action
      //         },
      //         child: Text('Accept'),
      //       ),
      //       TextButton(
      //         onPressed: () {
      //           // Handle the Decline action
      //         },
      //         child: Text('Decline'),
      //       ),
      //     ],
      //   ),
      // );

      // Show the custom notification with action buttons
      initializeForegroundNotificationForAndroid();
    });
  }

  // void showNotificationMusicAndHideAfter30Seconds(int id) async {
  //   Future.delayed(Duration(seconds: 60), () {
  //     localNotificationsPlugin.cancel(id); // Hide the notification with ID 0
  //     AudPlayer().stopRingtone();
  //   });
  //   await AudPlayer().playRingtone();
  //   // Schedule hiding the notification after 30 seconds
  // }

  //GENERAL (Android & iOS)
  void manageNotificationAction() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _controlNotificationNavigation(message.data);
    });
  }

  void _controlNotificationNavigation(Map<String, dynamic> data) {
    print('Data: $data');
    if (data['page'] != null) {
      switch (data['page']) {
        case 'products':
          var productId = data['id'];
          print('Product Id: $productId');
          break;

        case 'settings':
          print('Navigate to settings');
          break;

        case 'profile':
          print('Navigate to Profile');
          break;
      }
    }
  }

  sendNotify(String title, String body, String id) async {
    // var url=Uri(scheme:'https',host:'fcm.googleapis.com',path:'fcm/send',);
    var url = Uri.parse("https://fcm.googleapis.com/fcm/send");
    print("Start Sending Notification");
    String? token = await FirebaseMessaging.instance.getToken();
    print(token);
    try {
      await http.post(
        url /*Uri('https://fcm.googleapis.com/fcm/send')*/,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverToken',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{'body': body, 'title': title},
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': id.toString(),
              'status': 'done'
            },
            'to': await FirebaseMessaging.instance
                .getToken() /*'/topics/ProgramingChannel'*/,
          },
        ),
      );
      print("End Sending Notification");
    } catch (error) {
      print("============error==============");
      print(error.toString());
    }
  }
}
