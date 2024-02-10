import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shooting_app/classes/functions.dart';
import 'package:shooting_app/classes/dataTypes.dart';
import 'package:shooting_app/classes/states/main_state.dart';
import 'package:shooting_app/classes/states/theme_state.dart';
import 'package:shooting_app/ui_items/theme_switcher.dart';
import '../../../classes/services/authentication_service.dart';
import '../../../classes/services/my_service.dart';
import '../../../main.dart';
import '../../../ui_items/dialogs/dialog1.dart';
import 'change_phone.dart';

import 'change_email.dart';
import 'change_password.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  MyService service = getIt<MyService>();
  MainState state = getIt<MainState>();
  late bool _2fa;

  @override
  void initState() {
    super.initState();
    if (state.personalInformation != null)
      _2fa = state.personalInformation!.is2FA;
    else
      _2fa = false;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeState>(
      builder: (context, theme, child) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            title: Text(AppLocalizations.of(context)!.settings.toUpperCase()),
            actions: [ThemeSwitcher()],
          ),
          body: SizedBox.expand(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: doubleWidth(4)),
              child: Column(
                children: [
                  SizedBox(height: doubleHeight(4)),
                  Container(
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: theme.isDarkMode ? Colors.grey : Colors.white,
                    ),
                    padding: EdgeInsets.symmetric(horizontal: doubleWidth(2)),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: doubleHeight(1)),
                        ListTile(
                          onTap: () {
                            if (state.personalInformation != null)
                              Go.pushSlideAnim(context, ChangePassword());
                          },
                          title: Text(
                            AppLocalizations.of(context)!.update_password,
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.black,
                            size: 20,
                          ),
                        ),
                        ListTile(
                          onTap: () {
                            if (state.personalInformation != null)
                              Go.pushSlideAnim(
                                  context,
                                  ChangeEmail(
                                    email: state.personalInformation!.email ?? '',
                                  ));
                          },
                          title: Text(
                            AppLocalizations.of(context)!.change_email,
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.black,
                            size: 20,
                          ),
                        ),
                        ListTile(
                          onTap: () async {
                            if (state.personalInformation != null) {
                              await Go.pushSlideAnim(
                                  context,
                                  ChangePhone(
                                    number: state.personalInformation!.phoneNumber,
                                  ));
                              state.getProfile();
                            }
                          },
                          title: Text(
                            AppLocalizations.of(context)!.change_phone,
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.black,
                            size: 20,
                          ),
                        ),
                        ListTile(
                          onTap: () async {
                            MyService service = getIt<MyService>();
                            bool back =
                                await AuthenticationService.change2FA(service, is2FA: !_2fa);
                            if (back) {
                              state.personalInformation!.is2FA = !_2fa;
                              setState(() {
                                _2fa = !_2fa;
                              });
                            }
                          },
                          title: Text(
                            AppLocalizations.of(context)!.update_2,
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          trailing: AbsorbPointer(
                            absorbing: true,
                            child: SizedBox(
                              width: doubleWidth(10),
                              child: Transform.scale(
                                scale: 0.7,
                                child: CupertinoSwitch(
                                  onChanged: (e) async {
                                    MyService service = getIt<MyService>();
                                    bool back =
                                        await AuthenticationService.change2FA(service, is2FA: e);
                                    if (back) {
                                      setState(() {
                                        state.personalInformation!.is2FA = e;
                                        _2fa = e;
                                      });
                                    }
                                  },
                                  value: _2fa,
                                  activeColor: mainBlue,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: doubleHeight(1)),
                      ],
                    ),
                  ),
                  SizedBox(height: doubleHeight(3)),
                  ChangeLang(),
                  SizedBox(height: doubleHeight(3)),
                  SizedBox(
                    width: double.maxFinite,
                    child: ElevatedButton(
                        style: ButtonStyle(
                            elevation: MaterialStateProperty.all(0),
                            backgroundColor: MaterialStateProperty.all(
                                theme.isDarkMode ? mainColorDark : mainBlue),
                            padding: MaterialStateProperty.all(EdgeInsets.symmetric(
                                vertical: doubleHeight(2.5), horizontal: doubleWidth(4)))),
                        onPressed: () async {
                          bool? alert = await MyAlertDialog(
                            context,
                            content: AppLocalizations.of(context)!.do_logout,
                          );
                          if (alert == true) {
                            AuthenticationService.logOut(context);
                          }
                        },
                        child: SizedBox(
                          width: double.maxFinite,
                          child: Stack(
                            children: [
                              Icon(Icons.lock_open,color: white,),
                              Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    AppLocalizations.of(context)!.logout,
                                    style: TextStyle(fontSize: 17,color: white),
                                  )),
                            ],
                          ),
                        )),
                  ),
                  SizedBox(height: doubleHeight(2)),
                  SizedBox(
                    width: double.maxFinite,
                    child: ElevatedButton(
                        style: ButtonStyle(
                            elevation: MaterialStateProperty.all(0),
                            backgroundColor: MaterialStateProperty.all(
                                theme.isDarkMode ? Colors.pink.shade800 : pink),
                            padding: MaterialStateProperty.all(EdgeInsets.symmetric(
                                vertical: doubleHeight(2.5), horizontal: doubleWidth(4)))),
                        onPressed: () async {
                          bool? alert = await MyAlertDialog(
                            context,
                            content: AppLocalizations.of(context)!.do_you_want_delete,
                          );
                          if (alert == true) {
                            AuthenticationService.deleteAccount(context);
                          }
                        },
                        child: SizedBox(
                          width: double.maxFinite,
                          child: Stack(
                            children: [
                              Icon(Icons.delete_forever,color: white),
                              Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    AppLocalizations.of(context)!.delete_account,
                                    style: TextStyle(fontSize: 17,color: white),
                                  )),
                            ],
                          ),
                        )),
                  ),
                  Spacer(),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () {
                          String out = "https://footballbuzz.co/terms-of-use-footballbuzz";
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
                      SizedBox(width: doubleWidth(2)),
                      Text(
                        AppLocalizations.of(context)!.and,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          // color: black,
                          fontSize: doubleWidth(3),
                        ),
                      ),
                      SizedBox(width: doubleWidth(2)),
                      GestureDetector(
                        onTap: () {
                          String out = "https://footballbuzz.co/privacy-policy";

                          openUrl(out);
                          // openUrl('https://footballbuzz.co/privacypolicy/');
                          // showDialog(context: context, builder: (_)=>Privacy());
                        },
                        child: Text(AppLocalizations.of(context)!.privacy_policy,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: mainGreen1,
                                fontWeight: FontWeight.bold,
                                fontSize: doubleWidth(3),
                                fontStyle: FontStyle.italic)),
                      )
                    ],
                  ),
                  sizeh(doubleHeight(4)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
