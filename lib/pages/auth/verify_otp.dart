import 'package:flutter/material.dart';
import 'package:shooting_app/classes/services/user_service.dart';
import 'package:shooting_app/pages/auth/team.dart';

import '../../../classes/functions.dart';
import '../../../classes/dataTypes.dart';
import '../../../classes/services/authentication_service.dart';
import '../../../classes/services/my_service.dart';
import '../../../main.dart';
import '../../ui_items/my_toast.dart';
import '../AppPage.dart';

class VerifyOtp extends StatefulWidget {
  const VerifyOtp(
      {Key? key,
      required this.isRegister,
      required this.username,
      required this.password})
      : super(key: key);
  final String username;
  final String password;
  final bool isRegister;
  @override
  State<VerifyOtp> createState() => _VerifyOtpState();
}

class _VerifyOtpState extends State<VerifyOtp> {
  bool loading=true;


  GlobalKey<MyToastState> key = GlobalKey<MyToastState>();

  String code = '';
  List<FocusNode?> _listFocusNodes = [
    FocusNode(),
    null,
    FocusNode(),
    null,
    FocusNode(),
    null,
    FocusNode(),
    null,
    FocusNode(),
    null,
    FocusNode()
  ];
  List<String?> _listStrings = [
    '',
    null,
    '',
    null,
    '',
    null,
    '',
    null,
    '',
    null,
    ''
  ];
  List<TextEditingController?> _listControllers = [
    TextEditingController(),
    null,
    TextEditingController(),
    null,
    TextEditingController(),
    null,
    TextEditingController(),
    null,
    TextEditingController(),
    null,
    TextEditingController()
  ];
  String? email;
  @override
  void initState() {
    super.initState();
    getData();
  }
  getData()async{
    email = await UsersService.getEmailByUserName(getIt<MyService>(),
     username: widget.username);
     setState(() {
       loading=false;
     });
  }

  Widget build(BuildContext context) {
    return MyToast(
      key: key,
      child: Scaffold(
        appBar: AppBar(elevation: 0, title: Text(AppLocalizations.of(context)!.email_verification)),
        body: loading?circle():

        SizedBox.expand(
            child: Padding(
          padding: EdgeInsets.symmetric(horizontal: doubleWidth(4)),
          child: Column(children: [
            SizedBox(height: doubleHeight(8)),
            SizedBox(
              width: doubleWidth(40),
              child: Image.asset('assets/images/email.png'),
            ),

            Text(
                AppLocalizations.of(context)!.enter_the_6,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: doubleWidth(3.5),
                    fontWeight: FontWeight.bold,
                    color: myGray2)),
            SizedBox(height: doubleHeight(1)),
            Text(
                email??AppLocalizations.of(context)!.your_email,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: doubleWidth(3.5),
                    fontWeight: FontWeight.bold,
                    color: black)),
            SizedBox(height: doubleHeight(4)),
            Container(
              decoration: BoxDecoration(
                color: Colors.greenAccent.withOpacity(.25),
                // border: Border.all(width: 1,color: Provider.of<ThemeState>(context,listen: false).isDarkMode?Colors.white:Colors.black),
                borderRadius: BorderRadius.circular(5),
              ),
              padding: EdgeInsets.symmetric(
                  horizontal: doubleWidth(5), vertical: doubleHeight(1.5)),
              child: Text(AppLocalizations.of(context)!.check_your_spam,
                  // 'Please check your spam message if you can\'t see your OTP in your inbox',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold, color: green)),
            ),

            // Text(
            //   'Enter code to verify',
            //   style: TextStyle(color: grayCall),
            // ),
            SizedBox(height: doubleHeight(6)),
            SizedBox(
              child: Row(
                  children: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10].map((int index) {
                if (index % 2 == 1)
                  return SizedBox(width: doubleWidth(4));
                else
                  return Expanded(
                      child: Container(
                    // elevation: 0,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.symmetric(vertical: doubleHeight(1)),
                    child: TextField(
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                            fontSize: 14.0),
                        controller: _listControllers[index],
                        onTap: () {
                          _listControllers[index]!.clear();
                        },
                        onChanged: (e) async {
                          // setState(() {
                          //   isError=false;
                          // });

                          if (index == 10) {
                            if (e.length == 1) {
                              FocusScope.of(context).requestFocus(FocusNode());
                              _listStrings[index] = e;
                            } else {
                              FocusScope.of(context).requestFocus(FocusNode());
                              _listControllers[index]?.clear();
                              _listFocusNodes[index]?.requestFocus();
                            }
                          } else {
                            if (e.length == 1) {
                              _listFocusNodes[index + 2]?.requestFocus();
                              _listStrings[index] = e;
                            } else {
                              _listFocusNodes[index + 2]?.requestFocus();
                              _listControllers[index]?.clear();
                              _listFocusNodes[index]?.requestFocus();
                            }
                          }

                          code = '';
                          for (int j = 0; j < _listControllers.length; j++) {
                            if (_listControllers[j] != null) {
                              code += _listControllers[j]!.value.text;
                            }
                          }
                        },
                        focusNode: _listFocusNodes[index],
                        keyboardType: TextInputType.phone,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(border: InputBorder.none)
                        // enabledBorder: OutlineInputBorder(
                        // borderSide:
                        // BorderSide(color: isError?colorErrorLight:colorGray2),
                        // borderRadius: BorderRadius.circular(8)),
                        // border: OutlineInputBorder(
                        //     borderRadius: BorderRadius.circular(8))),
                        ),
                  ));
              }).toList()),
            ),
            SizedBox(height: doubleHeight(2)),
            SizedBox(
              width: double.maxFinite,
              child: ElevatedButton(
                  style: ButtonStyle(
                      // elevation: MaterialStateProperty.all(0),

                      backgroundColor: MaterialStateProperty.all(mainBlue),
                      padding: MaterialStateProperty.all(
                          EdgeInsets.symmetric(vertical: doubleHeight(2.5)))),
                  onPressed: () async {
                    if (code.length != 6) {
                      myToast(key, AppLocalizations.of(context)!.please_fill_the_field);
                      return;
                    } else {
                      MyService service = getIt<MyService>();
                      bool back = await AuthenticationService.validateOtp(
                          service, key,
                          user: widget.username,
                          password: widget.password,
                          oTP: code);
                      if (back) {
                        bool bbo = await service.getToken();
                        if (bbo) {
                          if (widget.isRegister == false) {
                            Go.pushAndRemoveSlideAnim(
                                context, AppPageBuilder());
                          } else {
                            Go.pushSlideAnim(context, Team());
                          }
                        }
                      }
                    }
                  },
                  child: Text(AppLocalizations.of(context)!.verify)),
            )
          ]),
        )),
      ),
    );
  }
}
