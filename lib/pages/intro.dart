import 'package:flutter/material.dart';
import 'package:shooting_app/classes/services/my_service.dart';
import 'package:shooting_app/main.dart';
import 'package:shooting_app/pages/AppPage.dart';
import 'package:video_player/video_player.dart';

import '../classes/functions.dart';
import '../classes/dataTypes.dart';
import 'auth/auth.dart';

class Intro extends StatefulWidget {
  @override
  State<Intro> createState() => _IntroState();
}

class _IntroState extends State<Intro> {

  late VideoPlayerController _controller;
  bool show = false;
  init()async{
    _controller = VideoPlayerController.asset('assets/shoot/video/intro.mp4');
    await _controller.initialize();
    _controller.play();

    setState(() {
      show = true;
    });
  }
  @override
  void initState() {
    super.initState();
    init();

    MyService service = getIt<MyService>();
    service.getToken().then((bool value) {
      if (value) {
        Future.delayed(Duration(seconds: 2),
            () => Go.pushSlideAnim(context, AppPageBuilder()));
      } else {
        Future.delayed(
            Duration(seconds: 2), () => Go.pushSlideAnim(context, Auth()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            width: max,
            height: max,
            color: white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                sizeh(doubleHeight(12)),
                Container(
                  width: doubleWidth(37),
                  height: doubleWidth(37),
                  child: Stack(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Container(
                          width: doubleWidth(32),
                          height: doubleWidth(32),
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(78, 255, 187, 1),
                              borderRadius: BorderRadius.circular(100)),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          width: doubleWidth(32),
                          height: doubleWidth(32),
                          child: Image.asset(
                            'assets/images/soccerBall.png',
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                sizeh(doubleHeight(17)),
                Text(
                  'Football Buzz',
                  style: TextStyle(
                      color: mainBlue,
                      fontWeight: FontWeight.bold,
                      fontSize: doubleWidth(7)),
                ),
                sizeh(doubleHeight(4)),
                Text('For the fans...',
                    style: TextStyle(color: gray, fontSize: doubleWidth(5)))
              ],
            ),
          ),
          Align(
            alignment: Alignment(0, 0.9),
            child: Text(
              '@ 2019 Football Buzz | All rights reserved',
              style: TextStyle(fontSize: doubleWidth(2.5)),
            ),
          )
        ],
      ),
    );
  }
}
