import 'package:flutter/material.dart';
import 'package:shooting_app/classes/services/my_service.dart';
import 'package:shooting_app/pages/AppPage.dart';
import 'package:shooting_app/pages/auth/forgot_password.dart';
import 'package:shooting_app/pages/auth/verify_otp.dart';

import '../../classes/functions.dart';
import '../../classes/services/authentication_service.dart';
import '../../classes/dataTypes.dart';
import '../../main.dart';
import 'register.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  MyService service = getIt<MyService>();
  @override
  void initState() {
    statusSet(trans);
    super.initState();
  }

  bool obscureText = true;
  String username = '', password = '';
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: decorImage(img: 'assets/images/stadium.jpg'),
      child: Scaffold(
        backgroundColor: trans,
        body: Stack(
          children: <Widget>[
            Container(
              width: max,
              height: max,
              padding: EdgeInsets.symmetric(horizontal: doubleWidth(4.5)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  sizeh(doubleHeight(5)),
                  ClipRRect(
                    child: Container(
                      width: max,
                      height: doubleHeight(7),
                      color: Color.fromRGBO(216, 216, 216, 1),
                      child: Center(
                        child: TextField(
                          onChanged: (e) {
                            username = e;
                          },
                          decoration: InputDecoration(
                              prefixText: '        ',
                              border: InputBorder.none,
                              hintText: 'Username'),
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
                          keyboardType: TextInputType.visiblePassword,
                          onChanged: (e) {
                            password = e;
                          },
                          obscureText: obscureText,
                          decoration: InputDecoration(
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    obscureText = !obscureText;
                                  });
                                },
                                child: Icon(!obscureText
                                    ? Icons.remove_red_eye
                                    : Icons.visibility_off),
                              ),
                              prefixText: '        ',
                              border: InputBorder.none,
                              hintText: 'Password'),
                        ),
                      ),
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  // SizedBox(height: doubleHeight(1)),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () async {
                        if (username.trim() == '') {
                          toast('The Username field is required.');
                          return;
                        }
                        MyService service = getIt<MyService>();
                        bool back = await AuthenticationService.forgotPassword(
                            service, username.trim());
                        if (back) {
                          Go.pushSlideAnim(context,
                              ForgotPassword(username: username.trim()));
                        }
                      },
                      child: Text(
                        'Forgot Password?',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            color: mainGreen, fontSize: doubleWidth(3)),
                      ),
                    ),
                  ),
                  sizeh(doubleHeight(6)),
                  Container(
                    width: max,
                    height: doubleHeight(8),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10)),
                      child: RaisedButton(
                        onPressed: () async {
                          if (username.trim() == '') {
                            toast('The Username field is required.');
                            return;
                          }
                          if (password.trim() == '') {
                            toast('The Password field is required.');
                            return;
                          }
                          bool? back = await AuthenticationService.login(
                              service,
                              username: username,
                              password: password);
                          if (back != null) {
                            if (back) {
                              bool bbo = await service.getToken();
                              if (bbo)
                                Go.pushSlideAnim(context, AppPageBuilder());
                            } else {
                              Go.pushSlideAnim(
                                  context,
                                  VerifyOtp(
                                      username: username, password: password));
                            }
                          }
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        color: mainBlue,
                        child: Text(
                          'Login',
                          style:
                              TextStyle(fontSize: doubleWidth(5), color: white),
                        ),
                      ),
                    ),
                  ),
                  sizeh(doubleHeight(3)),
                  GestureDetector(
                    onTap: () {
                      Go.replace(context, Register());
                    },
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                          children: [
                            TextSpan(text: 'Don\'t have an account?  '),
                            TextSpan(
                                text: 'Sign Up',
                                style: TextStyle(
                                    color: mainGreen,
                                    fontStyle: FontStyle.italic)),
                          ],
                          style: TextStyle(
                            color: white,
                            fontSize: doubleWidth(4.5),
                          )),
                    ),
                  ),
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
