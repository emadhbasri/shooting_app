import 'package:flutter/material.dart';
import 'package:shooting_app/dataTypes.dart';
import 'change_email_done.dart';

import '../../../classes/functions.dart';

class ChangePassword extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          title: Text('Change Password')),
      backgroundColor: Color.fromRGBO(247, 247, 247, 1),
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
            padding: EdgeInsets.symmetric(
                horizontal: doubleWidth(8)),
            child: TextField(
              keyboardType: TextInputType.emailAddress,
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
            padding: EdgeInsets.symmetric(
                horizontal: doubleWidth(8)),
            child: TextField(
              keyboardType: TextInputType.emailAddress,
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
            padding: EdgeInsets.symmetric(
                horizontal: doubleWidth(8)),
            child: TextField(
              keyboardType: TextInputType.emailAddress,
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
                    backgroundColor: MaterialStateProperty.all(mainBlue),
                    padding: MaterialStateProperty.all(
                        EdgeInsets.symmetric(vertical: doubleHeight(2.5)))
                ),
                onPressed: () {
                  Go.pop(context);
                },
                child: Text('Save')),
          )
        ]),
      )),
    );
  }
}
