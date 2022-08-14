export 'reply_from_shot.dart';

export '../bottom_sheet.dart';
export '../dialogs/share_dialog.dart';
export '../../classes/functions.dart';

export '../../classes/models.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shooting_app/classes/states/theme_state.dart';
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
import 'package:provider/provider.dart';

import '../../pages/profile/profile.dart';
String? hasUrl(String text){
  List<String> split = text.split(' ');
  for(int j=0;j<split.length;j++){
    if(split[j].contains('http://') || split[j].contains('https://')){
      return split[j];
    }
  }
  return null;
}

Widget convertHashtag(BuildContext context, String text,Function onTapTag) {
  if(
  !text.contains('@') &&
      !text.contains('http://') &&
      !text.contains('https://') &&
      !text.contains('https://footballbuzz.co?joinchat=')
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
              child: Text(e.text, style: TextStyle(fontWeight: FontWeight.bold)));
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
              errorWidget: GestureDetector(
                  onTap: (){
                    openUrl(e.text.trim());
                  },
                  child: Text(e.text.trim(),style: TextStyle(
                    color: context.watch<ThemeState>().isDarkMode?greenCall:mainBlue,
                  ),),
                ),
              // errorImage: _errorImage,
            ),
          );
        case TextType.groupLink:
          return GestureDetector(
              onTap: () async{
                String chatRoomId = e.text.replaceAll('https://footballbuzz.co?joinchat=', '');
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
              child: Text(e.text, style: TextStyle(color: context.watch<ThemeState>().isDarkMode?greenCall:mainBlue,fontWeight: FontWeight.bold)));
        case TextType.user:
          return GestureDetector(
              onLongPress: () {
                copyText(text);
              },
              onTap: () {
                Go.pushSlideAnim(context, ProfileBuilder(username: e.text));
                // onTapTag(context, e.text, true);
              },
              child: Text(e.text, style: TextStyle(color: context.watch<ThemeState>().isDarkMode?greenCall:mainBlue,fontWeight: FontWeight.bold)));
        default:return const SizedBox();
      }

    }).toList(),
  );
}


trashIcon(BuildContext context){
  return Consumer<ThemeState>(builder: (context, state, child) {
    return Icon(CupertinoIcons.trash_fill,color: state.isDarkMode?Colors.white:Colors.black,);
  });
}

// favoriteIcon(BuildContext context){
//   return Consumer<ThemeState>(builder: (context, state, child) {
//     return Icon(CupertinoIcons.trash_fill,color: state.isDarkMode?Colors.white:Colors.black,);
//   });
// }
