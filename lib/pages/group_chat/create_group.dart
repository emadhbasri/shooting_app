import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shooting_app/classes/functions.dart';
import 'package:shooting_app/classes/models.dart';
import 'package:shooting_app/classes/services/chat_service.dart';
import 'package:shooting_app/classes/services/my_service.dart';
import 'package:shooting_app/main.dart';
import 'package:shooting_app/ui_items/dialogs/choose_media_dialog.dart';
import '../../classes/models.dart';
import '../../classes/dataTypes.dart';
import '../../classes/states/main_state.dart';
import '../home/search_user.dart';
import '../shoot/search_user_mention.dart';

class CreateGroup extends StatefulWidget {
  final bool isEdit;
  final DataChatRoom? group;
  const CreateGroup({Key? key,this.isEdit=false,this.group}) : super(key: key);
  @override
  _CreateGroupState createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  MyService service = getIt<MyService>();
  TextEditingController textEditingController=TextEditingController();
  List<DataPersonalInformation> users = [];
  bool loading=false;
  String? image;
  @override
  void initState() {
    super.initState();
    if(widget.isEdit){
      textEditingController=TextEditingController(text: widget.group!.name);
      image=widget.group!.roomPhoto;
      users.addAll(widget.group!.personalInformations.map((e) => e!));
    }
  }
  XFile? file;
  @override
  Widget build(BuildContext context) {
    ImageProvider? out;

    if(file != null){
      out=FileImage(File(file!.path));
    }else if(image!=null){
      out= networkImage(image!);
    }
    print('out $out');
    return Scaffold(
      backgroundColor: white,
        appBar: AppBar(
          title: Text(
              '${widget.isEdit?'Edit':'Create'} Group'.toUpperCase()),
        ),
        floatingActionButton: widget.isEdit?null:FloatingActionButton(
          heroTag: 'Find User',
          onPressed: () async {
            DataPersonalInformation? user =
                await Go.pushSlideAnim(context, SearchUserMention());
            if (user != null) {
              bool found = false;
              for (int j = 0; j < users.length; j++) {
                if (user.userName == users[j].userName) {
                  found = true;
                  break;
                }
              }
              if (!found) {
                setState(() {
                  users.add(user);
                });
              }
            }
          },
          child: Icon(Icons.group_add),
        ),
        body: Column(
          children: [
            SizedBox(height: doubleHeight(2)),
            Container(
              color: Colors.white,
              width: double.maxFinite,
              child: Row(
                children: [
                  SizedBox(width: doubleWidth(2)),

                  GestureDetector(
                    onTap: ()async{
                      file = await showDialog(context: context, builder: (context)=>
                      ChooseMediaDialog(video: false,));
                      setState(() {});
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: greenCall, width: 2),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: CircleAvatar(
                        radius: doubleWidth(7),
                        backgroundImage:out,
                        child: file == null && image==null ?CircleAvatar(
                          radius: doubleWidth(4.5),
                          backgroundColor: greenCall.withOpacity(0.4),
                          child: Icon(Icons.camera_alt,
                              color: greenCall, size: 20),
                        ):const SizedBox(),
                      ),
                    ),
                  ),
                  SizedBox(width: doubleWidth(2)),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(244, 244, 244, 1),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: doubleWidth(8),
                          vertical: doubleHeight(0.5)),
                      child: TextField(
                        controller: textEditingController,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                            hintStyle: TextStyle(
                                color: Color.fromRGBO(214, 216, 217, 1)),
                            hintText: 'Write The Group Name...',
                            border: InputBorder.none),
                      ),
                    ),
                  ),

                  SizedBox(width: doubleWidth(2)),
                  GestureDetector(
                    onTap: () async{
                      setState(() {
                        loading=true;
                      });

                      if(widget.isEdit){
                        DataChatRoom? backEdit = await
                        ChatService.editRoom(service,
                            chatRoomId: widget.group!.id,
                            name: textEditingController.value.text,
                            image:file
                        );
                        if(backEdit!=null){
                          setState(() {
                            loading=false;
                          });
                          Go.pop(context,backEdit);

                        }
                      }else{
                        String? backCreate = await
                        ChatService.createGroupChat(service,
                            name: textEditingController.value.text,
                            image:file
                        );
                        if(backCreate!=null){
                          for(int j=0;j<users.length;j++){
                            if(users[j].userName!=getIt<MainState>().userName){
                              await ChatService.joinGroupChat(service, chatRoomId: backCreate, userId: users[j].id);
                            }
                          }
                          // setState(() {
                          //   loading=false;
                          // });
                          Go.pop(context,true);
                        }else{
                          setState(() {
                            loading=false;
                          });
                        }
                      }

                    },
                    child: Container(
                      padding: EdgeInsets.all(doubleWidth(4)),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: greenCall,
                      ),
                      child: loading?simpleCircle(
                        size: 24
                      ):
                      Icon(Icons.arrow_forward_ios),
                    ),
                  ),
                  SizedBox(width: doubleWidth(2)),
                ],
              ),
            ),
            if(widget.isEdit==false)
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.symmetric(
                    horizontal: doubleWidth(5), vertical: doubleHeight(2)),
                itemCount: users.length,
                separatorBuilder: (_, __) => SizedBox(height: doubleHeight(1)),
                itemBuilder: (_, index) => UserItem(
                  key: UniqueKey(),
                  user: users[index],
                  hasFollowBtn: false,
                ),
              ),
            ),
          ],
        ));
  }
}
