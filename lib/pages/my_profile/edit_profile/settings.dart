import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shooting_app/classes/functions.dart';
import 'package:shooting_app/classes/dataTypes.dart';
import 'package:shooting_app/classes/states/main_state.dart';
import '../../../classes/services/authentication_service.dart';
import '../../../classes/services/my_service.dart';
import '../../../main.dart';
import '../../../ui_items/dialogs/privacy.dart';
import '../../../ui_items/dialogs/team.dart';
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
    if(state.personalInformation!=null)
      _2fa=state.personalInformation!.is2FA;
    else _2fa=false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Settings'.toUpperCase()),
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
                  color: Colors.white,
                ),
                padding: EdgeInsets.symmetric(horizontal: doubleWidth(2)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: doubleHeight(1)),
                    ListTile(
                      onTap: () {
                        if(state.personalInformation!=null)
                          Go.pushSlideAnim(context, ChangePassword());
                      },
                      title: Text(
                        'Update Password',
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
                        if(state.personalInformation!=null)
                          Go.pushSlideAnim(context, ChangeEmail(email: state.personalInformation!.email??'',));
                      },
                      title: Text(
                        'Change Email',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.black,
                        size: 20,
                      ),
                    ),
                    ListTile(
                      onTap: () async{
                        if(state.personalInformation!=null){
                          await Go.pushSlideAnim(context, ChangePhone(
                            number: state.personalInformation!.phoneNumber,
                          ));
                          state.getProfile();
                        }

                      },
                      title: Text(
                        'Change Phone',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.black,
                        size: 20,
                      ),
                    ),
                    // ListTile(
                    //   onTap: () {
                    //     setState(() {
                    //       check = !check;
                    //     });
                    //   },
                    //   title: Text(
                    //     'Lock Profile',
                    //     style: TextStyle(fontWeight: FontWeight.w600),
                    //   ),
                    //   trailing: SizedBox(
                    //     width: Checkbox.width,
                    //     height: Checkbox.width,
                    //     child: Transform.scale(
                    //       scale: 1.2,
                    //       child: AbsorbPointer(
                    //         absorbing: true,
                    //         child: Checkbox(
                    //           value: check,
                    //           onChanged: (e) {
                    //             setState(() {
                    //               check = e!;
                    //             });
                    //           },
                    //           activeColor: mainBlue,
                    //           shape: RoundedRectangleBorder(
                    //             borderRadius: BorderRadius.circular(3),
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    ListTile(
                      onTap: () async{
                        MyService service = getIt<MyService>();
                        bool back = await AuthenticationService.change2FA(service,is2FA: !_2fa);
                        if(back){
                          state.personalInformation!.is2FA=!_2fa;
                          setState(() {
                            _2fa = !_2fa;
                          });
                        }
                      },
                      title: Text(
                        'update 2FA',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      trailing: AbsorbPointer(
                        absorbing: true,
                        child: SizedBox(
                          width: doubleWidth(10),
                          child: Transform.scale(
                            scale: 0.7,
                            child: CupertinoSwitch(
                              onChanged: (e) async{
                                MyService service = getIt<MyService>();
                                bool back = await AuthenticationService.change2FA(service,is2FA: e);
                                if(back){
                                  setState(() {
                                    state.personalInformation!.is2FA=e;
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
              SizedBox(
                width: double.maxFinite,
                child: ElevatedButton(
                    style: ButtonStyle(
                        elevation: MaterialStateProperty.all(0),
                        backgroundColor: MaterialStateProperty.all(
                            mainBlue),
                        padding: MaterialStateProperty.all(EdgeInsets.symmetric(
                            vertical: doubleHeight(2.5),
                            horizontal: doubleWidth(4)))),
                    onPressed: () {
                      AuthenticationService.logOut(context);
                    },
                    child: SizedBox(
                      width: double.maxFinite,
                      child: Stack(
                        children: [
                          Icon(Icons.lock_open),
                          Align(
                              alignment: Alignment.center,
                              child: Text(
                                'Logout',
                                style: TextStyle(fontSize: 17),
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
                  SizedBox(width: doubleWidth(2)),
                  Text(
                    'and',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: black,
                      fontSize: doubleWidth(3),
                    ),
                  ),
                  SizedBox(width: doubleWidth(2)),
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
                  )
                ],
              ),
              sizeh(doubleHeight(4)),
            ],
          ),
        ),
      ),
    );
  }
}
