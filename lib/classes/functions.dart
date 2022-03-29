import 'dart:async';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:share_plus/share_plus.dart';

import 'dataTypes.dart';
import '../pages/Search.dart';
import '../pages/profile/profile.dart';

late Size screenSize;
double doubleHeight(double value, {double height = 0}) {
  if (height == 0) height = screenSize.height;
  return (height * value) / 100;
}

double doubleWidth(double value, {double width = 0}) {
  if (width == 0) width = screenSize.width;
  return (width * value) / 100;
}

statusSet(Color color) async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: color,
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarDividerColor: Colors.white,

    ));
  } on PlatformException catch (e) {
    debugPrint('statusSet $e');
  }
}

Widget circle() {
  return Scaffold(
    body: Container(
      color: Color.fromRGBO(228, 241, 246, 1),
      child: Center(child: CircularProgressIndicator()),
    ),
  );
}

String makeDurationToString(DateTime date) {
  DateTimeRange range = DateTimeRange(start: date, end: DateTime.now());
  Duration duration = range.duration;
  if (duration.inDays > 365) {
    return (duration.inDays ~/ 365).toString() + 'y';
  } else if (duration.inDays > 30) {
    return (duration.inDays ~/ 30).toString() + 'mon';
  } else if (duration.inDays > 0) {
    return (duration.inDays).toString() + 'd';
  } else if (duration.inHours > 0) {
    return (duration.inHours).toString() + 'h';
  } else if (duration.inMinutes > 0) {
    return (duration.inMinutes).toString() + 'min';
  } else if (duration.inSeconds > 0) {
    return (duration.inSeconds).toString() + 's';
  } else
    return '';
}

String getMonString(DateTime date) {
  switch (date.month) {
    case 1:
      return 'Jan';
    case 2:
      return 'Feb';
    case 3:
      return 'Mar';
    case 4:
      return 'Apr';
    case 5:
      return 'May';
    case 6:
      return 'Jun';
    case 7:
      return 'Jul';
    case 8:
      return 'Aug';
    case 9:
      return 'Sep';
    case 10:
      return 'Oct';
    case 11:
      return 'Nov';
    case 12:
      return 'dec';
    default:
      return '';
  }
}

const String profileImageDefault = 'images/158023.png';
const String profileTeamDefault = 'images/unnamed.png';

copyText(String text, {String payam = 'text copied to clipboard'}) =>
    FlutterClipboard.copy(text).then((value) => toast(payam));

sharePost(String text, {String payam = 'text copied to clipboard'}) =>
    Share.share('check out the post $text');

toast(String str, {Toast duration = Toast.LENGTH_SHORT}) {
  Fluttertoast.showToast(
      msg: str,
      toastLength: duration,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: mainBlue,
      textColor: Colors.white,
      fontSize: 16.0);
}

gogo(BuildContext context, String str, bool isUser) {
  if (isUser) {
    Go.pushSlideAnim(context, ProfileBuilder(username: str));
  } else {
    Go.pushSlideAnim(
        context,
        Search(
          search: str,
        ));
  }
}

String makeCount(int num) {
  if (num < 1000) {
    return num.toString();
  } else if (num < 1000000) {
    return '${(num ~/ 1000)}k';
  } else {
    return '${(num ~/ 1000000)}m';
  }
}

abstract class Go {
  static void pushAndRemoveSlideAnim(BuildContext context, Widget page,
      {bool full: false, var first, var second}) {
    if (first == null) first = Cubic(0.175, 0.885, 0.32, 1.1);
    if (second == null) second = Curves.easeOutCirc;
    Navigator.pushAndRemoveUntil(
        context,
        PageRouteBuilder(
            transitionDuration: Duration(seconds: 1),
            fullscreenDialog: full,
            pageBuilder: (context, Animation<double> animation,
                Animation<double> secendAnimation) {
              return page;
            },
            transitionsBuilder: (context, Animation<double> animation,
                Animation<double> secendAnimation, Widget widget) {
              return SlideTransition(
                position: Tween(begin: Offset(1, 0), end: Offset(0, 0))
                    .animate(CurvedAnimation(
                        curve: first, //Curves.easeOutBack
                        parent: animation,
                        reverseCurve: second)),
                child: widget,
              );
            }),
        (route) => false).catchError((e) => print('Error 1 $e'));
  }

  static Future<dynamic> pushSlideAnim(BuildContext context, Widget page,
      {bool full: false, var first, var second}) {
    if (first == null) first = Cubic(0.175, 0.885, 0.32, 1.1);
    if (second == null) second = Curves.easeOutCirc;
    return Navigator.push(
        context,
        PageRouteBuilder(
            transitionDuration: Duration(seconds: 1),
            fullscreenDialog: full,
            pageBuilder: (context, Animation<double> animation,
                Animation<double> secendAnimation) {
              return page;
            },
            transitionsBuilder: (context, Animation<double> animation,
                Animation<double> secendAnimation, Widget widget) {
              return SlideTransition(
                position: Tween(begin: Offset(1, 0), end: Offset(0, 0))
                    .animate(CurvedAnimation(
                        curve: first, //Curves.easeOutBack
                        parent: animation,
                        reverseCurve: second)),
                child: widget,
              );
            })).catchError((e) => print('Error 1 $e'));
  }

  static void pushSlideAnimDrawer(
    BuildContext context,
    Widget page, {
    bool full: false,
  }) {
    Navigator.push(
        context,
        PageRouteBuilder(
          // transitionDuration: Duration(seconds: 1),
          fullscreenDialog: false,
          barrierColor: Colors.black.withOpacity(0.5),
          barrierDismissible: true,
          opaque: false,
          pageBuilder: (context, Animation<double> animation,
              Animation<double> secendAnimation) {
            return page;
          },
        ));
    // transitionsBuilder: (context, Animation<double> animation,
    //     Animation<double> secendAnimation, Widget widget) {
    //   return widget;
    // })).catchError((e) => print('Error 1 $e'));
  }

  static void pushSlideAnimSheet(BuildContext context, Widget page,
      {bool full: false, var first, var second}) {
    if (first == null) first = Cubic(0.175, 0.885, 0.32, 1.1);
    if (second == null) second = Curves.easeOutCirc;
    Navigator.push(
        context,
        PageRouteBuilder(
            transitionDuration: Duration(seconds: 1),
            fullscreenDialog: false,
            barrierColor: Colors.black.withOpacity(0.5),
            barrierDismissible: true,
            opaque: false,
            pageBuilder: (context, Animation<double> animation,
                Animation<double> secendAnimation) {
              return page;
            },
            transitionsBuilder: (context, Animation<double> animation,
                Animation<double> secendAnimation, Widget widget) {
              return SlideTransition(
                position: Tween(begin: Offset(0, 1), end: Offset(0, 0))
                    .animate(CurvedAnimation(
                        curve: first, //Curves.easeOutBack
                        parent: animation,
                        reverseCurve: second)),
                child: widget,
              );
            })).catchError((e) => print('Error 1 $e'));
  }

  static void replaceSlideAnim(BuildContext context, Widget page,
      {bool full: false, var first, var second}) {
    if (first == null) first = Cubic(0.175, 0.885, 0.32, 1.1);
    if (second == null) second = Curves.easeOutCirc;
    Navigator.pushReplacement(
        context,
        PageRouteBuilder(
            transitionDuration: Duration(seconds: 1),
            fullscreenDialog: full,
            pageBuilder: (context, Animation<double> animation,
                Animation<double> secendAnimation) {
              return page;
            },
            transitionsBuilder: (context, Animation<double> animation,
                Animation<double> secendAnimation, Widget widget) {
              return SlideTransition(
                position: Tween(begin: Offset(1, 0), end: Offset(0, 0))
                    .animate(CurvedAnimation(
                        curve: first, //Curves.easeOutBack
                        parent: animation,
                        reverseCurve: second)),
                child: widget,
              );
            })).catchError((e) => print('Error 1 $e'));
  }

  static void push(BuildContext context, Widget page, {bool full: false}) {
    Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => page, fullscreenDialog: full))
        .catchError((e) => print('Error 1 $e'));
  }

  static void pushHero(BuildContext context, Widget page, Duration dur,
      {bool full: false}) {
    Navigator.push(
        context,
        PageRouteBuilder(
          transitionDuration: dur,
          pageBuilder: (_, __, ___) => page,
          fullscreenDialog: full,
        ));
  }

  static void replace(BuildContext context, Widget newPage,
      {bool full: false}) {
    Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => newPage, fullscreenDialog: full))
        .catchError((e) => print('Error 2 $e'));
  }

  static void replaceHero(BuildContext context, Widget newPage, Duration dur,
      {bool full: false}) {
    Navigator.pushReplacement(
        context,
        PageRouteBuilder(
            transitionDuration: dur,
            pageBuilder: (_, __, ___) => newPage,
            fullscreenDialog: full));
  }

  static void pop(BuildContext context, [dynamic data]) {
    Navigator.pop(context, data);
  }

  static bool canPop(BuildContext context) {
    return Navigator.canPop(context);
  }

  static Future popAndPushNamed_(BuildContext context, Widget page,
      {bool full: false}) {
    return Navigator.popAndPushNamed(context, '');
  }

  static void removeRoute(BuildContext context, Widget page) {
    Navigator.removeRoute(
        context, MaterialPageRoute(builder: (context) => page));
  }

  static void removeRouteBelow(BuildContext context, Widget page) {
    Navigator.removeRouteBelow(
        context, MaterialPageRoute(builder: (context) => page));
  }

  static void replaceRouteBelow(
      BuildContext context, Widget oldPage, Widget newPage) {
    Navigator.replaceRouteBelow(context,
        anchorRoute: MaterialPageRoute(builder: (context) => oldPage),
        newRoute: MaterialPageRoute(builder: (context) => newPage));
  }

  static void pushAndRemove(BuildContext context, Widget page) {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => page), (route) => false);
  }
}

CachedNetworkImageProvider networkImage(String url) {
  // debugPrint('networkimageProvider $url');
  return CachedNetworkImageProvider(url);
}

CachedNetworkImage imageNetwork(
  String url, {
  Color? color,
  BoxFit? fit,
  double? width,
  double? height,
}) {
  return CachedNetworkImage(
      imageUrl: url,
      color: color,
      fit: fit,
      width: width,
      height: height,
      progressIndicatorBuilder: (context, url, DownloadProgress progress) {
        return Center(
          child: SizedBox(
            width: 50,
            height: 50,
            child: CircularProgressIndicator(
                // valueColor: AlwaysStoppedAnimation(mainBlue),
                // backgroundColor: mainBlue,
                ),
          ),
        );
      },
      errorWidget: (context, url, error) => SizedBox(
        width: 50,
        height: 50,
        child: CircularProgressIndicator(
            // valueColor: AlwaysStoppedAnimation(mainBlue),
            // backgroundColor: mainBlue,
            ),
      ));
}
