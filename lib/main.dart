import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:uni_links/uni_links.dart';

import 'classes/models.dart';
import 'classes/services/chat_service.dart';
import 'classes/services/my_service.dart';
import 'classes/states/chat_state.dart';
import 'classes/states/group_chat_state.dart';
import 'classes/states/main_state.dart';
import 'classes/states/match_state.dart';
import 'classes/dataTypes.dart';
import 'classes/functions.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'classes/states/theme_state.dart';
import 'pages/group_chat/group_chat.dart';
import 'pages/intro1.dart';
import 'pages/profile/profile.dart';
import 'pages/shot/shot.dart';

final getIt = GetIt.instance;
Uri? mainUri;
BuildContext? appContext;
bool _initialUriIsHandled = false;
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

late FirebaseMessaging messaging;
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('A bg message just showed up1 : ${message.messageId}');
  await Firebase.initializeApp();
  print('A bg message just showed up : ${message.messageId}');
}

void main() async {
  getIt.registerLazySingleton(() => MyService());
  getIt.registerLazySingleton(() => ThemeState());
  getIt.registerLazySingleton(() => MainState());
  getIt.registerLazySingleton(() => MatchState());
  getIt.registerLazySingleton(() => ChatState());
  getIt.registerLazySingleton(() => GroupChatState());
  // getIt.registerLazySingleton(() => GoogleSignInState());
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
  await messaging.requestPermission(
    alert: true,
    announcement: true,
    badge: true,
    carPlay: true,
    criticalAlert: true,
    provisional: true,
    sound: true,
  );

  // String? tokk = await messaging.getToken();
  // print('tokk $tokk');
  await messaging.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String? data) {
    if (data != null) {
      Map dd = jsonDecode(data);
      if (dd.containsKey('Kind') &&
          dd['Kind'] != null &&
          dd.containsKey('Data') &&
          dd['Data'] != null) {
        MainState state = getIt<MainState>();
        state.reciveNotif(dd['Kind']!, dd['Data']!);
      }
    }
  });

  // NotificationAppLaunchDetails? notificationAppLaunchDetails= await
  // flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  // if(notificationAppLaunchDetails?.didNotificationLaunchApp ?? false){
  //
  // }

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var _intentDataStreamSubscription;
  StreamSubscription? _sub;
  Future<void> _handleInitialUri() async {
    if (!_initialUriIsHandled) {
      _initialUriIsHandled = true;
      try {
        Uri? uri = await getInitialUri();
        if (uri == null) {
          print('no initial uri');
        } else {
          mainUri = uri;
          print('got initial uri: $uri');
        }
        if (!mounted) return;
      } on PlatformException {
        // Platform messages may fail but we ignore the exception
        print('falied to get initial uri');
      } on FormatException {
        if (!mounted) return;
        print('malformed initial uri');
      }
    }
  }

  void _handleIncomingLinks() {
    _sub = uriLinkStream.listen((Uri? uri) async {
      if (!mounted) return;
      print('got uri1: $uri');
      mainUri = uri;
      if (Platform.isIOS && appContext != null) {
        await Future.delayed(Duration(milliseconds: 500));
        Map<String, String> query = mainUri!.queryParameters;
        String key = query.keys.first;
        String value = query.values.first;

        if (key.toLowerCase() == 'shot') {
          Go.pushSlideAnim(
              appContext!,
              Shot(
                postId: value,
              ));
        } else if (key.toLowerCase() == 'user') {
          Go.pushSlideAnim(appContext!, ProfileBuilder(username: value));
        } else if (key.toLowerCase() == 'joinchat') {
          DataChatRoom? back = await ChatService.joinGroupChat(
              getIt<MyService>(),
              chatRoomId: value,
              userId: getIt<MainState>().userId);
          print('back $back');
          if (back != null) {
            await Go.pushSlideAnim(
                appContext!,
                GroupChatBuilder(
                  chatRoom: back,
                ));
          }
        }
      }
    }, onError: (Object err) {
      if (!mounted) return;
      print('got err: $err');
      setState(() {
        // _latestUri = null;
        if (err is FormatException) {
          // _err = err;
        } else {
          // _err = null;
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _handleIncomingLinks();
    _handleInitialUri();
    MainState state = getIt<MainState>();
    // For sharing images coming from outside the app while the app is in the memory
    _intentDataStreamSubscription = ReceiveSharingIntent.getMediaStream()
        .listen((List<SharedMediaFile> value) {
      if (value.isNotEmpty) state.receiveShare(sharedFiles: value);
      setState(() {
        if (value.isNotEmpty) {
          value.forEach((element) {
            print("Shared: getMediaStream ${element.path}");
          });
        }
      });
    }, onError: (err) {
      print("getIntentDataStream error: $err");
    });

    // For sharing images coming from outside the app while the app is closed
    ReceiveSharingIntent.getInitialMedia().then((List<SharedMediaFile> value) {
      if (value.isNotEmpty) state.receiveShare(sharedFiles: value);
      setState(() {
        if (value.isNotEmpty) {
          value.forEach((element) {
            print("Shared: getMediaStream ${element.path}");
          });
        }
      });
    });

    _intentDataStreamSubscription =
        ReceiveSharingIntent.getTextStream().listen((String value) {
      if (value != '') {
        if (!value.startsWith('https://footballbuzz.co'))
          state.receiveShare(sharedText: value);
      }
      setState(() {
        print("Shared: getTextStream $value");
      });
    }, onError: (err) {
      print("getLinkStream error: $err");
    });

    // For sharing or opening urls/text coming from outside the app while the app is closed
    ReceiveSharingIntent.getInitialText().then((String? value) {
      if (value != '' && value != null) {
        if (!value.startsWith('https://footballbuzz.co'))
          state.receiveShare(sharedText: value);
      }
      setState(() {
        print("Shared: getInitialText $value");
      });
    });
  }

  @override
  void dispose() {
    // _intentDataStreamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final brightness = MediaQueryData.fromWindow(WidgetsBinding.instance.window).platformBrightness;
    // MediaQuery.of(context).platformBrightness,
    return MultiProvider(
      providers: [
        ListenableProvider<ThemeState>(
          create: (context) => getIt<ThemeState>(),
        ),
        // ListenableProvider<GoogleSignInState>(
        //   create: (context) => getIt<GoogleSignInState>(),
        // ),
      ],
      child: Consumer<ThemeState>(builder: (context, state, child) {
        return MaterialApp(
          themeMode: state.themeMode,
          theme: MyThemes.lightTheme,
          darkTheme: MyThemes.darkTheme,
          debugShowCheckedModeBanner: false,
          title: 'Shooting App',
          home:
              // const SizedBox(),
              // MyApp1()
              // UniLinksTest(),
              // Scaffold(
              //   body: Center(
              //     child: Text('asd'),
              //   ),
              // )
              AppFirst(),
        );
      }),
    );

    // return MaterialApp(
    //   debugShowCheckedModeBanner: false,
    //   title: 'Shooting App',
    //   theme: ThemeData(
    //       scaffoldBackgroundColor: Color.fromRGBO(244, 244, 244, 1),
    //       primaryColor: mainBlue,
    //       primarySwatch: mainColor,
    //       appBarTheme:
    //           AppBarTheme(
    //               elevation: 0,
    //               centerTitle: true,
    //               titleTextStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
    //                 color: white
    //               ),
    //               actionsIconTheme: IconThemeData(color: white),
    //               iconTheme: IconThemeData(color: white),
    //               color: mainBlue)),
    //   home:
    //   // const SizedBox(),
    //   // MyApp1()
    //   // UniLinksTest(),
    //   AppFirst(),
    // );
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

MaterialColor mainColorDark = MaterialColor(
  myGreenLight.value,
  <int, Color>{
    50: myGreenLight,
    100: myGreenLight,
    200: myGreenLight,
    300: myGreenLight,
    400: myGreenLight,
    500: myGreenLight,
    600: myGreenLight,
    700: myGreenLight,
    800: myGreenLight,
    900: myGreenLight,
  },
);

class AppFirst extends StatefulWidget {
  @override
  _AppFirstState createState() => _AppFirstState();
}

class _AppFirstState extends State<AppFirst> {
  // testingSomeTing()async{
  //   await Future.delayed(Duration(seconds: 5));
  //   Map<String,String> data = {"kind": "Shot",
  //     "data": "7b1d8fb4-06ae-4eba-e785-08da43328857",
  //   };
  //   Map<String,String> data1 = {"kind": "User",
  //     "data": "emadbasri",
  //   };
  //   MainState state = getIt<MainState>();
  //   state.reciveNotif(data1['kind']!, data1['data']!);
  //   // state.notifKind=data1['kind'];
  //   // state.notifData=data1['data'];
  //
  //   print('asdad');
  // }

  @override
  void initState() {
    super.initState();

    // testingSomeTing();

    _requestPermissions();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('message come ${message.data.toString()}');
      // if(
      // message.data.containsKey('Kind') && message.data['Kind']!=null &&
      //     message.data.containsKey('Data') && message.data['Data']!=null
      // ){
      //   MainState state = getIt<MainState>();
      //   state.reciveNotif(message.data['Kind']!, message.data['Data']!);
      // }
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        print('message.notification!.title:${message.notification!.title}');
        print('message.notification!.body:${message.notification!.body}');
        print(
            'message.notification!.android!.channelId:${message.notification!.android!.channelId}');
        _showNotificationCustomSound(notification.hashCode, notification.title!,
            notification.body!, jsonEncode(message.data));
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('message come in ${message.data}');
      if (message.data.containsKey('Kind') &&
          message.data['Kind'] != null &&
          message.data.containsKey('Data') &&
          message.data['Data'] != null) {
        MainState state = getIt<MainState>();
        state.reciveNotif(message.data['Kind']!, message.data['Data']!);
      }
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

    return Intro1();
  }
}

Future<void> _showNotificationCustomSound(
    int id, String title, String body, String data) async {
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
  await flutterLocalNotificationsPlugin
      .show(id, title, body, platformChannelSpecifics, payload: data);
}
