export 'reply_from_shot.dart';

export '../bottom_sheet.dart';
export '../dialogs/share_dialog.dart';
export '../../classes/functions.dart';

export '../../classes/models.dart';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
export 'package:flutter/material.dart';
import '../../classes/dataTypes.dart';
import '../../classes/functions.dart';
import '../../classes/models.dart';
import '../../classes/services/chat_service.dart';
import '../../classes/services/my_service.dart';
import '../../classes/states/main_state.dart';
import '../../main.dart';
import '../../package/any_link_preview/src/helpers/link_preview.dart';
import '../../pages/group_chat/group_chat.dart';
export '../../classes/dataTypes.dart';

String? hasUrl(String text){
  List<String> split = text.split(' ');
  for(int j=0;j<split.length;j++){
    if(split[j].contains('http://') || split[j].contains('https://')){
      return split[j];
    }
  }
  return null;
}

Widget convertHashtag(context, String text,Function onTapTag) {
  if(
  !text.contains('@') &&
      !text.contains('http://') &&
      !text.contains('https://') &&
      !text.contains('footballbuzz://JoinChat/')
  )
    return Text(text,style: TextStyle(
      fontWeight: FontWeight.bold
    ),);
  return Wrap(
    alignment: WrapAlignment.start,
    crossAxisAlignment: WrapCrossAlignment.start,
    runAlignment: WrapAlignment.start,
    spacing: 3,
    runSpacing: 3,
    children: makeText(text).map((e) {
      switch(e.type){
        case TextType.text:
          return GestureDetector(
              onLongPress: () {
                copyText(e.text);
              },
              child: Text(e.text, style: TextStyle(color: black,fontWeight: FontWeight.bold)));
        case TextType.link:
          return SizedBox(
            width: double.maxFinite,
            // height: 100,
            child: AnyLinkPreview(
              link: e.text.trim(),
              doIt: () {},
              displayDirection: UIDirection.uiDirectionHorizontal,
              cache: const Duration(seconds: 1),
              backgroundColor: Colors.white,
              boxShadow: [],
              urlLaunchMode: LaunchMode.externalApplication,
              errorWidget: Container(
                color: Colors.grey[300],
                child: const Text('Oops!'),
              ),
              // errorImage: _errorImage,
            ),
          );
        case TextType.groupLink:
          return GestureDetector(
              onTap: () async{
                String chatRoomId = e.text.replaceAll('footballbuzz://JoinChat/', '');
                DataChatRoom? back = await ChatService.joinGroupChat(getIt<MyService>(),
                    chatRoomId: chatRoomId, userId: getIt<MainState>().userId);
                if(back!=null) {
                  await Go.pushSlideAnim(
                      context,
                      GroupChatBuilder(
                        chatRoom: back,
                      ));
                }
              },
              child: Text(e.text, style: TextStyle(color: mainBlue,fontWeight: FontWeight.bold)));
        case TextType.user:
          return GestureDetector(
              onLongPress: () {
                copyText(text);
              },
              onTap: () {
                onTapTag(context, e.text, true);
              },
              child: Text(e.text, style: TextStyle(color: mainBlue,fontWeight: FontWeight.bold)));
        default:return const SizedBox();
      }

    }).toList(),
  );
}
