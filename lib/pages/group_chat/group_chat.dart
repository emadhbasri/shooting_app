import 'dart:io';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shooting_app/classes/services/chat_service.dart';
import 'package:shooting_app/classes/services/my_service.dart';
import 'package:shooting_app/classes/states/main_state.dart';
import 'package:shooting_app/main.dart';
import 'package:shooting_app/pages/group_chat/group_members.dart';
import 'package:shooting_app/pages/profile/profile.dart';
import 'package:shooting_app/ui_items/shots/index.dart';
import 'package:shooting_app/ui_items/shots/video_item.dart';
import 'package:video_player/video_player.dart';

import '../../classes/states/chat_state.dart';
import '../../classes/states/group_chat_state.dart';
import '../../package/any_link_preview/src/helpers/link_preview.dart';
import '../../ui_items/gal.dart';

class GroupChatBuilder extends StatelessWidget {
  const GroupChatBuilder({Key? key, this.state}) : super(key: key);
  final ChatState? state;
  @override
  Widget build(BuildContext context) {
    return ChatStateProvider(
      child: GroupChat(),
      state: state,
    );
  }
}

class GroupChat extends StatefulWidget {
  const GroupChat({Key? key}) : super(key: key);

  @override
  _GroupChatState createState() => _GroupChatState();
}

class _GroupChatState extends State<GroupChat> {
  TextEditingController controller = TextEditingController();

  late ChatState state;
  @override
  void initState() {
    super.initState();
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
    return Consumer<ChatState>(builder: (context, state, child) {

      return WillPopScope(
        onWillPop: () async {
          stopTimer = true;
          Go.pop(context, state.chats.isNotEmpty ? state.chats.first : null);
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            title: Padding(
              padding: EdgeInsets.only(bottom: 4),
              child: ListTile(
                onTap: (){
                  Go.pushSlideAnim(context, GroupChatMemberBuilder());
                },
                dense: true,
                contentPadding: EdgeInsets.zero,
                leading: AspectRatio(
                  aspectRatio: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(width: 1,color: white),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    // width: doubleWidth(10),
                    child: Center(child: Text(state.selectedChat.name==null?'':state.selectedChat.name![0],style: TextStyle(
                        color: white,
                        fontSize: 17,
                        fontWeight: FontWeight.bold
                    ),)),
                  ),
                ),
                title: Text(state.selectedChat.name??'',style: TextStyle(
                  color: white
                ),),
                subtitle: Text('${state.selectedChat.personalInformations.length} members',style: TextStyle(
                    color: white
                )),
              ),
            ),
            actions: [
              PopupMenuButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                itemBuilder: (context) => [
                  PopupMenuItem(
                      onTap: () async {

                      },
                      child: Text('Copy The Group Link')),
                ],
              )
            ],
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
                Flexible(
                    child: Container(
                  color: Colors.white,
                  child: ListView.separated(
                    physics: BouncingScrollPhysics(),
                      reverse: true,
                      padding: EdgeInsets.symmetric(
                          horizontal: doubleWidth(4),
                          vertical: doubleHeight(2)),
                      itemBuilder: (_, index) {
                        if (index + 1 != state.chats.length) {
                          bool first = state.chats[index].name ==
                              state.selectedChat.personalInformations[0]!
                                  .userName;
                          bool second = state.chats[index + 1].name ==
                              state.selectedChat.personalInformations[0]!
                                  .userName;

                          return ChatItem(
                            person:
                                state.selectedChat.personalInformations.singleWhere(
                                        (element) =>
                                        element!.userName==state.chats[index].name
                                )!,
                            // state.selectedChat.personalInformations[0]
                            //     .personalInformation!,
                            message: state.chats[index],
                            hasDate: (first == second) ? false : true,
                          );

                          // return ChatItem(
                          //   message: state.chats[index],
                          //   hasDate: true,
                          // );

                        } else {
                          return ChatItem(
                            person: state.selectedChat.personalInformations[0]!,
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
                  color: Colors.white,
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
                            keyboardType: TextInputType.multiline,
                            decoration: InputDecoration(
                                hintStyle: TextStyle(
                                    color: Color.fromRGBO(214, 216, 217, 1)),
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
                Container(height: doubleHeight(2), color: Colors.white),
              ],
            ),
          ),
        ),
      );
    });
  }
}


class ChooseMediaDialog extends StatelessWidget {
  const ChooseMediaDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),

      child: Container(
        margin: EdgeInsets.all(doubleWidth(4)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            Center(
              child: Text('Please Pick Media',style: Theme.of(context).textTheme.titleLarge ),
            ),
            SizedBox(height: doubleHeight(2)),

            Container(
              decoration: BoxDecoration(
                border: Border.all(width: 1,color: Colors.black),
                borderRadius: BorderRadius.circular(5),
              ),
              child: ListTile(
                onTap: ()async{
                  XFile? out =
                  await ImagePicker().pickImage(source: ImageSource.camera);
                  return Go.pop(context,out);
                },
                title: Text('Camera Image'),
                trailing: Icon(
                  Icons.camera_alt,
                  color: Color.fromRGBO(107, 79, 187, 1),
                ),
              ),
            ),SizedBox(height: doubleHeight(1)),
            Container(
              decoration: BoxDecoration(
                border: Border.all(width: 1,color: Colors.black),
                borderRadius: BorderRadius.circular(5),
              ),
              child: ListTile(
                onTap: ()async{
                  XFile? out =
                  await ImagePicker().pickImage(source: ImageSource.gallery);
                  print('emad $out');
                  return Go.pop(context,out);
                },
                title: Text('Library Image'),
                trailing: Icon(
                  Icons.image,
                  color: Color.fromRGBO(107, 79, 187, 1),
                ),
              ),
            ),SizedBox(height: doubleHeight(1)),
            Container(
              decoration: BoxDecoration(
                border: Border.all(width: 1,color: Colors.black),
                borderRadius: BorderRadius.circular(5),
              ),
              child: ListTile(
                onTap: ()async{
                  final XFile? video = await ImagePicker()
                      .pickVideo(source: ImageSource.gallery);

                  if (video != null) {
                    print('video.mimeType ${video.name}');

                    if (!video.name.endsWith('.mp4')) {
                      toast('The video format should be mp4');
                      return;
                    }

                    if (await video.length() > 20000000) {
                      print(
                          'await video.length() ${await video.length()}');
                      toast('The video should be less than 20M.',
                          duration: Toast.LENGTH_LONG);
                      return;
                    }
                    VideoPlayerController _controller =
                    VideoPlayerController.file(
                        File(video.path));
                    await _controller.initialize();
                    Duration duration = _controller.value.duration;
                    if (duration.inSeconds <= 121) {
                      return Go.pop(context,video);
                    } else {
                      toast(
                          'The video should be less than 60 seconds.',
                          duration: Toast.LENGTH_LONG);
                    }
                  }

                },
                title: Text('Library Video'),
                trailing: Icon(
                  Icons.video_library_outlined,
                  color: Color.fromRGBO(107, 79, 187, 1),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class ChatItem extends StatefulWidget {
  const ChatItem(
      {Key? key,
      required this.hasDate,
      required this.message,
      required this.person})
      : super(key: key);
  final bool hasDate;
  final DataPersonalInformation person;
  final DataChatMessage message;
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

    String? hasurl=hasUrl(widget.message.text ?? '');


    return Align(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        textDirection: isMine ? TextDirection.rtl : TextDirection.ltr,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            textDirection: isMine ? TextDirection.rtl : TextDirection.ltr,
            children: [
              if(!isMine)
                GestureDetector(
                  onTap: () {
                    Go.pushSlideAnim(
                        context,
                        ProfileBuilder(
                            username: widget.person.userName));
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: SizedBox(
                        width: doubleHeight(5),
                        height: doubleHeight(5),
                        child: Builder(
                          builder: (context) {
                            if (widget.person.profilePhoto !=
                                null) {
                              return imageNetwork(
                                widget.person.profilePhoto!,
                                fit: BoxFit.fill,
                              );
                            }
                            return profilePlaceHolder();
                          },
                        )),
                  ),
                ),
              if(!isMine)
              SizedBox(width: doubleWidth(1)),
              PopupMenuButton<String>(
                key: popupkey,
                itemBuilder: (_)=>[
                  if(hasurl!=null)
                    PopupMenuItem<String>(child: Text('open'),value: 'open'),
                  if(widget.message.messageMediaTypes==null)
                    PopupMenuItem<String>(child: Text('Copy'),value: 'Copy'),
                    PopupMenuItem<String>(child: Text('Delete',style: TextStyle(color: red),),value: 'Delete'),
                ],
                onSelected: (String e){
                  if(e=='Delete'){
                    ChatService.deleteMessage(getIt<MyService>(), messageId: widget.message.id);
                  }else if(e=='Copy'){
                    copyText(widget.message.text??'');
                  }else if(e=='open'){
                    openUrl(hasurl!);
                  }
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
                              child: VideoItem(
                                  controller: controller,
                                  url: widget.message.messageMediaTypes!.media,
                              aspectRatio: 2,
                              ),
                            ),
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
                    }else if(hasurl!=null){
                      return Container(
                        padding: EdgeInsets.only(
                            top: 4,right: 4,left: 4
                        ),
                        decoration: BoxDecoration(
                          color: isMine ? greenCall : Color.fromRGBO(244, 244, 244, 1),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        constraints: BoxConstraints(maxWidth: doubleWidth(70)),
                        width: double.maxFinite,
                        // height: 100,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AbsorbPointer(
                              absorbing: true,
                              child: AnyLinkPreview(
                                link: hasurl.trim(),
                                doIt: (){},
                                borderRadius: 0,
                                displayDirection: UIDirection.uiDirectionVertical,
                                cache: const Duration(seconds: 1),
                                backgroundColor: Colors.transparent,
                                boxShadow: [],
                                // urlLaunchMode: LaunchMode.platformDefault,
                                errorWidget: Container(
                                  color: Colors.grey[300],
                                  child: const Text('Oops!'),
                                ),
                                // errorImage: _errorImage,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(widget.message.text ?? '',),
                            ),
                          ],
                        ),
                      );
                    }else{
                      return Container(
                        constraints: BoxConstraints(maxWidth: doubleWidth(70)),
                        decoration: BoxDecoration(
                          color: isMine ? greenCall : Color.fromRGBO(244, 244, 244, 1),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        padding: EdgeInsets.symmetric(
                            vertical: doubleHeight(1), horizontal: doubleWidth(2)),
                        child: Text(widget.message.text ?? '',),
                      );
                    }

                  }),
                ),
              ),
            ],
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
                      style: TextStyle(color: grayCall, fontSize: 12),
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
