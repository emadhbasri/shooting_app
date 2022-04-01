import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

void main() async{
  WidgetsFlutterBinding.ensureInitialized();



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

      ),
      home: Notif(),
    );
  }
}
class Notif extends StatefulWidget {
  const Notif( {
    Key? key,
  }) : super(key: key);




  @override
  _NotifState createState() => _NotifState();
}

class _NotifState extends State<Notif> {


  @override
  Widget build(BuildContext context) => MaterialApp(
    home: Scaffold(
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
                    },
                    child: Text('show'))
              ],
            ),
          ),
        ),
      ),
    ),
  );


}
