import 'package:flutter/material.dart';
import 'package:shooting_app/classes/services/my_service.dart';
import 'package:shooting_app/main.dart';
import 'package:shooting_app/pages/AppPage.dart';
import 'package:shooting_app/ui_items/shots/index.dart';
import 'package:video_player/video_player.dart';

import '../classes/functions.dart';
import '../classes/dataTypes.dart';
import 'auth/auth.dart';

class Intro1 extends StatefulWidget {
  @override
  State<Intro1> createState() => _Intro1State();
}

class _Intro1State extends State<Intro1> with SingleTickerProviderStateMixin{
  late AnimationController _controller;
  init()async{
    _controller=AnimationController(
      vsync: this,value: 0,duration: Duration(milliseconds: 500),reverseDuration: Duration(milliseconds: 500)
    );
    _controller.forward();
    _controller.addStatusListener((status) {
      if(status==AnimationStatus.completed)
        _controller.reverse();
      else if(status==AnimationStatus.dismissed)
        _controller.forward();
    });
    
    MyService service = getIt<MyService>();
    service.getToken().then((bool value) {
      if (value) {
        Future.delayed(Duration(seconds: 2),
                () => Go.pushAndRemoveSlideAnim(context, AppPageBuilder()));
      } else {
        Future.delayed(
            Duration(seconds: 2), () => Go.pushAndRemoveSlideAnim(context, Auth()));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(50, 255, 185, 1),
      body: Center(
        child: ScaleTransition(
          scale: Tween<double>(begin: 1,end: 0.7).animate(_controller),
          child:
          // CircleAvatar(
          //   backgroundImage: AssetImage('assets/images/appicon.png'),
          //   radius: 70,
          // )
          SizedBox(
            width: doubleWidth(30),
            height: doubleWidth(30),
            child: Image.asset('assets/images/appicon.png',fit: BoxFit.fill,),
          ),
        ),
      ),
    );
  }
}
