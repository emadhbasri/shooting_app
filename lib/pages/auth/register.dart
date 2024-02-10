import 'dart:io' as io;
import 'package:shooting_app/classes/states/google_sign_in_state.dart';
import 'package:shooting_app/pages/auth/verify_otp.dart';
import 'package:shooting_app/ui_items/shots/index.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../../classes/services/authentication_service.dart';
import '../../classes/services/my_service.dart';
import '../../main.dart';
import '../../ui_items/my_toast.dart';
import 'login.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  GlobalKey<MyToastState> key = GlobalKey<MyToastState>();

  TextEditingController name = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();
  // TextEditingController phone = TextEditingController();
  TextEditingController password = TextEditingController();
  bool obscureText = true;
  @override
  void initState() {
    statusSet(trans);
    super.initState();
  }

  bool loading = false, loadingGoogle = false, loadingApple = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: decorImage(img: 'assets/images/stadium.jpg'),
      child: MyToast(
        key: key,
        child: Scaffold(
          backgroundColor: trans,
          body: Container(
            width: max,
            height: max,
            alignment: Alignment.bottomCenter,
            padding: EdgeInsets.symmetric(horizontal: doubleWidth(4.5)),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(
                    AppLocalizations.of(context)!.welcome,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: doubleWidth(5),
                        color: white),
                  ),
                  SizedBox(height: doubleHeight(3)),
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
                          controller: name,
                          decoration: InputDecoration(
                              prefixText: '        ',
                              border: InputBorder.none,
                              hintText: AppLocalizations.of(context)!.fullname),
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
                          controller: username,
                          decoration: InputDecoration(
                              prefixText: '        ',
                              border: InputBorder.none,
                              hintText: AppLocalizations.of(context)!.username),
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
                          keyboardType: TextInputType.emailAddress,
                          controller: email,
                          decoration: InputDecoration(
                              prefixText: '        ',
                              border: InputBorder.none,
                              hintText: AppLocalizations.of(context)!.email),
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
                          controller: password,
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
                              hintText: AppLocalizations.of(context)!.password),
                        ),
                      ),
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () async {
                        if (username.value.text.trim() == '') {
                          myToast(key, AppLocalizations.of(context)!.the_username_field_is_required);
                          return;
                        } else if (password.value.text.trim() == '') {
                          myToast(key, AppLocalizations.of(context)!.the_password_field_is_required);
                          return;
                        }
                        Go.pushSlideAnim(
                            context,
                            VerifyOtp(
                              username: username.value.text.trim(),
                              password: password.value.text.trim(),
                              isRegister: true,
                            ));
                      },
                      child: Text(
                        AppLocalizations.of(context)!.register_with_otp,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: mainGreen1,
                            fontSize: doubleWidth(3)),
                      ),
                    ),
                  ),
                  sizeh(doubleHeight(2)),
                  Container(
                    width: max,
                    height: doubleHeight(8),
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
                          // if (phone.value.text.trim()!='') {
                          //   if (!phone.value.text.trim().contains('+') ||
                          //       phone.value.text.trim().length < 12) {
                          //     myToast(key,'The phoneNumber is not a valid.');
                          //     return;
                          //   }
                          // }
                          setState(() {
                            loading = true;
                          });
                          MyService service = getIt<MyService>();
                          bool back =
                              await AuthenticationService.register(service, key,context,
                                  fullName: name.value.text.trim(),
                                  userName: username.value.text.trim(),
                                  phoneNumber: '', //phone.value.text.trim()
                                  email: email.value.text.trim(),
                                  password: password.value.text.trim(),
                                  confirmPassword: password.value.text.trim());
                          setState(() {
                            loading = false;
                          });
                          if (back) {
                            Go.pushSlideAnim(
                                context,
                                VerifyOtp(
                                  username: username.value.text.trim(),
                                  password: password.value.text.trim(),
                                  isRegister: true,
                                ));
                          } else {
                            print('nononono');
                          }
                        },
                        child: loading
                            ? simpleCircle(color: mainGreen)
                            : Text(
                                AppLocalizations.of(context)!.signup,
                                style: TextStyle(
                                    fontSize: doubleWidth(5), color: white),
                              ),
                      ),
                    ),
                  ),
                  if (io.Platform.isIOS)
                    sizeh(doubleHeight(1))
                  else
                    sizeh(doubleHeight(2)),
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
                      label: Text(loadingGoogle ? '' : AppLocalizations.of(context)!.signup_with_google)),

                  if (io.Platform.isIOS)
                    sizeh(doubleHeight(1))
                  else
                    sizeh(doubleHeight(2)),
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
                        text: AppLocalizations.of(context)!.sign_in_with_apple,
                        style: SignInWithAppleButtonStyle.white,
                        onPressed: () {
                          appleLogin();
                        },
                      ),
                  if (io.Platform.isIOS)
                    sizeh(doubleHeight(1))
                  else
                    sizeh(doubleHeight(2)),
                  GestureDetector(
                    onTap: () {
                      Go.replace(context, Login());
                    },
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                          children: [
                            TextSpan(text:
                            AppLocalizations.of(context)!.already_have_account
                            ),
                            TextSpan(
                                text:
                                AppLocalizations.of(context)!.login
                                ,
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
                  Divider(
                    color: gray,
                    height: doubleHeight(6),
                    indent: doubleWidth(6),
                    endIndent: doubleWidth(6),
                    thickness: doubleHeight(0.2),
                  ), //Privacy
                  Wrap(
                    // mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.signing_agree,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: white,
                          fontSize: doubleWidth(3),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          String out =
                                  "https://footballbuzz.co/terms-of-use-footballbuzz";
                              openUrl(out);
                          // openUrl(
                    // 'https://footballbuzz.co/terms-of-use-for-football-buzz/');
                        },
                        child: Text(AppLocalizations.of(context)!.terms_of_use,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: mainGreen1,
                                fontWeight: FontWeight.bold,
                                fontSize: doubleWidth(3),
                                fontStyle: FontStyle.italic)),
                      ),
                      Text(
                        AppLocalizations.of(context)!.and,
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
                      String out =
                              "https://footballbuzz.co/privacy-policy";

                          openUrl(out);
                      // openUrl('https://footballbuzz.co/privacypolicy/');
                      // showDialog(context: context, builder: (_) => Privacy());
                    },
                    child: Text(AppLocalizations.of(context)!.privacy_policy,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: mainGreen1,
                            fontWeight: FontWeight.bold,
                            fontSize: doubleWidth(3),
                            fontStyle: FontStyle.italic)),
                  ),
                  sizeh(doubleHeight(7)),
                ],
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
    DataSignIn? backUser = await appleSign();
    setState(() {
      loadingApple = false;
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
}
