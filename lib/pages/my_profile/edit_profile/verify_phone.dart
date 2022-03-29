import 'package:flutter/material.dart';
import 'package:shooting_app/classes/states/main_state.dart';

import '../../../classes/functions.dart';
import '../../../classes/dataTypes.dart';
import '../../../classes/services/authentication_service.dart';
import '../../../classes/services/my_service.dart';
import '../../../main.dart';

class VerifyPhone extends StatefulWidget {
  const VerifyPhone({Key? key,required this.number}) : super(key: key);
  final String number;
  @override
  State<VerifyPhone> createState() => _VerifyPhoneState();
}

class _VerifyPhoneState extends State<VerifyPhone> {
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
  Widget build(BuildContext context) {
    return Scaffold(
        body: SizedBox.expand(
            child: Padding(
          padding: EdgeInsets.symmetric(horizontal: doubleWidth(4)),
          child: Column(children: [
            SizedBox(height: doubleHeight(8)),
            Text('A 6 digit code has been sent to your\nnumber',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold)),
            SizedBox(height: doubleHeight(2)),
            Text(
              'Enter code to verify phone',
              style: TextStyle(color: grayCall),
            ),
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
                            fontWeight: FontWeight.w400,
                            fontFamily: "Peyda",
                            fontStyle: FontStyle.normal,
                            fontSize: 14.0),
                        controller: _listControllers[index],
                        onTap: () {
                          _listControllers[index]!.clear();
                        },
                        onChanged: (e) async{
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

                          String code = '';
                          for (int j = 0; j < _listControllers.length; j++) {
                            if (_listControllers[j] != null) {
                              code += _listControllers[j]!.value.text;
                            }
                          }
                          if (code.length != 6) {
                            toast('please fill the field.');
                            return;
                          }else{
                              MyService service = getIt<MyService>();
                              bool back = await AuthenticationService.phoneVerify(
                                  service,
                              phoneNumber: widget.number,
                                otp: code
                              );
                              if(back){
                                getIt<MainState>().getProfile(noNotify: false);
                                Go.pop(context);
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
            SizedBox(height: doubleHeight(4)),
            SizedBox(
              width: double.maxFinite,
              child: ElevatedButton(
                  style: ButtonStyle(
                      elevation: MaterialStateProperty.all(0),
                      backgroundColor: MaterialStateProperty.all(mainBlue),
                      padding: MaterialStateProperty.all(
                          EdgeInsets.symmetric(vertical: doubleHeight(2.5)))),
                  onPressed: () {
                    Go.pop(context);
                  },
                  child: Text('Verify')),
            )
          ]),
        )),
        appBar: AppBar(elevation: 0, title: Text('Verify Phone')));
  }
}
