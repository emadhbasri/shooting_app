import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'classes/services/my_service.dart';
import 'classes/states/chat_state.dart';
import 'classes/states/main_state.dart';
import 'classes/states/match_state.dart';
import 'classes/dataTypes.dart';
import 'classes/functions.dart';
import 'pages/intro.dart';
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();
final getIt = GetIt.instance;
void main() async{
  GetIt.I.registerLazySingleton(() => MyService());
  GetIt.I.registerLazySingleton(() => MainState());
  GetIt.I.registerLazySingleton(() => MatchState());
  GetIt.I.registerLazySingleton(() => ChatState());

  WidgetsFlutterBinding.ensureInitialized();
  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('app_icon',);

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
          appBarTheme: AppBarTheme(
              elevation: 0,
              centerTitle: true,
              color: mainBlue
          )
      ),
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

class _AppFirstState extends State<AppFirst> with WidgetsBindingObserver {

  @override
  void initState() {
    super.initState();
    _requestPermissions();

  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Center(
            child: Column(
              children: <Widget>[
                ElevatedButton(
                    onPressed: () {
                      _showNotificationCustomSound();
                    },
                    child: Text('show'))
              ],
            ),
          ),
        ),
      ),
    );
    return Intro();
  }

  Future<void> _showNotificationCustomSound() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'your other channel id',
      'your other channel name',
      channelDescription: 'your other channel description',
      sound: RawResourceAndroidNotificationSound('slow_spring_board'),
    );
    const IOSNotificationDetails iOSPlatformChannelSpecifics =
    IOSNotificationDetails(sound: 'slow_spring_board.aiff');
    final NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );
    await flutterLocalNotificationsPlugin.show(
      0,
      'custom sound notification title',
      'custom sound notification body',
      platformChannelSpecifics,
    );
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
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        MacOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }
}

