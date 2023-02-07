import 'package:flutter/material.dart';
import 'package:shooting_app/classes/services/my_service.dart';
import 'package:shooting_app/classes/states/google_sign_in_state.dart';
import 'package:shooting_app/pages/AppPage.dart';
import 'package:shooting_app/pages/auth/forgot_password.dart';
import 'package:shooting_app/pages/auth/verify_otp.dart';
import 'package:shooting_app/ui_items/my_toast.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
// import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'dart:io' as io;
import '../../classes/functions.dart';
import '../../classes/services/authentication_service.dart';
import '../../classes/dataTypes.dart';
import '../../main.dart';
import '../../ui_items/dialogs/privacy.dart';
import '../../ui_items/dialogs/team.dart';
import 'register.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  GlobalKey<MyToastState> key = GlobalKey<MyToastState>();
  MyService service = getIt<MyService>();
  @override
  void initState() {
    statusSet(trans);
    super.initState();
  }

  bool loading = false, loadingGoogle = false, loadingApple = false;
  bool obscureText = true;
  String username = '', password = '';
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: decorImage(img: 'assets/images/stadium.jpg'),
      child: MyToast(
        key: key,
        child: Scaffold(
          backgroundColor: trans,
          body: SafeArea(
            child: Container(
              width: max,
              height: max,
              padding: EdgeInsets.symmetric(horizontal: doubleWidth(4.5)),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    SizedBox(height: doubleHeight(10)),
                    Text(
                      'WELCOME',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: doubleWidth(5),
                          color: white),
                    ),
                    sizeh(doubleHeight(5)),
                    ClipRRect(
                      child: Container(
                        width: max,
                        height: doubleHeight(7),
                        color: Color.fromRGBO(216, 216, 216, 1),
                        child: Center(
                          child: TextField(
                            style: TextStyle(color: Colors.black),
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
                            style: TextStyle(
                              color: Colors.black,
                            ),
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
                                  child: Icon(
                                    !obscureText
                                        ? Icons.remove_red_eye
                                        : Icons.visibility_off,
                                    color: black,
                                  ),
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
                            myToast(key, 'The Username field is required.');
                            return;
                          }
                          MyService service = getIt<MyService>();
                          bool back =
                              await AuthenticationService.forgotPassword(
                                  service, key, username.trim());
                          if (back) {
                            Go.pushSlideAnim(context,
                                ForgotPassword(username: username.trim()));
                          }
                        },
                        child: Text(
                          'Forgot Password?',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: mainGreen1,
                              fontSize: doubleWidth(3)),
                        ),
                      ),
                    ),
                    sizeh(doubleHeight(6)),
                    Container(
                      width: max,
                      height: doubleHeight(7),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10)),
                        child: ElevatedButton(
                          style: ButtonStyle(
                              shape: MaterialStatePropertyAll(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10))),
                              backgroundColor:
                                  MaterialStatePropertyAll(mainBlue)),
                          onPressed: () async {
                            if (username.trim() == '') {
                              myToast(key, 'The Username field is required.',
                                  isLong: true);
                              return;
                            }
                            if (password.trim() == '') {
                              if (io.Platform.isAndroid) {
                                await googleLogin();
                              } else {
                                await appleLogin();
                              }
                              return;
                            }
                            setState(() {
                              loading = true;
                            });
                            bool? back = await AuthenticationService.login(
                                service, key,
                                username: username, password: password);
                            setState(() {
                              loading = false;
                            });
                            if (back != null) {
                              if (back) {
                                bool bbo = await service.getToken();
                                if (bbo)
                                  Go.pushAndRemoveSlideAnim(
                                      context, AppPageBuilder());
                              } else {
                                Go.pushSlideAnim(
                                    context,
                                    VerifyOtp(
                                        isRegister: false,
                                        username: username,
                                        password: password));
                              }
                            }
                          },
                          child: loading
                              ? simpleCircle(color: mainGreen)
                              : Text(
                                  'Login',
                                  style: TextStyle(
                                      fontSize: doubleWidth(5), color: white),
                                ),
                        ),
                      ),
                    ),
                    sizeh(doubleHeight(3)),
                    ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            minimumSize: Size(double.maxFinite, 50)),
                        onPressed: () {
                          googleLogin();
                        },
                        icon: Container(
                          margin: EdgeInsets.only(right: doubleWidth(2)),
                          width: 24,
                          height: 24,
                          child: loadingGoogle
                              ? CircularProgressIndicator()
                              : Image.asset('assets/images/google.png'),
                        ),
                        label: Text(loadingGoogle ? '' : 'Log In with Google')),
                    sizeh(doubleHeight(1)),
                    if (io.Platform.isIOS)
                      if (loadingApple)
                        Container(
                          margin: EdgeInsets.only(right: doubleWidth(2)),
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(),
                        )
                      else
                        SignInWithAppleButton(
                          height: 50,
                          style: SignInWithAppleButtonStyle.white,
                          onPressed: () {
                            appleLogin();
                          },
                        ),
                    if (io.Platform.isIOS) sizeh(doubleHeight(2)),
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
                                      color: mainGreen1,
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic)),
                            ],
                            style: TextStyle(
                              color: white,
                              fontSize: doubleWidth(4.5),
                            )),
                      ),
                    ),
                    SizedBox(height: doubleHeight(4)),
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
                          onTap: () {
                            openUrl(
                    'https://footballbuzz.co/terms-of-use-for-football-buzz/');
                            // showDialog(
                            //     context: context, builder: (_) => TeamDialog());
                          },
                          child: Text('Terms of Use',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: mainGreen1,
                                  fontWeight: FontWeight.bold,
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
                      onTap: () {
                        openUrl('https://footballbuzz.co/privacypolicy/');
                        // showDialog(context: context, builder: (_) => Privacy());
                      },
                      child: Text('Privacy Policy',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: mainGreen1,
                              fontWeight: FontWeight.bold,
                              fontSize: doubleWidth(3),
                              fontStyle: FontStyle.italic)),
                    ),
                    // sizeh(doubleHeight(10)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  googleLogin() async {
    if (loadingGoogle) return;

    setState(() {
      loadingGoogle = true;
    });
    DataSignIn? backUser = await googleSign();
    setState(() {
      loadingGoogle = false;
    });

    if (backUser != null) {
      setState(() {
        loading = true;
      });
      MyService service = getIt<MyService>();
      var back = await AuthenticationService.registerWithGoogle(
          context, service, key,
          user: backUser);
      print('back');
      setState(() {
        loading = false;
      });
    }
  }

  appleLogin() async {
    if (loadingApple) return;

    setState(() {
      loadingApple = true;
    });
    print('asd1');

    DataSignIn? backUser = await appleSign();
    print('asd2');
    setState(() {
      loadingApple = false;
    });
    print('asd3');
    if (backUser != null) {
      setState(() {
        loading = true;
      });
      MyService service = getIt<MyService>();
      var back = await AuthenticationService.registerWithGoogle(
          context, service, key,
          user: backUser);
      print('back');
      setState(() {
        loading = false;
      });
    }
  }
}
