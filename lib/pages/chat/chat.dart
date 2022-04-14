import 'package:provider/provider.dart';
import 'package:shooting_app/classes/states/main_state.dart';
import 'package:shooting_app/main.dart';
import 'package:shooting_app/pages/profile/profile.dart';
import 'package:shooting_app/ui_items/shots/index.dart';

import '../../classes/states/chat_state.dart';

class ChatBuilder extends StatelessWidget {
  const ChatBuilder({Key? key, this.state}) : super(key: key);
  final ChatState? state;
  @override
  Widget build(BuildContext context) {
    return ChatStateProvider(
      child: Chat(),
      state: state,
    );
  }
}

class Chat extends StatefulWidget {
  const Chat({Key? key}) : super(key: key);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
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
    print('i ${i++}');
    await state.getChats();
    await Future.delayed(Duration(seconds: 2));
    return startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatState>(builder: (context, state, child) {
      int index = state.selectedChat.personalInformations.indexWhere(
          (element) =>
              element.personalInformation!.id != getIt<MainState>().userId);
      DataChatRoomUser roomUser =
          state.selectedChat.personalInformations[index];
      return WillPopScope(
        onWillPop: () async {
          stopTimer = true;
          Go.pop(context, state.chats.isNotEmpty ? state.chats.first : null);
          return false;
        },
        child: Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                SizedBox(
                  width: double.maxFinite,
                  height: doubleHeight(17),
                  child: Stack(
                    children: [
                      Container(
                        width: double.maxFinite,
                        color: mainBlue,
                        height: doubleHeight(6),
                        padding:
                            EdgeInsets.symmetric(vertical: doubleHeight(1)),
                        alignment: Alignment(-0.9, 0),
                        child: GestureDetector(
                          onTap: () {
                            stopTimer = true;
                            Go.pop(
                                context,
                                state.chats.isNotEmpty
                                    ? state.chats.last
                                    : null);
                          },
                          child: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 35,
                          ),
                        ),
                      ),
                      if (roomUser.personalInformation != null)
                        Positioned(
                          left: 0,
                          right: 0,
                          top: doubleHeight(2),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (roomUser.personalInformation!.profilePhoto !=
                                      null &&
                                  roomUser.personalInformation!.profilePhoto !=
                                      null)
                                GestureDetector(
                                  onTap: () async {
                                    stopTimer = true;
                                    await Go.pushSlideAnim(
                                        context,
                                        ProfileBuilder(
                                            username: roomUser
                                                .personalInformation!
                                                .userName));
                                    stopTimer = false;
                                    startTimer();
                                  },
                                  child: CircleAvatar(
                                    radius: doubleWidth(8),
                                    backgroundColor: Colors.white,
                                    backgroundImage: networkImage(roomUser
                                        .personalInformation!.profilePhoto!),
                                  ),
                                ),
                              SizedBox(height: doubleHeight(1)),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CircleAvatar(
                                    backgroundColor: greenCall,
                                    radius: 6,
                                  ),
                                  SizedBox(width: doubleWidth(3)),
                                  Text(
                                    roomUser.personalInformation!.fullName ??
                                        '',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: mainBlue),
                                  )
                                ],
                              ),
                              SizedBox(height: doubleHeight(1)),
                              Text('@${roomUser.personalInformation!.userName}')
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                Flexible(
                    child: Container(
                  color: Colors.white,
                  child: ListView.separated(
                      reverse: true,
                      padding: EdgeInsets.symmetric(
                          horizontal: doubleWidth(4),
                          vertical: doubleHeight(2)),
                      itemBuilder: (_, index) {
                        if (index + 1 != state.chats.length) {
                          bool first = state.chats[index].name ==
                              state.selectedChat.personalInformations[0]
                                  .personalInformation!.userName;
                          bool second = state.chats[index + 1].name ==
                              state.selectedChat.personalInformations[0]
                                  .personalInformation!.userName;

                          return ChatItem(
                            person: state.selectedChat.personalInformations[0]
                                .personalInformation!,
                            message: state.chats[index],
                            hasDate: (first == second) ? false : true,
                          );

                          // return ChatItem(
                          //   message: state.chats[index],
                          //   hasDate: true,
                          // );

                        } else {
                          return ChatItem(
                            person: state.selectedChat.personalInformations[0]
                                .personalInformation!,
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
                        onTap: () {
                          if (controller.value.text.trim() == '') return;
                          state.sendMessage(controller.value.text.trim());
                          state.notify();
                          controller.clear();
                        },
                        child: Container(
                          padding: EdgeInsets.all(doubleWidth(4)),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: greenCall,
                          ),
                          child: Icon(
                            Icons.arrow_upward,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(width: doubleWidth(4)),
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
  @override
  Widget build(BuildContext context) {
    print('message ${widget.message} ${widget.hasDate}');

    bool isMine = widget.message.name == getIt<MainState>().userName;
    return Align(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        textDirection: isMine ? TextDirection.rtl : TextDirection.ltr,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(maxWidth: doubleWidth(70)),
            decoration: BoxDecoration(
              color: isMine ? greenCall : Color.fromRGBO(244, 244, 244, 1),
              borderRadius: BorderRadius.circular(5),
            ),
            padding: EdgeInsets.symmetric(
                vertical: doubleHeight(1), horizontal: doubleWidth(2)),
            child: Text(widget.message.text ?? ''),
          ),
          if (widget.hasDate)
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: doubleHeight(1)),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  textDirection: isMine ? TextDirection.rtl : TextDirection.ltr,
                  children: [
                    if (isMine)
                      SizedBox(
                          width: 15,
                          height: 15,
                          child: Image.asset(
                            'assets/images/seen.png',
                            color: mainBlue,
                          )),
                    if (isMine) SizedBox(width: doubleWidth(1)),
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
