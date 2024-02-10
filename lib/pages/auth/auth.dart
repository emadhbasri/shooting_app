import 'package:flutter/material.dart';
import 'package:shooting_app/classes/states/theme_state.dart';
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
                        AppLocalizations.of(context)!.dxperience_being_fan,
                        style: TextStyle(
                            color: white, fontWeight: FontWeight.bold, fontSize: doubleWidth(11)),
                      ),
                    ),
                    sizeh(doubleHeight(4)),
                    Container(
                      width: max,
                      margin: EdgeInsets.symmetric(horizontal: doubleWidth(4.5)),
                      child: Text(AppLocalizations.of(context)!.feel_the_buzz,
                          textAlign: TextAlign.left,
                          style: TextStyle(color: white, fontSize: doubleWidth(5))),
                    ),
                    sizeh(doubleHeight(8)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: doubleWidth(4.5)),
                      child: ChangeLang(),
                    ),
                    sizeh(doubleHeight(2)),
                    Container(
                      width: max,
                      height: doubleHeight(8),
                      padding: EdgeInsets.symmetric(horizontal: doubleWidth(4.5)),
                      child: Container(
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                        child: ElevatedButton(
                          onPressed: () {
                            Go.push(context, Register());
                          },
                          style: ButtonStyle(
                              shape: MaterialStatePropertyAll(
                                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                              backgroundColor: MaterialStatePropertyAll(mainBlue)),
                          child: Text(
                            AppLocalizations.of(context)!.signup,
                            // 'Sign Up',
                            style: TextStyle(fontSize: doubleWidth(5), color: white),
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
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                        child: ElevatedButton(
                          style: ButtonStyle(
                              shape: MaterialStatePropertyAll(
                                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                              backgroundColor: MaterialStatePropertyAll(white)),
                          onPressed: () async {
                            // print('emad');
                            // String text = 'حال شما چطور است';
                            // // حال شما چطور است?
                            // String? start = await detectlang(text: text);
                            // if (start != null) {
                            //   String? out =
                            //       await azureTranslation(text: text, start: start, end: 'en');
                            //   print('out $out');
                            // }

                            // print('detectlang ${await detectlang(text: 'سلام خوبی خانواده خوب هستن؟')}');
                            // context.read<ThemeState>().changeLang('en');
                            Go.push(context, Login());
                          },
                          child: Text(
                            AppLocalizations.of(context)!.login,
                            // 'Login',
                            style: TextStyle(fontSize: doubleWidth(5), color: mainBlue),
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
                              String out = "https://footballbuzz.co/terms-of-use-footballbuzz";
                              openUrl(out);
                              // openUrl('https://footballbuzz.co/terms-of-use-for-football-buzz/');
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
                          String out = "https://footballbuzz.co/privacy-policy";

                          openUrl(out);
                          // openUrl('https://footballbuzz.co/privacypolicy/');
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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
