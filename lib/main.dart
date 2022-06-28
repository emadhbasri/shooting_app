import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:uni_links/uni_links.dart';

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


import 'pages/intro1.dart';

final getIt = GetIt.instance;


final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

late FirebaseMessaging messaging;
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('A bg message just showed up1 : ${message.messageId}');
  await Firebase.initializeApp();
  print('A bg message just showed up : ${message.messageId}');
}

void main() async {
  
  GetIt.I.registerLazySingleton(() => MyService());
  GetIt.I.registerLazySingleton(() => MainState());
  GetIt.I.registerLazySingleton(() => MatchState());
  GetIt.I.registerLazySingleton(() => ChatState());
  GetIt.I.registerLazySingleton(() => GroupChatState());
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

  String? tokk = await messaging.getToken();
  print('tokk $tokk');
  await messaging.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onSelectNotification: (String? data){

      if(data!=null){
        Map dd = jsonDecode(data);
        if(
        dd.containsKey('Kind') && dd['Kind']!=null &&
            dd.containsKey('Data') && dd['Data']!=null
        ){
          MainState state = getIt<MainState>();
          state.reciveNotif(dd['Kind']!, dd['Data']!);
        }
      }
    }
  );

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
  late StreamSubscription _intentDataStreamSubscription;
  void _handleIncomingLinks(context) {
    print('_handleIncomingLinks ');
    StreamSubscription sub = uriLinkStream.listen((Uri? uri) async{
      print(''
          ' $uri');
      // if (!mounted) return;
      if(uri!=null){
        // footballbuzz://Shot/asd
        // footballbuzz://JoinChat/asd
        // footballbuzz://User/asd
        print('''
            uri $uri
            ${uri.path}
            ${uri.host}
            ${uri.queryParameters}
            ${uri.queryParametersAll}
            ${uri.query}
            
            ''');
        String data = uri.path.replaceAll('/', '');
        data = data.replaceAll('https:', '');
        data = data.replaceAll('footballbuzz:', '');
        // if(uri.host=='shot'){
        //   Go.pushSlideAnim(
        //       context,
        //       Shot(
        //         postId: data,
        //       ));
        // }else if(uri.host=='user'){
        //   Go.pushSlideAnim(context,
        //       ProfileBuilder(username: data));
        // }else if(uri.host=='joinchat'){
        //   DataChatRoom? back = await ChatService.joinGroupChat(getIt<MyService>(),
        //       chatRoomId: data, userId: getIt<MainState>().userId);
        //   print('back $back');
        //   if(back!=null) {
        //     await Go.pushSlideAnim(
        //         context,
        //         GroupChatBuilder(
        //           chatRoom: back,
        //         ));
        //   }
        // }

      }

    }, onError: (Object err) {
      // if (!mounted) return;
      print('error uri $err');
    });
    linkStream.listen((String? uri) async{
      print('linkStream $uri');
      // if (!mounted) return;
      if(uri!=null){
        // footballbuzz://Shot/asd
        // footballbuzz://JoinChat/asd
        // footballbuzz://User/asd
        print('''
            uri $uri
            
            ''');
        String data = uri.replaceAll('/', '');
        data = data.replaceAll('https:', '');
        data = data.replaceAll('footballbuzz:', '');
        // if(uri.host=='shot'){
        //   Go.pushSlideAnim(
        //       context,
        //       Shot(
        //         postId: data,
        //       ));
        // }else if(uri.host=='user'){
        //   Go.pushSlideAnim(context,
        //       ProfileBuilder(username: data));
        // }else if(uri.host=='joinchat'){
        //   DataChatRoom? back = await ChatService.joinGroupChat(getIt<MyService>(),
        //       chatRoomId: data, userId: getIt<MainState>().userId);
        //   print('back $back');
        //   if(back!=null) {
        //     await Go.pushSlideAnim(
        //         context,
        //         GroupChatBuilder(
        //           chatRoom: back,
        //         ));
        //   }
        // }

      }

    }, onError: (Object err) {
      // if (!mounted) return;
      print('error linkStream $err');
    });
  }
  @override
  void initState() {
    super.initState();
    _handleIncomingLinks(context);

    MainState state = getIt<MainState>();
    // For sharing images coming from outside the app while the app is in the memory
    _intentDataStreamSubscription = ReceiveSharingIntent.getMediaStream()
        .listen((List<SharedMediaFile> value) {
          if(value.isNotEmpty)
            state.receiveShare(sharedFiles: value);
      setState(() {
        if(value.isNotEmpty){
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
      if(value.isNotEmpty)
        state.receiveShare(sharedFiles: value);
      setState(() {
        if(value.isNotEmpty){
          value.forEach((element) {
            print("Shared: getMediaStream ${element.path}");
          });
        }
      });
    });

    // For sharing or opening urls/text coming from outside the app while the app is in the memory
    _intentDataStreamSubscription =
        ReceiveSharingIntent.getTextStream().listen((String value) {
          if(value!=''){
            if(!value.startsWith('https://footballbuzz.co'))
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

      if(value!='' && value!=null){
        if(!value.startsWith('https://footballbuzz.co'))
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shooting App',
      theme: ThemeData(
          scaffoldBackgroundColor: Color.fromRGBO(244, 244, 244, 1),
          primaryColor: mainBlue,
          primarySwatch: mainColor,
          appBarTheme:
              AppBarTheme(
                  elevation: 0,
                  centerTitle: true,
                  titleTextStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: white
                  ),
                  actionsIconTheme: IconThemeData(color: white),
                  iconTheme: IconThemeData(color: white),
                  color: mainBlue)),
      home:
      // UniLinksTest(),
      AppFirst(),
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
        _showNotificationCustomSound(
            notification.hashCode, notification.title!, notification.body!,jsonEncode(message.data));
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('message come in ${message.data}');
      if(
      message.data.containsKey('Kind') && message.data['Kind']!=null &&
          message.data.containsKey('Data') && message.data['Data']!=null
      ){
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
    int id, String title, String body,String data) async {
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
    platformChannelSpecifics,payload: data
  );
}
