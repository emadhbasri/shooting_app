import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';

import 'classes/services/my_service.dart';
import 'classes/states/chat_state.dart';
import 'classes/states/main_state.dart';
import 'classes/states/match_state.dart';
import 'classes/dataTypes.dart';
import 'classes/functions.dart';
import 'pages/auth/team.dart';
import 'pages/intro.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'pages/intro1.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
final getIt = GetIt.instance;

late FirebaseMessaging messaging;
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('A bg message just showed up1 : ${message.messageId}');
  // _showNotificationCustomSound(message.hashCode,
  //     message.notification!.title!, message.notification!.body!);
  await Firebase.initializeApp();
  print('A bg message just showed up : ${message.messageId}');
}

void main() async {
  GetIt.I.registerLazySingleton(() => MyService());
  GetIt.I.registerLazySingleton(() => MainState());
  GetIt.I.registerLazySingleton(() => MatchState());
  GetIt.I.registerLazySingleton(() => ChatState());
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('app_icon');

  final IOSInitializationSettings initializationSettingsIOS =
      IOSInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
  );

  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );

  messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: true,
    badge: true,
    carPlay: true,
    criticalAlert: true,
    provisional: true,
    sound: true,
  );

  String? tokk = await messaging.getToken();
  //dBfVfFtNTYS-zgXx1v_Yvy:APA91bFr9tIwAdu0BqF_JCNVHTbjaYtM43dl8VtmyC4Qi6yRZ91BSzk0et2G8WALVlbG7yD4n9F1l-iGmzKYneOfebRhUrfXgycwMY26mQ61fBQsD9ZVmf4mP66lABusVNXLbZNBA_L8
  print('tokk $tokk');
  await messaging.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shooting App',
      theme: ThemeData(
          scaffoldBackgroundColor: Color.fromRGBO(244, 244, 244, 1),
          primaryColor: mainBlue,
          primarySwatch: mainColor,
          appBarTheme:
              AppBarTheme(elevation: 0, centerTitle: true, color: mainBlue)),
      home: AppFirst(),
    );
  }
}

MaterialColor mainColor = MaterialColor(
  mainBlue.value,
  <int, Color>{
    50: mainBlue,
    100: mainBlue,
    200: mainBlue,
    300: mainBlue,
    400: mainBlue,
    500: mainBlue,
    600: mainBlue,
    700: mainBlue,
    800: mainBlue,
    900: mainBlue,
  },
);

class AppFirst extends StatefulWidget {
  @override
  _AppFirstState createState() => _AppFirstState();
}

class _AppFirstState extends State<AppFirst> {
  @override
  void initState() {
    super.initState();
    _requestPermissions();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('message come');
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        print('message.notification!.title:${message.notification!.title}');
        print('message.notification!.body:${message.notification!.body}');
        print(
            'message.notification!.android!.channelId:${message.notification!.android!.channelId}');
        _showNotificationCustomSound(
            notification.hashCode, notification.title!, notification.body!);
      }
    });
    // FirebaseMessaging.onBackgroundMessage((BackgroundMessageHandler message) => message);

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('message come in');
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        print('message.notification!.title:${message.notification!.title}');
        print('message.notification!.body:${message.notification!.body}');
        print(
            'message.notification!.android!.channelId:${message.notification!.android!.channelId}');
      }
    });
  }

  void _requestPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    // return Scaffold(
    //   body: Center(
    //     child: TextButton(
    //         onPressed: () {
    //           _showNotificationCustomSound(1346542, 'titile', 'bododby');
    //           // _showNotificationCustomSound();
    //           // flutterLocalNotificationsPlugin.show(
    //           //     1,
    //           //     'test title',
    //           //     'test body',
    //           //     NotificationDetails(
    //           //         android: AndroidNotificationDetails(
    //           //             channel.id,
    //           //             channel.name,
    //           //             playSound: true,
    //           //             color: mainBlue,
    //           //             channelShowBadge: true,
    //           //             // icon: '@mipmap/ic_launcher',
    //           //             channelDescription: channel.description
    //           //         )
    //           //     )
    //           //     // notificationDetails
    //           // );
    //         },
    //         child: Text('notif test')),
    //   ),
    // );
    // return Team();
    return Intro1();
  }
}

Future<void> _showNotificationCustomSound(
    int id, String title, String body) async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'channel 1',
    'your other channel name',
    channelDescription: 'your other channel description',
    sound: RawResourceAndroidNotificationSound('notif'),
  );
  const IOSNotificationDetails iOSPlatformChannelSpecifics =
      IOSNotificationDetails(
          sound: 'notif.aiff',
          presentSound: true,
          presentAlert: true,
          badgeNumber: 0);
  final NotificationDetails platformChannelSpecifics = NotificationDetails(
    android: androidPlatformChannelSpecifics,
    iOS: iOSPlatformChannelSpecifics,
  );
  await flutterLocalNotificationsPlugin.show(
    id,
    title,
    body,
    platformChannelSpecifics,
  );
}
