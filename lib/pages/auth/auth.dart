import 'package:flutter/material.dart';

import '../../classes/functions.dart';
import '../../classes/dataTypes.dart';
import 'login.dart';
import 'register.dart';

class Auth extends StatefulWidget {
  @override
  _AuthState createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  @override
  void initState() {
    statusSet(trans);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: decorImage(img: 'assets/images/stadium.jpg'),
//    color: black,
      child: WillPopScope(
        onWillPop: () async {
          statusSet(white);
          return true;
        },
        child: Scaffold(
          backgroundColor: trans,
          body: Container(
            width: max,
            height: max,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                sizeh(doubleHeight(12)),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: doubleWidth(4)),
                  child: Text(
                    'Experience being a fan like never before',
                    style: TextStyle(
                        color: white,
                        fontWeight: FontWeight.bold,
                        fontSize: doubleWidth(11)),
                  ),
                ),
                sizeh(doubleHeight(4)),
                Container(
                  width: max,
                  margin: EdgeInsets.symmetric(horizontal: doubleWidth(4.5)),
                  child: Text('A place made just for fans',
                      textAlign: TextAlign.left,
                      style: TextStyle(color: white, fontSize: doubleWidth(5))),
                ),
                sizeh(doubleHeight(12)),
                Container(
                  width: max,
                  height: doubleHeight(8),
                  padding: EdgeInsets.symmetric(horizontal: doubleWidth(4.5)),
                  child: Container(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    child: RaisedButton(
                      onPressed: () {
                        Go.push(context, Register());
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      color: mainBlue,
                      child: Text(
                        'Sign Up',
                        style:
                            TextStyle(fontSize: doubleWidth(5), color: white),
                      ),
                    ),
                  ),
                ),
                sizeh(doubleHeight(2)),
                Container(
                  width: max,
                  height: doubleHeight(8),
                  padding: EdgeInsets.symmetric(horizontal: doubleWidth(4.5)),
                  child: Container(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    child: RaisedButton(
                      onPressed: () {
                        Go.push(context, Login());
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      color: white,
                      child: Text(
                        'Login',
                        style: TextStyle(
                            fontSize: doubleWidth(5), color: mainBlue),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
