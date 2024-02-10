
import 'package:shooting_app/classes/functions.dart';

import 'package:flutter/material.dart';

enum MyToastType { warning, success, error, info }

class MyToast extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Function? doOnce;
  const MyToast({
    required Key key,
    this.duration = const Duration(seconds: 3),
    this.doOnce,
    required this.child,
  }) : super(key: key);
  @override
  MyToastState createState() => MyToastState();
}

class MyToastState extends State<MyToast> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  String text = '';
  MyToastType status = MyToastType.error;
  double dx = 0, dy = 0, start = 0;
  bool show = false;
  toastAnimate(String text, {status = MyToastType.error, Duration? duration}) {
    setState(() {
      show = true;
      this.text = text;
      this.status = status;
      dx = 0;
    });
    debugPrint('toastAnimate');
    controller.forward().then((value) async {
      await Future.delayed(duration ?? widget.duration);
      controller.reverse().then((value) => setState(() => show = false));
    });
  }

  @override
  void initState() {
    controller = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this, value: 0);
    if (widget.doOnce != null) {
      widget.doOnce!();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Color backGroundColor;
    Color shadowColor;
    if (status == MyToastType.success) {
      backGroundColor = colorSuccessMain;
      shadowColor = const Color(0x5d0fc57e);
    } else if (status == MyToastType.error) {
      backGroundColor = colorErrorMain;
      shadowColor = const Color(0x5fde144b);
    } else if (status == MyToastType.info) {
      backGroundColor = colorGray6;
      shadowColor = const Color(0x5e6f7591);
    } else {
      backGroundColor = colorWarningMain;
      shadowColor = const Color(0x5edda80f);
    }
    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          widget.child,
          if (show)
            Align(
              alignment: Alignment.topCenter,
              child: SlideTransition(
                  position: Tween<Offset>(
                          begin: const Offset(0, -1), end: const Offset(0, 0))
                      .animate(controller),
                  child: GestureDetector(
                    onTap: () {
                      controller
                          .reverse()
                          .then((value) => setState(() => show = false));
                    },
                    onVerticalDragStart: (e) => controller
                        .reverse()
                        .then((value) => setState(() => show = false)),
                    child: Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: doubleWidth(3.1*2),
                          vertical: doubleHeight(1.9*2) +
                              doubleHeight(1.9)),
                      padding: EdgeInsets.symmetric(
                          vertical: doubleHeight(1.9),
                          horizontal:doubleWidth(4.1)),
                      // width: double.maxFinite,
                      width: doubleWidth(100),
                      // height: doubleHeight1(7),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: shadowColor,
                              offset: const Offset(0, 4),
                              blurRadius: 12,
                              spreadRadius: 0)
                        ],
                        color: backGroundColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        textDirection: TextDirection.rtl,
                        children: [
                          Expanded(
                            child: Text(text,
                                textDirection: TextDirection.ltr,
                                style: const TextStyle(
                                    color: Color(0xffffffff),
                                    fontWeight: FontWeight.w500,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 14.0),
                                textAlign: TextAlign.left),
                          ),
                          SizedBox(width: doubleWidth(2.1/2)),
                          const Icon(
                            Icons.close,
                            color: Colors.white,
                          )
                        ],
                      ),
                    ),
                  )),
            )
        ],
      ),
    );
  }
}





const colorPrimaryLighter = Color.fromRGBO(231, 239, 255, 1);
const colorPrimaryLight = Color.fromRGBO(161, 184, 242, 1);
const colorPrimaryMain = Color.fromRGBO(20, 78, 222, 1);
const colorPrimaryDark = Color.fromRGBO(15, 48, 128, 1);
const colorPrimaryDarker = Color.fromRGBO(9, 30, 82, 1);

const colorSecondaryLighter = Color.fromRGBO(216, 243, 255, 1);
const colorSecondaryLight = Color.fromRGBO(167, 225, 250, 1);
const colorSecondaryMain = Color.fromRGBO(35, 179, 242, 1);
const colorSecondaryDark = Color.fromRGBO(0, 121, 174, 1);
const colorSecondaryDarker = Color.fromRGBO(0, 51, 73, 1);

const colorTerritoryLighter = Color.fromRGBO(212, 243, 235, 1);
const colorTerritoryLight = Color.fromRGBO(153, 230, 210, 1);
const colorTerritoryMain = Color.fromRGBO(0, 192, 143, 1);
const colorTerritoryDark = Color.fromRGBO(0, 125, 93, 1);
const colorTerritoryDarker = Color.fromRGBO(0, 63, 47, 1);

const colorErrorLighter = Color.fromRGBO(251, 231, 237, 1);
const colorErrorLight = Color.fromRGBO(242, 161, 183, 1);
const colorErrorMain = Color.fromRGBO(222, 20, 75, 1);
const colorErrorDark = Color.fromRGBO(138, 11, 46, 1);
const colorErrorDarker = Color.fromRGBO(100, 4, 30, 1);

const colorSuccessLighter = Color.fromRGBO(231, 249, 242, 1);
const colorSuccessLight = Color.fromRGBO(159, 232, 203, 1);
const colorSuccessMain = Color.fromRGBO(15, 197, 126, 1);
const colorSuccessDark = Color.fromRGBO(5, 140, 88, 1);
const colorSuccessDarker = Color.fromRGBO(2, 90, 56, 1);

const colorWarningLighter = Color.fromRGBO(251, 246, 231, 1);
const colorWarningLight = Color.fromRGBO(241, 220, 159, 1);
const colorWarningMain = Color.fromRGBO(221, 168, 15, 1);
const colorWarningDark = Color.fromRGBO(158, 119, 7, 1);
const colorWarningDarker = Color.fromRGBO(110, 84, 8, 1);

const colorInfoLighter = Color.fromRGBO(241, 241, 242, 1);
const colorInfoLight = Color.fromRGBO(200, 200, 204, 1);
const colorInfoMain = Color.fromRGBO(145, 145, 153, 1);
const colorInfoDark = Color.fromRGBO(86, 86, 96, 1);
const colorInfoDarker = Color.fromRGBO(55, 55, 58, 1);

const colorGray0 = Color.fromRGBO(252, 252, 252, 1);
const colorDots = Color.fromRGBO(216, 216, 216, 1);

const colorGray1 = Color.fromRGBO(249, 249, 251, 1);
const colorGray2 = Color.fromRGBO(240, 240, 245, 1);
const colorGray3 = Color.fromRGBO(216, 218, 229, 1);
const colorGray4 = Color.fromRGBO(179, 182, 204, 1);
const colorGray5 = Color.fromRGBO(154, 159, 188, 1);
const colorGray6 = Color.fromRGBO(111, 117, 145, 1);
const colorGray7 = Color.fromRGBO(95, 100, 124, 1);
const colorGray8 = Color.fromRGBO(73, 77, 95, 1);
const colorGray9 = Color.fromRGBO(40, 42, 52, 1);

const colorOtherOverlay = Color.fromRGBO(0, 0, 0, 0.4);
const colorPurplePink = Color.fromRGBO(182, 32, 224, 1);