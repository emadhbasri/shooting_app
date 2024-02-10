import 'dart:async';
import 'dart:io';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:share_plus/share_plus.dart';
import 'package:provider/provider.dart';
import 'dataTypes.dart';
import '../pages/profile/profile.dart';
import 'package:url_launcher/url_launcher.dart';

import 'states/theme_state.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
export 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum TextType { link, groupLink, user, text }

class TheText {
  final TextType type;
  final String text;

  TheText({required this.type, required this.text});
}

List<TheText> makeText(String text) {
  List<TheText> out = [];
  List<String> split = text.split(' ');
  split.forEach((e) {
    if (e.contains('\n')) {
      List<String> split1 = e.split('\n');
      if (split1.isNotEmpty)
        split1.forEach((String f) {
          if (f.length == 0) {
            out.add(TheText(type: TextType.text, text: ''));
          } else {
            if (f[0] == '@') {
              out.add(TheText(type: TextType.user, text: f));
            } else if (f.contains('http://') || f.contains('https://')) {
              out.add(TheText(type: TextType.link, text: f.trim()));
            } else if (f.contains('https://footballbuzz.co?joinchat=')) {
              out.add(TheText(type: TextType.groupLink, text: f));
            } else {
              out.add(TheText(type: TextType.text, text: f));
            }
          }
        });
    } else {
      if (e.length == 0) {
        out.add(TheText(type: TextType.text, text: ''));
      } else {
        if (e[0] == '@') {
          out.add(TheText(type: TextType.user, text: e));
        } else if (e.contains('http://') || e.contains('https://')) {
          out.add(TheText(type: TextType.link, text: e.trim()));
        } else if (e.contains('https://footballbuzz.co?joinchat=')) {
          out.add(TheText(type: TextType.groupLink, text: e));
        } else {
          out.add(TheText(type: TextType.text, text: e));
        }
      }
    }
  });
  return out;
}

openUrl(String url) async {
  if (await canLaunchUrl(Uri.parse(url))) {
    launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }
}

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
      child: Center(child: CircularProgressIndicator()),
    ),
  );
}

Widget simpleCircle({Color? color, double? size}) {
  if (size != null) {
    return SizedBox(
      width: size,
      height: size,
      child: Center(
          child: CircularProgressIndicator(
        color: color,
      )),
    );
  } else {
    return Center(
        child: CircularProgressIndicator(
      color: color,
    ));
  }
}

profilePlaceHolder(BuildContext context, {bool isBig = false}) => Image.asset(
      isBig ? 'assets/images/playerbig.png' : 'assets/images/player.png',
      fit: BoxFit.fill,
      color: context.watch<ThemeState>().isDarkMode ? Colors.black : Colors.white,
    );

String makeDurationToString(DateTime date) {
  if (date.isAfter(DateTime.now())) {
    return '';
  }
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

String getWeekString(DateTime date) {
  switch (date.weekday) {
    case 1:
      return 'Mon';
    case 2:
      return 'Tue';
    case 3:
      return 'Wed';
    case 4:
      return 'Thu';
    case 5:
      return 'Fri';
    case 6:
      return 'Sat';
    case 7:
      return 'Sun';
    default:
      return '';
  }
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

copyText( String text,context, {String? payam}) {
  payam ??= AppLocalizations.of(context)!.textcopy;
  return FlutterClipboard.copy(text).then((value) => toast(payam!));
}

sharePost(context,String text, {String payam = 'Post'}) =>
    Share.share('${AppLocalizations.of(context)!.check_out_the} $payam $text');

toast(String str, {bool isLong = false}) {
  Fluttertoast.showToast(
      msg: str,
      toastLength: isLong ? Toast.LENGTH_LONG : Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: mainGreen1,
      textColor: black,
      fontSize: 16.0);
}
// toast(String str, context,{bool isLong=false}) {
//   ToastContext tt =ToastContext();
//   tt.init(context);
//   Toast.show(str,
//     duration: isLong?Toast.lengthLong:Toast.lengthShort,
//     backgroundColor: mainGreen1,
//     textStyle: const TextStyle(color: black,fontSize: 16),
//     backgroundRadius: 10,
//   );
// }

gogo(BuildContext context, String str, bool isUser) {
  // if (isUser) {
  Go.pushSlideAnim(context, ProfileBuilder(username: str));
  // } else {
  //   Go.pushSlideAnim(
  //       context,
  //       Search(
  //         search: str,
  //       ));
  // }
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
            pageBuilder: (context, Animation<double> animation, Animation<double> secendAnimation) {
              return page;
            },
            transitionsBuilder: (context, Animation<double> animation,
                Animation<double> secendAnimation, Widget widget) {
              return SlideTransition(
                position: Tween(begin: Offset(1, 0), end: Offset(0, 0)).animate(CurvedAnimation(
                    curve: first, //Curves.easeOutBack
                    parent: animation,
                    reverseCurve: second)),
                child: widget,
              );
            }),
        (route) => false).catchError((e) => print('Error 1 $e'));
  }

  static Future<dynamic> pushSlideAnim(BuildContext context, Widget page,
      {bool full: false, var first, var second}) async {
    if (first == null) first = Cubic(0.175, 0.885, 0.32, 1.1);
    if (second == null) second = Curves.easeOutCirc;
    print('Platform.isIOS ${Platform.isIOS}');
    if (Platform.isIOS) {
      return await Navigator.push(
              context, MaterialPageRoute(builder: (context) => page, fullscreenDialog: full))
          .catchError((e) => print('Error 1 $e'));
    }
    return await Navigator.push(
        context,
        PageRouteBuilder(
            transitionDuration: Duration(seconds: 1),
            fullscreenDialog: full,
            pageBuilder: (context, Animation<double> animation, Animation<double> secendAnimation) {
              return page;
            },
            transitionsBuilder: (context, Animation<double> animation,
                Animation<double> secendAnimation, Widget widget) {
              return SlideTransition(
                position: Tween(begin: Offset(1, 0), end: Offset(0, 0)).animate(CurvedAnimation(
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
          pageBuilder: (context, Animation<double> animation, Animation<double> secendAnimation) {
            return page;
          },
        ));
    // transitionsBuilder: (context, Animation<double> animation,
    //     Animation<double> secendAnimation, Widget widget) {
    //   return widget;
    // })).catchError((e) => print('Error 1 $e'));
  }

  static Future<dynamic> pushSlideAnimSheet(BuildContext context, Widget page,
      {bool full= false, var first, var second, Duration? reverseTransitionDuration}) async {
    reverseTransitionDuration ??= Duration(milliseconds: 300);
    if (first == null) first = Cubic(0.175, 0.885, 0.32, 1.1);
    if (second == null) second = Curves.easeOutCirc;
    return await Navigator.push(
        context,
        PageRouteBuilder(
            transitionDuration: Duration(seconds: 1),
            fullscreenDialog: false,
            barrierColor: Colors.black.withOpacity(0.5),
            barrierDismissible: true,
            opaque: false,
            pageBuilder: (context, Animation<double> animation, Animation<double> secendAnimation) {
              return page;
            },
            reverseTransitionDuration: reverseTransitionDuration,
            transitionsBuilder: (context, Animation<double> animation,
                Animation<double> secendAnimation, Widget widget) {
              return SlideTransition(
                position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(CurvedAnimation(
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
            pageBuilder: (context, Animation<double> animation, Animation<double> secendAnimation) {
              return page;
            },
            transitionsBuilder: (context, Animation<double> animation,
                Animation<double> secendAnimation, Widget widget) {
              return SlideTransition(
                position: Tween(begin: Offset(1, 0), end: Offset(0, 0)).animate(CurvedAnimation(
                    curve: first, //Curves.easeOutBack
                    parent: animation,
                    reverseCurve: second)),
                child: widget,
              );
            })).catchError((e) => print('Error 1 $e'));
  }

  static dynamic push(BuildContext context, Widget page, {bool full: false}) async {
    return await Navigator.push(
            context, MaterialPageRoute(builder: (context) => page, fullscreenDialog: full))
        .catchError((e) => print('Error 1 $e'));
  }

  static void pushHero(BuildContext context, Widget page, Duration dur, {bool full: false}) {
    Navigator.push(
        context,
        PageRouteBuilder(
          transitionDuration: dur,
          pageBuilder: (_, __, ___) => page,
          fullscreenDialog: full,
        ));
  }

  static void replace(BuildContext context, Widget newPage, {bool full: false}) {
    Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => newPage, fullscreenDialog: full))
        .catchError((e) => print('Error 2 $e'));
  }

  static void replaceHero(BuildContext context, Widget newPage, Duration dur, {bool full: false}) {
    Navigator.pushReplacement(
        context,
        PageRouteBuilder(
            transitionDuration: dur, pageBuilder: (_, __, ___) => newPage, fullscreenDialog: full));
  }

  static void pop(BuildContext context, [dynamic data]) {
    Navigator.pop(context, data);
  }

  static bool canPop(BuildContext context) {
    return Navigator.canPop(context);
  }

  static Future popAndPushNamed_(BuildContext context, Widget page, {bool full: false}) {
    return Navigator.popAndPushNamed(context, '');
  }

  static void removeRoute(BuildContext context, Widget page) {
    Navigator.removeRoute(context, MaterialPageRoute(builder: (context) => page));
  }

  static void removeRouteBelow(BuildContext context, Widget page) {
    Navigator.removeRouteBelow(context, MaterialPageRoute(builder: (context) => page));
  }

  static void replaceRouteBelow(BuildContext context, Widget oldPage, Widget newPage) {
    Navigator.replaceRouteBelow(context,
        anchorRoute: MaterialPageRoute(builder: (context) => oldPage),
        newRoute: MaterialPageRoute(builder: (context) => newPage));
  }

  static void pushAndRemove(BuildContext context, Widget page) {
    Navigator.of(context)
        .pushAndRemoveUntil(MaterialPageRoute(builder: (context) => page), (route) => false);
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
