import 'package:flutter/material.dart';
import 'package:shooting_app/dataTypes.dart';
import 'change_email_done.dart';
import 'verify_phone.dart';

import '../../../classes/functions.dart';

class ChangePhone extends StatefulWidget {
  @override
  State<ChangePhone> createState() => _ChangePhoneState();
}

class _ChangePhoneState extends State<ChangePhone> {
  TextEditingController pref=TextEditingController();
  String prefStr='';
  TextEditingController number=TextEditingController();
  String numberStr='';
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          title: Text('Change Phone')),
      backgroundColor: Color.fromRGBO(247, 247, 247, 1),
      body: SizedBox.expand(
          child: Padding(
        padding: EdgeInsets.symmetric(horizontal: doubleWidth(6)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(height: doubleHeight(6)),
          Text(
            'Your current phone number is:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: doubleHeight(2)),
          Text(
            '+234 *** *** *844',
            style: TextStyle(color: grayCallDark),
          ),
          SizedBox(height: doubleHeight(8)),
          Row(
            children: [
              Container(
                width: doubleWidth(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                ),
                padding: EdgeInsets.symmetric(
                    horizontal: doubleWidth(2)),
                child: TextField(
                  controller: pref,
                  onChanged: (e){
                    if(e.length>4){
                      pref.text=prefStr;
                    }else{
                      setState(() {
                        prefStr=e;
                      });
                    }
                  },
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                      hintStyle: TextStyle(color: grayCallDark),
                      hintText: '+234',
                      border: InputBorder.none),
                ),
              ),
              SizedBox(width: doubleWidth(4)),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  padding: EdgeInsets.symmetric(
                      horizontal: doubleWidth(4)),
                  child: TextField(
                    controller: number,
                    onChanged: (e){
                      if(e.length>11){
                        number.text=numberStr;
                      }else{
                        setState(() {
                          numberStr=e;
                        });
                      }
                    },
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                        hintStyle: TextStyle(color: grayCallDark),
                        hintText: '**** *** ****',
                        border: InputBorder.none),
                  ),
                ),
              ),
            ],
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
                  Go.replaceSlideAnim(context, VerifyPhone());
                },
                child: Text('Continue')),
          )
        ]),
      )),
    );
  }
}
