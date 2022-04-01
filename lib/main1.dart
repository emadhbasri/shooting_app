// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:get_it/get_it.dart';
// import 'classes/services/my_service.dart';
// import 'classes/states/chat_state.dart';
// import 'classes/states/main_state.dart';
// import 'classes/states/match_state.dart';
// import 'classes/dataTypes.dart';
// import 'classes/functions.dart';
// import 'pages/intro.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// // const AndroidNotificationChannel channel = AndroidNotificationChannel(
// //     'high_inportance_chanel',
// //     'high importance notif',
// //   description: 'this channel is used for important notif',
// //   importance: Importance.high,
// //   playSound: true,
// //   showBadge: true,
// // );
// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin=
//     FlutterLocalNotificationsPlugin();
//
// late NotificationDetails notificationDetails;
// late FirebaseMessaging messaging;
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message)async{
//   print('A bg message just showed up1 : ${message.messageId}');
//   await Firebase.initializeApp();
//   print('A bg message just showed up : ${message.messageId}');
// }
//
// final getIt = GetIt.instance;
// void main() async{
//   WidgetsFlutterBinding.ensureInitialized();
//   GetIt.I.registerLazySingleton(() => MyService());
//   GetIt.I.registerLazySingleton(() => MainState());
//   GetIt.I.registerLazySingleton(() => MatchState());
//   GetIt.I.registerLazySingleton(() => ChatState());
//
//   notificationDetails=NotificationDetails(
//       android: AndroidNotificationDetails(
//           channel.id,
//           channel.name,
//           playSound: true,
//           color: mainBlue,
//           // icon: '@mipmap/ic_launcher',slow_spring_board
//           channelDescription: channel.description,///images/shooting.mp3
//         // sound: RawResourceAndroidNotificationSound('notif'),
//       ),
//     // iOS: IOSNotificationDetails(sound: 'notif.aiff',
//     // presentSound: true,presentBadge: true,badgeNumber: 1)
//   );
//
//   await Firebase.initializeApp();
//   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
//
//   await flutterLocalNotificationsPlugin
//   .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
//   ?.createNotificationChannel(channel);
//   messaging =FirebaseMessaging.instance;
//
//   //dBfVfFtNTYS-zgXx1v_Yvy:APA91bFr9tIwAdu0BqF_JCNVHTbjaYtM43dl8VtmyC4Qi6yRZ91BSzk0et2G8WALVlbG7yD4n9F1l-iGmzKYneOfebRhUrfXgycwMY26mQ61fBQsD9ZVmf4mP66lABusVNXLbZNBA_L8
//   NotificationSettings settings = await messaging.requestPermission(
//     alert: true,
//     announcement: false,
//     badge: true,
//     carPlay: false,
//     criticalAlert: false,
//     provisional: false,
//     sound: true,
//   );
//   print('settings ${settings}');
//
//   await messaging.setForegroundNotificationPresentationOptions(
//     alert: true,
//     badge: true,
//     sound: true,
//   );
//
//
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Shooting App',
//       theme: ThemeData(
//         scaffoldBackgroundColor: Color.fromRGBO(244, 244, 244, 1),
//         primaryColor: mainBlue,
//         primarySwatch: mainColor,
//         appBarTheme: AppBarTheme(
//             elevation: 0,
//           centerTitle: true,
//           color: mainBlue
//         )
//       ),
//       home: AppFirst(),
//     );
//   }
// }
//
// MaterialColor mainColor = MaterialColor(
//   mainBlue.value,
//   <int, Color>{
//     50: mainBlue,
//     100: mainBlue,
//     200: mainBlue,
//     300: mainBlue,
//     400: mainBlue,
//     500: mainBlue,
//     600: mainBlue,
//     700: mainBlue,
//     800: mainBlue,
//     900: mainBlue,
//   },
// );
//
// class AppFirst extends StatefulWidget {
//   @override
//   _AppFirstState createState() => _AppFirstState();
// }
//
// class _AppFirstState extends State<AppFirst> {
//   void _requestPermissions() {
//     flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//         IOSFlutterLocalNotificationsPlugin>()
//         ?.requestPermissions(
//       alert: true,
//       badge: true,
//       sound: true,
//     );
//     flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//         MacOSFlutterLocalNotificationsPlugin>()
//         ?.requestPermissions(
//       alert: true,
//       badge: true,
//       sound: true,
//     );
//   }
//   Future<void> _showNotificationCustomSound() async {
//     const AndroidNotificationDetails androidPlatformChannelSpecifics =
//     AndroidNotificationDetails(
//       'your other channel id',
//       'your other channel name',
//       channelDescription: 'your other channel description',
//       sound: RawResourceAndroidNotificationSound('notif'),
//     );
//     const IOSNotificationDetails iOSPlatformChannelSpecifics =
//     IOSNotificationDetails(sound: 'notif.aiff');
//     final NotificationDetails platformChannelSpecifics = NotificationDetails(
//       android: androidPlatformChannelSpecifics,
//       iOS: iOSPlatformChannelSpecifics,
//     );
//     await flutterLocalNotificationsPlugin.show(
//       0,
//       'custom sound notification title',
//       'custom sound notification body',
//       platformChannelSpecifics,
//     );
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     statusSet(mainBlue);
//     _requestPermissions();
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//         print('message come');
//       RemoteNotification? notification = message.notification;
//       AndroidNotification? android = message.notification?.android;
//       if(notification!=null && android!=null){
//         print('message.notification!.title:${message.notification!.title}');
//         print('message.notification!.body:${message.notification!.body}');
//         print('message.notification!.android!.channelId:${message.notification!.android!.channelId}');
//         _showNotificationCustomSound(notification.hashCode,
//             notification.title!, notification.body!);
//         // flutterLocalNotificationsPlugin.show(
//         //     notification.hashCode,
//         //     notification.title,
//         //     notification.body,
//         //     NotificationDetails(
//         //       android: AndroidNotificationDetails(
//         //         channel.id,
//         //         channel.name,
//         //         playSound: true,
//         //         color: mainBlue,
//         //         channelShowBadge: true,
//         //         // icon: '@mipmap/ic_launcher',
//         //         channelDescription: channel.description
//         //       )
//         //     ));
//       }
//     });
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       print('message come in');
//       RemoteNotification? notification = message.notification;
//       AndroidNotification? android = message.notification?.android;
//       if(notification!=null && android!=null){
//         print('message.notification!.title:${message.notification!.title}');
//         print('message.notification!.body:${message.notification!.body}');
//         print('message.notification!.android!.channelId:${message.notification!.android!.channelId}');
//         // showDialog(context: context, builder: (_){
//         //   return AlertDialog(
//         //     title: Text('${notification.title}'),
//         //     content: Column(
//         //       mainAxisSize: MainAxisSize.min,
//         //       children: [
//         //         Text('${notification.body}')
//         //       ],
//         //     ),
//         //   );
//         // });
//       }
//     });
//
//
// ///
//
//
//     // statusSet(Colors.white);
//     // "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI5OWY5MDc3OS1kNzMxLTQ1MTgtMGQ4My0wOGRhMDY5NGY2MTEiLCJhcHBsaWNhdGlvblVzZXJJZCI6IjZiNWU3YzQ2LWMwNmUtNGRmYi1iNDU1LTUzYzU4OGQ0MGEwYyIsIm5iZiI6MTY0NzQxNTY3OSwiZXhwIjoxNjUwMDA3Njc5LCJpYXQiOjE2NDc0MTU2Nzl9.QJmqiHKm-a3Hxes6M_WP7wqEvbBQmLv_k0ZXJFkWxhc",
//     // "refreshToken": "NQmDBrsrL0KlbFhBk3dMrn6ti0GCJL/YbVyx5kEJGT4=",
//     // "applicationUserId": "6b5e7c46-c06e-4dfb-b455-53c588d40a0c",
//     // "id": "99f90779-d731-4518-0d83-08da0694f611"
//     // setString('userid', '99f90779-d731-4518-0d83-08da0694f611');
//     // setString('username', 'emadhbasri');
//     // private chat room c6f7abba-ed26-4837-a427-08da071ec138
//
//     // setString('userid', '3530f18b-a1ed-406e-0914-08da04b81c0f');
//     // setString('username', 'emadbasri');
//     // setString('applicationUserId', 'c7c54d63-b3bb-42a1-838d-ff7a2666975f');
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     screenSize = MediaQuery.of(context).size;
//     return Scaffold(
//       body: Center(child: TextButton(
//           onPressed: (){
//             _showNotificationCustomSound(1,
//                 'titile', 'bododby');
//             // flutterLocalNotificationsPlugin.show(
//             //     1,
//             //     'test title',
//             //     'test body',
//             //     NotificationDetails(
//             //         android: AndroidNotificationDetails(
//             //             channel.id,
//             //             channel.name,
//             //             playSound: true,
//             //             color: mainBlue,
//             //             channelShowBadge: true,
//             //             // icon: '@mipmap/ic_launcher',
//             //             channelDescription: channel.description
//             //         )
//             //     )
//             //     // notificationDetails
//             // );
//           },
//           child: Text('notif test')),),
//     );
//     // return FilePickerDemo();
//     // return Team();
//     return Intro();
//     // return StoryList();
//   }
// }
//
//
//
// //"messages":"Sorry, we are unable to provide RapidAPI services to your location.
// // RapidAPI is required to comply with US laws that restrict the use of our services in embargoed countries.
// // If you believe you receiving this message in error, please contact support@rapidapi.com."