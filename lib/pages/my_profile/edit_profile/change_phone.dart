import 'package:flutter/material.dart';
import 'package:shooting_app/classes/dataTypes.dart';
import 'package:shooting_app/classes/services/authentication_service.dart';
import 'package:shooting_app/classes/services/my_service.dart';
import '../../../main.dart';
import 'verify_phone.dart';

import '../../../classes/functions.dart';

class ChangePhone extends StatefulWidget {
  final String? number;

  const ChangePhone({Key? key,this.number}) : super(key: key);
  @override
  State<ChangePhone> createState() => _ChangePhoneState();
}

class _ChangePhoneState extends State<ChangePhone> {
  TextEditingController pref = TextEditingController();
  String prefStr = '';
  TextEditingController number = TextEditingController();
  String numberStr = '';
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0, title: Text('Change Phone')),
      backgroundColor: Color.fromRGBO(247, 247, 247, 1),
      body: SizedBox.expand(
          child: Padding(
        padding: EdgeInsets.symmetric(horizontal: doubleWidth(6)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(height: doubleHeight(6)),
          Text(
            widget.number!=null?'Your current phone number is:':'',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: doubleHeight(2)),
          Builder(
            builder: (context) {
              if(widget.number!=null){
                String pre=widget.number!.substring(0,widget.number!.length-10);
                String post=widget.number!.substring(widget.number!.length-10,widget.number!.length);
                return Text(
                  '$pre *** *** *${post.substring(post.length-3,post.length)}',
                  style: TextStyle(color: grayCallDark),
                );
              }else{
                return Text('');
              }
            }
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
                padding: EdgeInsets.symmetric(horizontal: doubleWidth(2)),
                child: TextField(
                  controller: pref,
                  onChanged: (e) {
                    if (e.length > 4) {
                      pref.text = prefStr;
                    } else {
                      setState(() {
                        prefStr = e;
                      });
                    }
                  },
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                      hintStyle: TextStyle(color: grayCallDark),
                      hintText: '234',
                      prefixText: '+',
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
                  padding: EdgeInsets.symmetric(horizontal: doubleWidth(4)),
                  child: TextFormField(

                    controller: number,
                    onChanged: (e) {
                      if (e.length > 11) {
                        number.text = numberStr;
                      } else {
                        setState(() {
                          numberStr = e;
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
                        EdgeInsets.symmetric(vertical: doubleHeight(2.5)))),
                onPressed: () async{
                  // print(pref.value.text+number.value.text.trim());
                  if(pref.value.text.trim() !='' && number.value.text.trim()!=''){
                    MyService service = getIt<MyService>();
                    bool back = await AuthenticationService.changePhone(service);
                    if(back){
                      Go.replaceSlideAnim(context,
                          VerifyPhone(number: '+'+pref.value.text.trim()+number.value.text.trim(),));
                    }
                  } else
                    toast('please fill the field.');
                },
                child: Text('Continue')),
          )
        ]),
      )),
    );
  }
}
