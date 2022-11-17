import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shooting_app/classes/services/chat_service.dart';
import 'package:shooting_app/classes/services/my_service.dart';
import 'package:shooting_app/classes/states/main_state.dart';
import 'package:shooting_app/main.dart';
import 'package:shooting_app/pages/profile/profile.dart';
import 'package:shooting_app/ui_items/shots/index.dart';
import 'package:shooting_app/ui_items/shots/video_item.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

import '../../classes/states/chat_state.dart';
import '../../classes/states/theme_state.dart';
import '../../package/any_link_preview/src/helpers/link_preview.dart';
import '../../ui_items/dialogs/choose_media_dialog.dart';
import '../../ui_items/gal.dart';
import '../group_chat/group_chat.dart';

class ChatBuilder extends StatelessWidget {
  const ChatBuilder({Key? key, this.state,this.sharedText}) : super(key: key);
  final ChatState? state;
  final String? sharedText;
  @override
  Widget build(BuildContext context) {
    return ChatStateProvider(
      child: Chat(sharedText: sharedText),
      state: state,
    );
  }
}

class Chat extends StatefulWidget {
  const Chat({Key? key,this.sharedText}) : super(key: key);
  final String? sharedText;
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  TextEditingController controller = TextEditingController();

  late ChatState state;
  @override
  void initState() {
    super.initState();
    if(widget.sharedText!=null){
      controller=TextEditingController(text: widget.sharedText);
    }
    state = Provider.of<ChatState>(context, listen: false);
    startTimer();
    state.getChats();
  }

  bool stopTimer = false;
  int i = 0;
  startTimer() async {
    if (stopTimer) return;
    await state.getChats();
    await Future.delayed(Duration(seconds: 2));
    return startTimer();
  }
bool loadingImageSend=false;
  @override
  Widget build(BuildContext context) {
    return Consumer2<ChatState,ThemeState>(builder: (context, state,theme, child) {

      int index = state.selectedChat.personalInformations.indexWhere(
          (element) =>element==null?false:
              element.id != getIt<MainState>().userId);
      DataPersonalInformation? roomUser =
          state.selectedChat.personalInformations[index];
      print('roomUser.profilePhoto ${roomUser!.profilePhoto}');

      return WillPopScope(
        onWillPop: () async {
          stopTimer = true;
          Go.pop(context, state.chats.isNotEmpty ? state.chats.first : null);
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            title: roomUser != null?Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  contentPadding: EdgeInsets.only(bottom: 4),
                  leading: roomUser
                          .profilePhoto==null?null:
                  GestureDetector(
                    onTap: () async {
                      stopTimer = true;
                      await Go.pushSlideAnim(
                          context,
                          ProfileBuilder(
                              username: roomUser
                                  .userName));
                      stopTimer = false;
                      startTimer();
                    },
                    child: CircleAvatar(
                      radius: doubleWidth(8),
                      backgroundColor: Colors.white,
                      backgroundImage: networkImage(roomUser
                          .profilePhoto!),
                    ),
                  ),
                  title: Text(
                    roomUser.fullName ??
                        '',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: white),
                  ),
                  subtitle: Text('@${roomUser.userName}'),
                ),
              
              ],
            ):null,
          ),
          // floatingActionButton: FloatingActionButton(
          //   tooltip: 'Send Message',
          //   onPressed: (){},
          //   elevation: 2,
          //   backgroundColor: mainGreen,
          //   child: Container(
          //       width: doubleWidth(9),
          //       height: doubleWidth(9),
          //       child: Padding(
          //         padding: EdgeInsets.all(4.0),
          //         child: Image.asset('assets/images/soccer(1).png'),
          //       )),
          // ),
          body: SafeArea(
            child: Column(
              children: [
                // SizedBox(
                //   width: double.maxFinite,
                //   height: doubleHeight(17),
                //   child: Stack(
                //     children: [
                //       Container(
                //         width: double.maxFinite,
                //         color: mainBlue,
                //         height: doubleHeight(6),
                //         padding:
                //             EdgeInsets.symmetric(vertical: doubleHeight(1)),
                //         alignment: Alignment(-0.9, 0),
                //         child: GestureDetector(
                //           onTap: () {
                //             stopTimer = true;
                //             Go.pop(
                //                 context,
                //                 state.chats.isNotEmpty
                //                     ? state.chats.last
                //                     : null);
                //           },
                //           child: Icon(
                //             Icons.adaptive.arrow_back,
                //             color: Colors.white,
                //             size: 30,
                //           ),
                //         ),
                //       ),
                //       if (roomUser != null)
                //         Positioned(
                //           left: 0,
                //           right: 0,
                //           top: doubleHeight(2),
                //           child: Column(
                //             mainAxisSize: MainAxisSize.min,
                //             children: [
                //               if (roomUser.profilePhoto !=
                //                       null)
                //                 GestureDetector(
                //                   onTap: () async {
                //                     stopTimer = true;
                //                     await Go.pushSlideAnim(
                //                         context,
                //                         ProfileBuilder(
                //                             username: roomUser
                //
                //                                 .userName));
                //                     stopTimer = false;
                //                     startTimer();
                //                   },
                //                   child: CircleAvatar(
                //                     radius: doubleWidth(8),
                //                     backgroundColor: Colors.white,
                //                     backgroundImage: networkImage(roomUser
                //                         .profilePhoto!),
                //                   ),
                //                 ),
                //               SizedBox(height: doubleHeight(1)),
                //               Row(
                //                 mainAxisSize: MainAxisSize.min,
                //                 children: [
                //                   CircleAvatar(
                //                     backgroundColor: greenCall,
                //                     radius: 6,
                //                   ),
                //                   SizedBox(width: doubleWidth(3)),
                //                   Text(
                //                     roomUser.fullName ??
                //                         '',
                //                     style: TextStyle(
                //                         fontWeight: FontWeight.bold,
                //                         color: mainBlue),
                //                   )
                //                 ],
                //               ),
                //               SizedBox(height: doubleHeight(1)),
                //               Text('@${roomUser.userName}')
                //             ],
                //           ),
                //         ),
                //     ],
                //   ),
                // ),
                Flexible(

                    child: Container(
                  color: theme.isDarkMode?MyThemes.darkTheme.scaffoldBackgroundColor:Colors.white,
                  child: ListView.separated(
                    physics: BouncingScrollPhysics(),
                      reverse: true,
                      padding: EdgeInsets.symmetric(
                          horizontal: doubleWidth(4),
                          vertical: doubleHeight(2)),
                      itemBuilder: (_, index) {
                        if (index + 1 != state.chats.length) {
                          bool first = state.chats[index].name ==
                              state.selectedChat.personalInformations[0]
                                  !.userName;
                          bool second = state.chats[index + 1].name ==
                              state.selectedChat.personalInformations[0]
                                  !.userName;

                          return ChatItem(
                            state: state,
                            person: state.selectedChat.personalInformations[0]
                                !,
                            message: state.chats[index],
                            hasDate: (first == second) ? false : true,
                          );

                          // return ChatItem(
                          //   message: state.chats[index],
                          //   hasDate: true,
                          // );

                        } else {
                          return ChatItem(
                            state: state,
                            person: state.selectedChat.personalInformations[0]
                                !,
                            message: state.chats[index],
                            hasDate: true,
                          );
                        }
                      },
                      separatorBuilder: (_, index) =>
                          SizedBox(height: doubleHeight(1)),
                      itemCount: state.chats.length),
                )),
                Container(
                  color: theme.isDarkMode?MyThemes.darkTheme.scaffoldBackgroundColor:Colors.white,
                  width: double.maxFinite,
                  child: Row(
                    children: [
                      SizedBox(width: doubleWidth(4)),
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
                            controller: controller,
                            // onChanged: (e){
                            //   setState(() {
                            //     text=e;
                            //   });
                            // },
                            minLines: 1,
                            maxLines: 3,
                            style: TextStyle(
                              color: black,
                            ),
                            keyboardType: TextInputType.multiline,
                            decoration: InputDecoration(
                                hintStyle: TextStyle(
                                    // color: Color.fromRGBO(214, 216, 217, 1)
                                ),
                                hintText: 'Write your message...',
                                border: InputBorder.none),
                          ),
                        ),
                      ),
                      SizedBox(width: doubleWidth(4)),
                      GestureDetector(
                        onTap: () async{
                          XFile? file = await showDialog(
                              context: context,
                              builder: (contextD)=>ChooseMediaDialog());
                          if (file==null) return;
                          setState(() {
                            loadingImageSend=true;
                          });
                          await state.sendMessage(
                              file: file
                          );
                          setState(() {
                            loadingImageSend=false;
                          });
                          state.notify();
                        },
                        child: Container(
                          padding: EdgeInsets.all(doubleWidth(4)),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: greenCall,
                          ),
                          child: loadingImageSend?simpleCircle():Icon(
                            Icons.photo_library_rounded,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(width: doubleWidth(2)),
                      GestureDetector(
                        onTap: () {
                          if (controller.value.text.trim() == '') return;
                          state.sendMessage(
                            message: controller.value.text.trim()
                          );
                          state.notify();
                          controller.clear();
                        },
                        child: Container(
                          padding: EdgeInsets.all(doubleWidth(4)),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: greenCall,
                          ),
                          child: Container(
                              width: doubleWidth(6),
                              height: doubleWidth(6),
                              child: Image.asset('assets/images/soccer(1).png')),
                        ),
                      ),
                      SizedBox(width: doubleWidth(2)),
                    ],
                  ),
                ),
                Container(height: doubleHeight(2), color: theme.isDarkMode?MyThemes.darkTheme.scaffoldBackgroundColor:Colors.white
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}




class ChatItem extends StatefulWidget {
  const ChatItem(
      {Key? key,
      required this.hasDate,
      required this.message,
      required this.person,
      required this.state,
      })
      : super(key: key);
  final bool hasDate;
  final DataPersonalInformation person;
  final DataChatMessage message;
  final ChatState state;
  @override
  _ChatItemState createState() => _ChatItemState();
}

class _ChatItemState extends State<ChatItem> {
  late VideoPlayerController controller;
  bool loadingVideo = true;
  GlobalKey<PopupMenuButtonState> popupkey = GlobalKey<PopupMenuButtonState>();
  @override
  void initState() {
    super.initState();
    init();
  }
  init()async{

    if (widget.message.messageMediaTypes!=null && widget.message.messageMediaTypes!.media.contains('video/upload'))
    {
      controller = VideoPlayerController.network(widget.message.messageMediaTypes!.media);
      await controller.initialize();
      setState(() {
        loadingVideo=false;
      });
    }
  }
  @override
  void dispose() {
    super.dispose();
    if (widget.message.messageMediaTypes!=null && widget.message.messageMediaTypes!.media.contains('video/upload'))
      controller.dispose();
  }
  @override
  Widget build(BuildContext context) {
    // print('message ${widget.message} ${widget.hasDate}');
    bool isMine = widget.message.name == getIt<MainState>().userName;
    // String? hasurl=hasUrl(widget.message.text ?? '');
    return Align(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        textDirection: isMine ? TextDirection.rtl : TextDirection.ltr,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          PopupMenuButton<String>(
            key: popupkey,
            itemBuilder: (_)=>[
              // if(hasurl!=null)
              //   PopupMenuItem<String>(child: Text('open'),value: 'open'),
              if(widget.message.messageMediaTypes==null)
                PopupMenuItem<String>(child: Text('Copy'),value: 'Copy'),
                PopupMenuItem<String>(child: Text('Delete',style: TextStyle(color: red),),value: 'Delete'),
            ],
            onSelected: (String e){
              if(e=='Delete'){
                ChatService.deleteMessage(getIt<MyService>(), messageId: widget.message.id);
              }else if(e=='Copy'){
                copyText(widget.message.text??'');
              }
              // else if(e=='open'){
              //   openUrl(hasurl!);
              // }
            },
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),),
            child: GestureDetector(
              onLongPress: (){
                popupkey.currentState!.showButtonMenu();
              },
              child: Builder(builder: (context) {
                if(widget.message.messageMediaTypes!=null){
                  if(widget.message.messageMediaTypes!.media.contains('video/upload')){
                    if(loadingVideo)
                      init();

                    return Container(
                      constraints: BoxConstraints(maxWidth: doubleWidth(70)),
                      decoration: BoxDecoration(
                        // color: isMine ? greenCall : Color.fromRGBO(244, 244, 244, 1),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      padding: EdgeInsets.symmetric(
                          vertical: doubleHeight(1), horizontal: doubleWidth(2)),
                      child: loadingVideo?Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const CircularProgressIndicator(),
                            SizedBox(height: doubleHeight(1)),
                            const Text(
                              'loading ...',
                              textDirection: TextDirection.ltr,
                              style: TextStyle(
                                  color: mainBlue,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ):Center(
                        child: SizedBox(
                            width: doubleWidth(70),
                            height: doubleHeight(30),
                            child: VideoItem(controller: controller,url: widget.message.messageMediaTypes!.media,aspectRatio: 2,)),
                      ),
                    );

                  }else{
                    return GestureDetector(
                      onTap: (){
                        Go.push(context, Gal(images: [widget.message.messageMediaTypes!.media]));
                      },
                      child: Container(
                        width: doubleWidth(70),
                        height: doubleHeight(30),
                        decoration: BoxDecoration(
                          // color: isMine ? greenCall : Color.fromRGBO(244, 244, 244, 1),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        padding: EdgeInsets.symmetric(
                            vertical: doubleHeight(1), horizontal: doubleWidth(2)),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: imageNetwork(
                              widget.message.messageMediaTypes!.media,
                              fit: BoxFit.fill,
                            )),
                      ),
                    );
                  }
                }else {
                  return Container(
                      constraints: BoxConstraints(maxWidth: doubleWidth(70)),
                      decoration: BoxDecoration(
                        color: isMine ? greenCall : Color.fromRGBO(244, 244, 244, 1),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      padding: EdgeInsets.symmetric(
                          vertical: doubleHeight(1), horizontal: doubleWidth(2)),
                      child: Builder(
                        builder: (context) {
                          return Wrap(
                            alignment: WrapAlignment.start,
                            crossAxisAlignment: WrapCrossAlignment.start,
                            runAlignment: WrapAlignment.start,
                            spacing: 3,
                            runSpacing: 3,
                            children: makeText(widget.message.text??'').map((e) {
                              switch(e.type){
                                case TextType.text:
                                  return GestureDetector(
                                      onLongPress: () {
                                        copyText(e.text);
                                      },
                                      child: Text(e.text, style: TextStyle(color: black)));
                                case TextType.link:
                                  return SizedBox(
                                    width: double.maxFinite,
                                    // height: 100,
                                    child: AnyLinkPreview(
                                      key: Key('${widget.message.id}chat'),
                                      link: e.text.trim(),
                                      doIt: () {
                                        popupkey.currentState!.showButtonMenu();
                                      },
                                      displayDirection: UIDirection.uiDirectionVertical,
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
                                          DataChatRoom temp = widget.state.selectedChat;
                                          await Go.pushSlideAnim(
                                              context,
                                              GroupChatBuilder(
                                                chatRoom: back,
                                              ));
                                          widget.state.selectedChat=temp;
                                          widget.state.notify();
                                        }
                                      },
                                      child: Text(e.text, style: TextStyle(color: mainBlue)));
                                case TextType.user:
                                  return GestureDetector(
                                      onLongPress: () {
                                        copyText(e.text);
                                      },
                                      onTap: () {
                                        Go.pushSlideAnim(context, ProfileBuilder(username: e.text));
                                      },
                                      child: Text(e.text, style: TextStyle(color: mainBlue)));
                                default:return const SizedBox();
                              }

                            }).toList(),
                          );
                        },
                      )
                    // Text(widget.message.text ?? '',),
                  );
                }

              }),
            ),
          ),
          // if (widget.hasDate)
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: doubleHeight(1)),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  textDirection: isMine ? TextDirection.rtl : TextDirection.ltr,
                  children: [
                    // if (isMine)
                    //   SizedBox(
                    //       width: 15,
                    //       height: 15,
                    //       child: Image.asset(
                    //         'assets/images/seen.png',
                    //         color: mainBlue,
                    //       )),
                    // if (isMine) SizedBox(width: doubleWidth(1)),

                    Text(
                      '${widget.message.timeStamp.hour}'
                      ' : ${widget.message.timeStamp.minute} ${widget.message.timeStamp.hour < 12 ? 'AM' : 'PM'}',
                      style: TextStyle(
                          // color: grayCall,
                          fontSize: 12),
                    )
                  ],
                ),
              ],
            )
        ],
      ),
    );
  }
}
