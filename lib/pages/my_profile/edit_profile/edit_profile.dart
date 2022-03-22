import 'package:flutter/material.dart';
import 'package:shooting_app/pages/chat/chat_list.dart';

import '../../../classes/functions.dart';
import '../../../dataTypes.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: EdgeInsets.only(top: doubleHeight(8)),
          child: SizedBox.expand(
            child: Material(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20), topLeft: Radius.circular(20)),
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: doubleWidth(4)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: doubleHeight(4)),
                    SizedBox(
                      width: double.maxFinite,
                      height: doubleHeight(6),
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: (){
                                Go.pop(context, null);
                              },
                              child: CircleAvatar(
                                radius: doubleHeight(3),
                                backgroundColor: Color.fromRGBO(109, 114, 120, 1),
                                child: Icon(Icons.close,color: Colors.white,),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Text('Edit profile',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold
                            ),)
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: doubleHeight(2)),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: greenCall,width: 2
                          ),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: CircleAvatar(
                          radius: doubleWidth(7),
                          backgroundImage: AssetImage('images/mohammad.jpg'),
                          child: CircleAvatar(
                            radius: doubleWidth(4.5),
                            backgroundColor: greenCall.withOpacity(0.4),
                            child: Icon(Icons.camera_alt,color: greenCall,
                            size: 20),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: doubleHeight(2)),
                    Container(
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(244, 244, 244, 1),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: doubleWidth(8),
                          // vertical: doubleHeight(1)
                      ),
                      child: TextFormField(
                        style: TextStyle(
                          color: grayCallDark
                        ),
                        initialValue: 'Mason Moreno',
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          prefixText: 'Name    ',
                            prefixStyle: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.black
                            ),
                            border: InputBorder.none),
                      ),
                    ),
                    SizedBox(height: doubleHeight(1)),
                    Container(
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(244, 244, 244, 1),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: doubleWidth(8),
                        // vertical: doubleHeight(1)
                      ),
                      child: TextFormField(
                        style: TextStyle(
                            color: grayCallDark
                        ),
                        initialValue: '@masonmoreno',
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            prefixText: 'Username    ',
                            prefixStyle: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.black
                            ),
                            border: InputBorder.none),
                      ),
                    ),
                    SizedBox(height: doubleHeight(1)),
                    Container(
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(244, 244, 244, 1),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: doubleWidth(8),
                        // vertical: doubleHeight(1)
                      ),
                      child: TextFormField(
                        style: TextStyle(
                            color: grayCallDark
                        ),
                        initialValue: 'Borussia Dortmund',
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            prefixText: 'Team    ',
                            prefixStyle: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.black
                            ),
                            border: InputBorder.none),
                      ),
                    ),
                    SizedBox(height: doubleHeight(2)),
                    SizedBox(
                        width: double.maxFinite,
                        child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(mainBlue),
                              padding: MaterialStateProperty.all(
                                  EdgeInsets.symmetric(
                                      vertical: doubleHeight(2.5)))),
                          child: Text(
                            'Save',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {},
                        )),
                    SizedBox(height: doubleHeight(4)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );

  }
}
