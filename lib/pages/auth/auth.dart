import 'package:flutter/material.dart';

import '../../classes/functions.dart';
import '../../classes/dataTypes.dart';
import '../../ui_items/dialogs/privacy.dart';
import '../../ui_items/dialogs/team.dart';
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
            child: Stack(
              children: [
                Column(
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
                      child: Text('Feel the buzz of the beautiful game',
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
                        child: ElevatedButton(
                          onPressed: () {
                            Go.push(context, Register());
                          },
                          style: ButtonStyle(
                            shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                              backgroundColor: MaterialStatePropertyAll(mainBlue)
                          ),
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
                        child: ElevatedButton(
                          style: ButtonStyle(
                            shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                              backgroundColor: MaterialStatePropertyAll(white)
                          ),
                          onPressed: () {
                            Go.push(context, Login());
                            // Go.push(context, VerifyOtp(isRegister: false, username: 'asd', password: 'asdasd'));

                          },
                          
                          child: Text(
                            'Login',
                            style: TextStyle(
                                fontSize: doubleWidth(5), color: mainBlue),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: doubleHeight(8)),

                  ],
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Divider(
                        color: gray,
                        height: doubleHeight(6),
                        indent: doubleWidth(6),
                        endIndent: doubleWidth(6),
                        thickness: doubleHeight(0.2),
                      ), //Privacy
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'By signing up you agree to our ',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: white,
                              fontSize: doubleWidth(3),
                            ),
                          ),
                          GestureDetector(
                            onTap: (){
                              showDialog(context: context, builder: (_)=>TeamDialog());
                            },
                            child: Text('Terms of Use',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: mainGreen1,fontWeight: FontWeight.bold,
                                    fontSize: doubleWidth(3),
                                    fontStyle: FontStyle.italic)),
                          ),
                          Text(
                            ' and',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: white,
                              fontSize: doubleWidth(3),
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: (){
                          showDialog(context: context, builder: (_)=>Privacy());
                        },
                        child: Text('Privacy Policy',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: mainGreen1,fontWeight: FontWeight.bold,
                                fontSize: doubleWidth(3),
                                fontStyle: FontStyle.italic)),
                      ),
                      sizeh(doubleHeight(7)),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
