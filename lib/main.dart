import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'classes/my_service.dart';
import 'classes/states/chat_state.dart';
import 'classes/states/main_state.dart';
import 'classes/states/match_state.dart';
import 'classes/states/my_profile_state.dart';
import 'dataTypes.dart';
import 'classes/functions.dart';
import 'pages/intro.dart';

final getIt = GetIt.instance;
void main() {
  print(DateTime.now().toString());
  GetIt.I.registerLazySingleton(() => MyService());
  GetIt.I.registerLazySingleton(() => MainState());
  GetIt.I.registerLazySingleton(() => MatchState());
  GetIt.I.registerLazySingleton(() => MyProfileState());
  GetIt.I.registerLazySingleton(() => ChatState());
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
        appBarTheme: AppBarTheme(
          centerTitle: true,
          color: mainBlue
        )
      ),
      home: AppFirst(),
    );
  }
}

class AppFirst extends StatefulWidget {
  @override
  _AppFirstState createState() => _AppFirstState();
}

class _AppFirstState extends State<AppFirst> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    // statusSet(Colors.white);
    statusSet(mainBlue);
    // "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI5OWY5MDc3OS1kNzMxLTQ1MTgtMGQ4My0wOGRhMDY5NGY2MTEiLCJhcHBsaWNhdGlvblVzZXJJZCI6IjZiNWU3YzQ2LWMwNmUtNGRmYi1iNDU1LTUzYzU4OGQ0MGEwYyIsIm5iZiI6MTY0NzQxNTY3OSwiZXhwIjoxNjUwMDA3Njc5LCJpYXQiOjE2NDc0MTU2Nzl9.QJmqiHKm-a3Hxes6M_WP7wqEvbBQmLv_k0ZXJFkWxhc",
    // "refreshToken": "NQmDBrsrL0KlbFhBk3dMrn6ti0GCJL/YbVyx5kEJGT4=",
    // "applicationUserId": "6b5e7c46-c06e-4dfb-b455-53c588d40a0c",
    // "id": "99f90779-d731-4518-0d83-08da0694f611"

    // private chat room c6f7abba-ed26-4837-a427-08da071ec138

    // setString('userid', '3530f18b-a1ed-406e-0914-08da04b81c0f');
    // setString('username', 'emadbasri');
    // setString('applicationUserId', 'c7c54d63-b3bb-42a1-838d-ff7a2666975f');
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    return Intro();
  }
}



//"messages":"Sorry, we are unable to provide RapidAPI services to your location. RapidAPI is required to comply with US laws that restrict the use of our services in embargoed countries. If you believe you receiving this message in error, please contact support@rapidapi.com."