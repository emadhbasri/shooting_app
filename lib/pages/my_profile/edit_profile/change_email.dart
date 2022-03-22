import 'package:flutter/material.dart';
import 'package:shooting_app/dataTypes.dart';
import 'change_email_done.dart';

import '../../../classes/functions.dart';

class ChangeEmail extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          title: Text('Change Email')),
      backgroundColor: Color.fromRGBO(247, 247, 247, 1),
      body: SizedBox.expand(
          child: Padding(
        padding: EdgeInsets.symmetric(horizontal: doubleWidth(4)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(height: doubleHeight(6)),
          Text(
            'Your current email is:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: doubleHeight(2)),
          Text(
            'example@abc.com',
            style: TextStyle(color: grayCall),
          ),
          SizedBox(height: doubleHeight(8)),
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
                  hintStyle: TextStyle(color: Color.fromRGBO(214, 216, 217, 1)),
                  hintText: 'Enter new email',
                  border: InputBorder.none),
            ),
          ),
          SizedBox(height: doubleHeight(8)),
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
                  Go.replaceSlideAnim(context, ChangeEmailDone());
                },
                child: Text('Verify')),
          )
        ]),
      )),
    );
  }
}
