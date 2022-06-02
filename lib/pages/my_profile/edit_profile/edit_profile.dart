import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shooting_app/classes/live_match_model.dart';
import 'package:shooting_app/classes/services/my_service.dart';
import 'package:shooting_app/classes/services/user_service.dart';
import 'package:shooting_app/classes/states/main_state.dart';
import 'package:shooting_app/main1.dart';
import 'package:shooting_app/pages/team_search.dart';

import '../../../classes/functions.dart';
import '../../../classes/models.dart';
import '../../../classes/dataTypes.dart';

class EditProfile extends StatefulWidget {
  const EditProfile(this.person, {Key? key}) : super(key: key);
  final DataPersonalInformation person;
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  late TextEditingController nameController;
  @override
  void initState() {
    super.initState();
    if(widget.person.team!=null){
      teamName= widget.person.team!.team_name??'';
    }
    nameController = TextEditingController(text: widget.person.fullName);
  }
  String teamName='';
  MyService service = getIt<MyService>();
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
                              onTap: () {
                                Go.pop(context, null);
                              },
                              child: CircleAvatar(
                                radius: doubleHeight(3),
                                backgroundColor:
                                    Color.fromRGBO(109, 114, 120, 1),
                                child: Icon(
                                  Icons.close,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          Align(
                              alignment: Alignment.center,
                              child: Text(
                                'Edit profile',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              )),
                        ],
                      ),
                    ),
                    SizedBox(height: doubleHeight(2)),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                        onTap: ()async{
                          XFile? file = await ImagePicker()
                              .pickImage(source: ImageSource.gallery);
                          if (file != null) {
                            bool back = await UsersService.changePhoto(service, file);
                            if(back){
                              getIt<MainState>().getProfile(force: true);
                              Go.pop(context);
                            }
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: greenCall, width: 2),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: CircleAvatar(
                            radius: doubleWidth(7),
                            backgroundImage: widget.person.profilePhoto != null
                                ? networkImage(widget.person.profilePhoto!)
                                : null,
                            child: CircleAvatar(
                              radius: doubleWidth(4.5),
                              backgroundColor: greenCall.withOpacity(0.4),
                              child: Icon(Icons.camera_alt,
                                  color: greenCall, size: 20),
                            ),
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
                      child: TextField(
                        controller: nameController,
                        style: TextStyle(color: grayCallDark),
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            prefixText: 'Name    ',
                            prefixStyle: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.black),
                            border: InputBorder.none),
                      ),
                    ),
                    SizedBox(height: doubleHeight(1)),
                    // Container(
                    //   decoration: BoxDecoration(
                    //     color: Color.fromRGBO(244, 244, 244, 1),
                    //     borderRadius: BorderRadius.circular(5),
                    //   ),
                    //   padding: EdgeInsets.symmetric(
                    //     horizontal: doubleWidth(8),
                    //     // vertical: doubleHeight(1)
                    //   ),
                    //   child: TextFormField(
                    //     style: TextStyle(
                    //         color: grayCallDark
                    //     ),
                    //     initialValue: widget.person.userName,
                    //     keyboardType: TextInputType.emailAddress,
                    //     decoration: InputDecoration(
                    //         prefixText: 'Username    ',
                    //         prefixStyle: TextStyle(
                    //             fontWeight: FontWeight.w600,
                    //             color: Colors.black
                    //         ),
                    //         border: InputBorder.none),
                    //   ),
                    // ),
                    // SizedBox(height: doubleHeight(1)),

                    GestureDetector(
                      onTap: () async {
                        DataMatchTeam? backTeam =
                            await Go.pushSlideAnim(context, TeamSearch());
                        print('backTeam $backTeam');
                        if (backTeam != null) {
                          bool backUser = await UsersService.changeTeam(
                              service, backTeam);
                          if(backUser) {
                            getIt<MainState>().getProfile();
                            widget.person.team!.team_name=backTeam.name;
                            setState(() {
                              teamName=backTeam.name;
                            });
                            toast('Team Changed Successfully');
                          }
                          print('backUser $backUser');
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(244, 244, 244, 1),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: doubleWidth(8),
                            vertical: doubleHeight(2)),
                        child: Row(
                          children: [
                            Text(
                              'Team    ',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black),
                            ),
                            Text(teamName == ''
                                ? 'no team selected'
                                : teamName),
                            // TextFormField(
                            //   style: TextStyle(
                            //       color: grayCallDark
                            //   ),
                            //   initialValue:
                            //   widget.person.team==null?'no team selected':
                            //   widget.person.team!.team_name,
                            //   keyboardType: TextInputType.text,
                            //   onFieldSubmitted: (e){
                            //     print('submit $e');
                            //   },
                            //   decoration: InputDecoration(
                            //       prefixText: 'Team    ',
                            //       prefixStyle: TextStyle(
                            //           fontWeight: FontWeight.w600,
                            //           color: Colors.black
                            //       ),
                            //       suffixIcon: GestureDetector(
                            //           onTap: (){
                            //             print('search');
                            //           },
                            //           child: Icon(Icons.search)),
                            //       border: InputBorder.none),
                            // ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: doubleHeight(2)),
                    SizedBox(
                        width: double.maxFinite,
                        child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(mainBlue),
                              padding: MaterialStateProperty.all(
                                  EdgeInsets.symmetric(
                                      vertical: doubleHeight(2.5)))),
                          child: Text(
                            'Save',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () async {
                            bool back = await UsersService.changeName(
                                service, nameController.value.text);
                            if(back)
                              getIt<MainState>().getProfile(force: true);
                            Go.pop(context);
                          },
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
