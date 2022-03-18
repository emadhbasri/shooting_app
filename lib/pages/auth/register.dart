
import 'package:flutter/material.dart';

import '../../classes/functions.dart';
import '../../dataTypes.dart';
import 'login.dart';
import 'team.dart';
class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  @override
  void initState() {
    statusSet(trans);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: decorImage(img: 'images/stadium.jpg'),
      child: Scaffold(
        backgroundColor: trans,
        body: Stack(
          children: <Widget>[
            Container(
              width: max,
              height: max,
              padding: EdgeInsets.symmetric(horizontal: doubleWidth(4.5)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[

                  ClipRRect(
                    child: Container(
                      width: max,
                      height: doubleHeight(7),
                      color: Color.fromRGBO(216, 216, 216, 1),
                      child: Center(
                        child: TextField(
                          decoration: InputDecoration(
                              prefixText: '        ',
                              border: InputBorder.none,
                              hintText: 'Name'
                          ),
                        ),
                      ),
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  sizeh(doubleHeight(2)),
                  ClipRRect(
                    child: Container(
                      width: max,
                      height: doubleHeight(7),
                      color: Color.fromRGBO(216, 216, 216, 1),
                      child: Center(
                        child: TextField(
                          decoration: InputDecoration(
                              prefixText: '        ',
                              border: InputBorder.none,
                              hintText: 'Username'
                          ),
                        ),
                      ),
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  sizeh(doubleHeight(2)),
                  ClipRRect(
                    child: Container(
                      width: max,
                      height: doubleHeight(7),
                      color: Color.fromRGBO(216, 216, 216, 1),
                      child: Center(
                        child: TextField(
                          decoration: InputDecoration(
                              prefixText: '        ',
                              border: InputBorder.none,
                              hintText: 'Email'
                          ),
                        ),
                      ),
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  Container(
                    width: max,
                    child: Text(
                      'Use Phone Number?',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: mainGreen,
                        fontSize: doubleWidth(3)
                      ),
                    ),
                  ),
                  sizeh(doubleHeight(2)),
                  ClipRRect(
                    child: Container(
                      width: max,
                      height: doubleHeight(7),
                      color: Color.fromRGBO(216, 216, 216, 1),
                      child: Center(
                        child: TextField(
                          decoration: InputDecoration(
                            prefixText: '        ',
                            border: InputBorder.none,
                            hintText: 'Password'
                          ),
                        ),
                      ),
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  sizeh(doubleHeight(7)),
                  Container(
                    width: max,
                    height: doubleHeight(8),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10)),
                      child: RaisedButton(
                        onPressed: () {
                          Go.push(context, Team());
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        color: mainBlue,
                        child: Text(
                          'Register',
                          style: TextStyle(fontSize: doubleWidth(5), color: white),
                        ),
                      ),
                    ),
                  ),
                  sizeh(doubleHeight(3)),
                  GestureDetector(
                    onTap: (){
                      Go.replace(context, Login());
                    },
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                          children:[
                            TextSpan(
                                text: 'Already have an account?  '
                            ),
                            TextSpan(
                                text: 'Log In',
                                style: TextStyle(
                                    color: mainGreen,
                                    fontStyle: FontStyle.italic
                                )
                            ),
                          ],
                          style: TextStyle(
                            color: white,
                            fontSize: doubleWidth(4.5),
                          )
                      ),
                    ),
                  ),
                  Divider(
                    color: gray,
                    height: doubleHeight(6),
                    indent: doubleWidth(6),
                    endIndent: doubleWidth(6),
                    thickness: doubleHeight(0.2),
                  ),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children:[
                        TextSpan(
                          text: 'By signing up you agree to our '
                        ),
                        TextSpan(
                          text: 'Terms of Use',
                          style: TextStyle(
                            color: mainGreen,
                            fontStyle: FontStyle.italic
                          )
                        ),
                        TextSpan(
                          text: ' and'
                        ),
                        TextSpan(
                            text: '\nPrivacy Policy',
                            style: TextStyle(
                                color: mainGreen,
                                fontStyle: FontStyle.italic
                            )
                        ),
                      ],
                      style: TextStyle(
                        color: white,
                        fontSize: doubleWidth(3),
                      )
                    ),
                  ),
                  sizeh(doubleHeight(7)),
                ],
              ),
            ),
            Align(
              alignment: Alignment(0, -0.7),
              child: Text(
                'WELCOME',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                    fontSize: doubleWidth(5),
                    color: white),
              ),
            )
          ],
        ),
      ),
    );
  }
}
