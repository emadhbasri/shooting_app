import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shooting_app/classes/states/chat_state.dart';
import 'package:shooting_app/pages/chat/chat.dart';

import '../../classes/functions.dart';
import '../../classes/models.dart';
import '../../classes/dataTypes.dart';
import '../../classes/states/main_state.dart';
import '../../main.dart';

class ChatList extends StatefulWidget {
  const ChatList({Key? key}) : super(key: key);

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  late ChatState state;
  late ScrollController _listController;
  @override
  void initState() {
    super.initState();
    state = Provider.of<ChatState>(context, listen: false);
    state.init();
    _listController = ScrollController()
      ..addListener(() {
          if (
          state.listChats.isNotEmpty
              && _listController.position.atEdge &&
              _listController.offset != 0.0) {
            debugPrint("notifHasNext ${state.chatHasNext}");
            if (state.chatHasNext) {
              state.pageNumber++;
              state.getChatsList();
            }
          }
      });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatState>(
      builder: (context, state, child) {
        if (state.loadingListCaht) return circle();

        return Scaffold(
            body: RefreshIndicator(
          onRefresh: () async {
            await state.getChatsList(clean: true);
          },
          child: state.listChats.isEmpty
              ? ListView(
            physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(vertical: doubleHeight(1)),
                  children: [
                    SizedBox(
                        height: doubleHeight(70),
                        width: double.maxFinite,
                        child: Center(child: Text('no message. 🙂'))),
                  ],
                )
              : ListView(
            physics: AlwaysScrollableScrollPhysics(),
                  controller: _listController,
                  padding: EdgeInsets.symmetric(
                      vertical: doubleHeight(2), horizontal: doubleWidth(4)),
                  children: [
                    ...state.listChats
                        .map((e) => Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ChatListItem(
                                  chat: e,
                                  state: state,
                                ),
                                if (e != state.listChats.last)
                                  Divider(color: grayCallDark)
                              ],
                            ))
                        .toList(),
                    if (state.chatHasNext)
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(height: doubleHeight(1)),
                          CircularProgressIndicator(),
                          SizedBox(height: doubleHeight(1)),
                        ],
                      )
                  ],
                ),
        ));
      },
    );
  }
}

class ChatListItem extends StatelessWidget {
  const ChatListItem({Key? key, required this.chat, required this.state})
      : super(key: key);
  final DataChatRoom chat;
  final ChatState state;
  @override
  Widget build(BuildContext context) {
    int index =
    chat.personalInformations.indexWhere((element) =>
    element.personalInformation!.id!=getIt<MainState>().userId);
    DataChatRoomUser roomUser = chat.personalInformations[index];
    return ListTile(
      onTap: () async {
        state.selectedChat = chat;
        state.chats.clear();
        state.notify();
        DataChatMessage? message = await Go.pushSlideAnim(
            context,
            ChatBuilder(
              state: state,
            ));
        if (message != null) {
          state.selectedChat.chatMessages.add(message);
          state.notify();
        }
      },
      leading: SizedBox(
        width: doubleWidth(15),
        child: Stack(
          children: [
            if (roomUser.personalInformation != null)
              ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: roomUser.personalInformation!
                              .profilePhoto ==
                          null
                      ? null
                      : imageNetwork(
                          roomUser.personalInformation!
                                  .profilePhoto ??
                              '',
                          fit: BoxFit.fill)),
            if (roomUser.personalInformation!.isOnline)
              Align(
                alignment: Alignment(0.9, 0.9),
                child: CircleAvatar(
                  backgroundColor: greenCall,
                  radius: 5,
                ),
              )
          ],
        ),
      ),
      title: Text(
          roomUser.personalInformation?.fullName ?? ''),
      subtitle: chat.chatMessages.isEmpty
          ? null
          : Text(
              chat.chatMessages.last.text ?? '',
              style: TextStyle(height: 2),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          // CircleAvatar(
          //   radius: 10,
          //   backgroundColor: greenCall,
          //   child: Text(chat.newMessages.toString()),
          // ),
          // SizedBox(height: doubleHeight(1)),
          // Text(chat.messages.isNotEmpty?
          //   '${chat.messages.last.date.hour}'
          //     ' : ${chat.messages.last.date.minute} ${
          //   chat.messages.last.date.hour<12?'AM':'PM'
          //   }':'')
        ],
      ),
    );
  }
}

