import 'package:flutter/material.dart';
import 'package:shooting_app/classes/dataTypes.dart';

import '../../../classes/functions.dart';
import '../../../classes/services/authentication_service.dart';
import '../../../classes/services/my_service.dart';
import '../../../main.dart';

class ChangePassword extends StatefulWidget {
  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  TextEditingController lastPassword = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0, title: Text('Change Password')),
      // backgroundColor: Color.fromRGBO(247, 247, 247, 1),
      body: SizedBox.expand(
          child: Padding(
        padding: EdgeInsets.symmetric(horizontal: doubleWidth(6)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(height: doubleHeight(6)),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
            padding: EdgeInsets.symmetric(horizontal: doubleWidth(8)),
            child: TextField(
              style: TextStyle(
                  color: Colors.black
              ),
              controller: lastPassword,
              keyboardType: TextInputType.visiblePassword,
              decoration: InputDecoration(
                  hintStyle: TextStyle(color: grayCall),
                  hintText: 'Current Password',
                  border: InputBorder.none),
            ),
          ),
          SizedBox(height: doubleHeight(2)),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
            padding: EdgeInsets.symmetric(horizontal: doubleWidth(8)),
            child: TextField(
              style: TextStyle(
                  color: Colors.black
              ),
              controller: password,
              keyboardType: TextInputType.visiblePassword,
              decoration: InputDecoration(
                  hintStyle: TextStyle(color: grayCall),
                  hintText: 'new Password',
                  border: InputBorder.none),
            ),
          ),
          SizedBox(height: doubleHeight(2)),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
            padding: EdgeInsets.symmetric(horizontal: doubleWidth(8)),
            child: TextField(
              style: TextStyle(
                  color: Colors.black
              ),
              controller: confirmPassword,
              keyboardType: TextInputType.visiblePassword,
              decoration: InputDecoration(
                  hintStyle: TextStyle(color: grayCall),
                  hintText: 'Confirm new Password',
                  border: InputBorder.none),
            ),
          ),
          SizedBox(height: doubleHeight(4)),
          SizedBox(
            width: double.maxFinite,
            child: ElevatedButton(
                style: ButtonStyle(
                    elevation: MaterialStateProperty.all(0),
                    // backgroundColor: MaterialStateProperty.all(mainBlue),
                    padding: MaterialStateProperty.all(
                        EdgeInsets.symmetric(vertical: doubleHeight(2.5)))),
                onPressed: () async{
                  if(lastPassword.value.text.trim()!='' && password.value.text.trim()!='' && confirmPassword.value.text.trim()!=''){
                    MyService service = getIt<MyService>();
                    bool back = await AuthenticationService.changePassword(service,
                      password:lastPassword.value.text.trim(),
                      newPassword: password.value.text.trim(),
                      newPasswordConfirm: confirmPassword.value.text.trim()
                       );
                    if(back){
                      toast('password changed successfully.');
                      Go.pop(context);
                    }
                  } else
                    toast('please fill the fields.');
                },
                child: Text('Save')),
          )
        ]),
      )),
    );
  }
}
