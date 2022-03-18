import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'dataTypes.dart';



late Size screenSize;
double doubleHeight1(double value, double screenHeight) {
  return (screenHeight * value) / 100;
}

double doubleWidth1(double value, double screenWidth) {
  return (screenWidth * value) / 100;
}
double hidd(double v, {double w: 0}) {
  if (w == 0) w = screenSize.height;

  double m = (w * v) / 100;
  return m;
}

double widd(double v, {double w: 0}) {
  if (w == 0) w = screenSize.width;

  double m = (w * v) / 100;
  return m;
}

//show_snackbar(BuildContext context, String text,
//    {floating = false, duration, SnackBarAction action}) {
//  Scaffold.of(context).showSnackBar(SnackBar(
//      content: Text(text),
//      behavior:
//          floating == true ? SnackBarBehavior.fixed : SnackBarBehavior.floating,
//      duration: duration,
//      action: action));
//}

final Stream<int> StreamTest = Stream.periodic(Duration(seconds: 3), (i) => i);

void pop(context) {
  Go.pop(context, false);
}




statusSet(Color color) async {
  try {
      WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: color,
    statusBarBrightness: Brightness.dark,
    statusBarIconBrightness: Brightness.dark,
  ));
  } on PlatformException catch (e) {
    debugPrint(e.toString());
  }
}


//Future<String> startUploadImage(File data)async{
//  String uploadEndPoint = '${address}upload.php';
//  var Data = await http.post(uploadEndPoint, body: {
//    "image": base64Encode(data.readAsBytesSync()),
//  }).catchError((error) {
//    print('null2');
//    toast(101);
//    return '';
//  });
//
//
//  print('resultresultresult  ${Data.body}');
//
//  print('${address}image${Data.body}.png');
//  String go = '${address}image${Data.body}.png';
//  return go;
//
//
//}
abstract class Go {



  static void pushAndRemoveSlideAnim(BuildContext context, Widget page,
      {bool full: false, var first, var second}) {
    if (first == null) first = Cubic(0.175, 0.885, 0.32, 1.1);
    if (second == null) second = Curves.easeOutCirc;
    Navigator.pushAndRemoveUntil(context, PageRouteBuilder(
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
        }), (route) => false).catchError((e) => print('Error 1 $e'));
  }

  static void pushSlideAnim(BuildContext context, Widget page,
      {bool full: false, var first, var second}) {
    if (first == null) first = Cubic(0.175, 0.885, 0.32, 1.1);
    if (second == null) second = Curves.easeOutCirc;
    Navigator.push(
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

  static void pushSlideAnimSheet(BuildContext context, Widget page,
      {bool full: false, var first, var second}) {
    if (first == null) first = Cubic(0.175, 0.885, 0.32, 1.1);
    if (second == null) second = Curves.easeOutCirc;
    Navigator.push(
        context,
        PageRouteBuilder(
            transitionDuration: Duration(seconds: 1),
            fullscreenDialog: false,

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

  static void pop(BuildContext context, dynamic data) {
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

double givePersent(int a,int b){
  print('givePersent');
  print('$a $b ');
  print('a*100');
  return (a*100)/b;
}
double givePersent1(int a,int b){
  return a/b;
}


String makeDayMounth(int data){
  if(data>=10){
    return data.toString();
  }else{
    String str = '0';
    return str+data.toString();
  }
}

String timeMake(dynamic time){
  return time.toString().replaceAll('-', '~');
}

String makeImageAddress(dynamic data){
  String temp = data.toString();
//  print('makeImageAddress: $temp');
//  print('contains ${temp.contains('unima.app')}');
  if(temp.contains('unima.app')){
    temp = temp.replaceAll("unima.app", "unimaapp.ir");
  }
//  print('makeImageAddress: $temp');
  return temp;
}

String priceMake(dynamic price){

  List<String> tempString = [];
  String priceS = price.toString();
//  print('''
//      ${priceS}
//      ${priceS.length}
//      ''');

  if(priceS.length<=3) return priceS;

  while(priceS.length>3) {
//    print('priceS.length ${priceS.length}');
    tempString.add(priceS.substring(priceS.length - 3, priceS.length));
//    print('qqq ${priceS.substring(0, priceS.length - 3)}');
    priceS = priceS.substring(0, priceS.length - 3);
  }
  String out=priceS;

  for(int j=tempString.length-1;j>=0;j--){
//    print('jjjj $j');
    out+=',';
    out+=tempString[j];

  }
//  print('out $out');
//  print('priceS.length ${priceS}');
//  print(tempString);

  return out;
}

class AlertAction {
  final String text;
  final dynamic value;
  AlertAction(this.text, this.value);
}
Future<dynamic> alert(context, title, content, List<AlertAction> actions) {
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
            title: title == ''
                ? null
                : Text(
              title,
              style: TextStyle(height: 1.2),
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
            ),
            content: Text(
              content,
              style: TextStyle(height: 2),
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
            ),
            actions: content == 'انتخاب کنید'
                ? [
              Center(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: actions
                      .map((e) => FlatButton(
                    child: Text(
                      e.text,
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.center,
                    ),
                    onPressed: () {
                      Go.pop(context, e.value);
                    },
                  ))
                      .toList(),
                ),
              )
            ]
                : actions
                .map((e) => FlatButton(
              child: Text(e.text),
              onPressed: () {
                Go.pop(context, e.value);
              },
            ))
                .toList());
      });
}

redmiAlert3(key,title,content,List<AlertAction> actions)async{
  double dd = 4;
  if(title!='')dd+=1;
  if(content!='')dd+=1;
  key.currentState.showBottomSheet((contex){
    return Container(
      decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          )
      ),
      width: max,
      height: hidd(5 * dd),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
//                                      sizeh(hidd(3)),
          if(title!='')
            Text(title,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 25,
                  fontFamily: aviny,
                  color: black,
                  fontWeight: FontWeight.w500
              ),),
          if(content!='')
            Text(content,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 20,
                  fontFamily: yekan,
                  color: black,
                  fontWeight: FontWeight.w400
              ),),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                onPressed: (){
                  actions[0].value();
                },
                elevation: 0,
                color: Color.fromRGBO(240, 240, 240, 1),
                shape: StadiumBorder(),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: widd(9),vertical: hidd(1.8)),
                  child: Text(actions[0].text,
                    style: TextStyle(
                        fontSize: 20,
                        fontFamily: yekan,
                        color: Color.fromRGBO(80, 80, 80, 1),
                        fontWeight: FontWeight.w400
                    ),),
                ),
              ),
              RaisedButton(
                onPressed: (){
                  actions[1].value();
                },
                elevation: 0,
                color: Color.fromRGBO(240, 240, 240, 1),
                shape: StadiumBorder(),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: widd(9),vertical: hidd(1.8)),
                  child: Text(actions[1].text,
                    style: TextStyle(
                        fontSize: 20,
                        fontFamily: yekan,
                        color: Colors.lightBlue,
                        fontWeight: FontWeight.w400
                    ),),
                ),
              ),
            ],
          ),
          RaisedButton(
            onPressed: (){
              actions[2].value();
            },
            elevation: 0,
            color: Color.fromRGBO(240, 240, 240, 1),
            shape: StadiumBorder(),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: widd(9),vertical: hidd(1.8)),
              child: Text(actions[2].text,
                style: TextStyle(
                    fontSize: 20,
                    fontFamily: yekan,
                    color: pink,
                    fontWeight: FontWeight.w400
                ),),
            ),
          ),
        ],
      ),
    );
  },shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(30),
        topRight: Radius.circular(30),
      )
  ));
}

redmiAlert2(key,title,content,List<AlertAction> actions)async{
  double dd = 3;
  if(title!='')dd+=1;
  if(content!='')dd+=1;
  key.currentState.showBottomSheet((contex){
    return Container(
      decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          )
      ),
      width: max,
      height: hidd(5 * dd),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
//                                      sizeh(hidd(3)),
          if(title!='')
            Text(title,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 25,
                  fontFamily: aviny,
                  color: black,
                  fontWeight: FontWeight.w500
              ),),
          if(content!='')
            Text(content,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 20,
                  fontFamily: yekan,
                  color: black,
                  fontWeight: FontWeight.w400
              ),),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                onPressed: (){
                  actions[0].value();
                },
                elevation: 0,
                color: Color.fromRGBO(240, 240, 240, 1),
                shape: StadiumBorder(),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: widd(9),vertical: hidd(1.8)),
                  child: Text(actions[0].text,
                    style: TextStyle(
                        fontSize: 20,
                        fontFamily: yekan,
                        color: Color.fromRGBO(80, 80, 80, 1),
                        fontWeight: FontWeight.w400
                    ),),
                ),
              ),
              RaisedButton(
                onPressed: (){
                  actions[1].value();
                },
                elevation: 0,
                color: Color.fromRGBO(240, 240, 240, 1),
                shape: StadiumBorder(),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: widd(9),vertical: hidd(1.8)),
                  child: Text(actions[1].text,
                    style: TextStyle(
                        fontSize: 20,
                        fontFamily: yekan,
                        color: Colors.lightBlue,
                        fontWeight: FontWeight.w400
                    ),),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  },shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(30),
        topRight: Radius.circular(30),
      )
  ));
}





//Future<File> MyImagePicker(context,{String val='لطفا عکسی را انتخاب کنید'}){
//  return showDialog(
//      context: context,
//      barrierDismissible: false,
//      builder: (context) {
//        return AlertDialog(
//          title: Text(
//            val,
//            style: TextStyle(height: 1.2),
//            textAlign: TextAlign.right,
//            textDirection: TextDirection.rtl,
//          ),
//          content: Column(
//            mainAxisSize: MainAxisSize.min,
//            children: <Widget>[
//              FlatButton(
//                child: Text('گرفتن از دوربین ...',
//                    textDirection:
//                    TextDirection.rtl,
//                    textAlign: TextAlign.center,
//                    style:
//                    TextStyle(fontSize: 18)),
//                onPressed: () async{
//                  File temp =await
//                  ImagePicker.pickImage(
//                      source: ImageSource
//                          .camera);
//                  temp = await testCompressAndGetFile(temp, 40);
//                  Go.pop(context,temp);
//                },
//              ),
//              FlatButton(
//                child: Text(
//                  'انتخاب از گالری تصاویر ...',
//                  textDirection:
//                  TextDirection.rtl,
//                  textAlign: TextAlign.center,
//                  style: TextStyle(fontSize: 18),
//                ),
//                onPressed: () async{
//                  File temp =
//                  await ImagePicker.pickImage(
//                      source: ImageSource
//                          .gallery);
//                  temp = await testCompressAndGetFile(temp, 40);
//                  Go.pop(context,temp);
//                },
//              ),
//            ],
//          ),
//          actions: <Widget>[
//            Directionality(
//              textDirection: TextDirection.rtl,
//              child: FlatButton(
//                child: Text(
//                  'منصرف شدم',
//                  textDirection:
//                  TextDirection.rtl,
//                  textAlign: TextAlign.center,
//                ),
//                onPressed: () {
//                  Go.pop(context, null);
//                },
//              ),
//            )
//          ],
//        );
//      });
//}

//void url_luncher(String domain) async {
//  final fakeUrl = "$domain";
//  if (await canLaunch(fakeUrl)) {
//    launch(fakeUrl);
//  }
//}


int j = 1;

