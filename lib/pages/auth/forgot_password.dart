import 'package:flutter/material.dart';

import '../../classes/functions.dart';
import '../../classes/dataTypes.dart';
import '../../classes/services/authentication_service.dart';
import '../../classes/services/my_service.dart';
import '../../main.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key,required this.username}) : super(key: key);
  final String username;
  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  late TextEditingController username;
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  @override
  initState(){
    super.initState();
    username=TextEditingController(text: widget.username);
  }

  String code='';
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
    return Container(
      decoration: decorImage(img: 'assets/images/stadium.jpg'),
      child: Scaffold(
        backgroundColor: trans,
          body: SizedBox.expand(
              child: Padding(
            padding: EdgeInsets.symmetric(horizontal: doubleWidth(4)),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
              ClipRRect(
                child: Container(
                  width: max,
                  height: doubleHeight(7),
                  color: Color.fromRGBO(216, 216, 216, 1),
                  child: Center(
                    child: TextField(
                      readOnly: true,
                      controller: username,
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
                          controller: password,
                          decoration: InputDecoration(
                              prefixText: '        ',
                              border: InputBorder.none,
                              hintText: 'New Password'),
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
                          controller: confirmPassword,
                          decoration: InputDecoration(
                              prefixText: '        ',
                              border: InputBorder.none,
                              hintText: 'Confirm New Password'),
                        ),
                      ),
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  sizeh(doubleHeight(2)),
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
                        color: Color.fromRGBO(216, 216, 216, 1),
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
              SizedBox(height: doubleHeight(4)),
              SizedBox(
                width: double.maxFinite,
                child: ElevatedButton(
                    style: ButtonStyle(
                        elevation: MaterialStateProperty.all(0),
                        backgroundColor: MaterialStateProperty.all(mainBlue),
                        padding: MaterialStateProperty.all(
                            EdgeInsets.symmetric(vertical: doubleHeight(2.5)))),
                    onPressed: () async{
                      if (code.length != 6) {
                        toast('please fill the field.');
                        return;
                      }else if(password.value.text.trim()==''){
                        toast('The password field is required.');
                        return;
                      }else if(confirmPassword.value.text.trim()==''){
                        toast('The confirmPassword field is required.');
                        return;
                      }else{
                        MyService service = getIt<MyService>();
                        bool back = await AuthenticationService.resetPassword(
                            service,widget.username, password.value.text.trim(),
                            confirmPassword.value.text.trim(), code.trim());
                        if(back){
                          Go.pop(context);
                        }
                      }
                    },
                    child: Text('Update')),
              )
            ]),
          )),
          appBar: AppBar(elevation: 0, title: Text('Update Password'.toUpperCase()))),
    );
  }
}
