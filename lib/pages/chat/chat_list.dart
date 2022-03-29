import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shooting_app/classes/states/chat_state.dart';
import 'package:shooting_app/pages/chat/chat.dart';

import '../../classes/functions.dart';
import '../../classes/models.dart';
import '../../classes/dataTypes.dart';
// class ChatListBuilder extends StatelessWidget {
//   const ChatListBuilder({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return ChatStateProvider(child: ChatList());
//   }
// }

class ChatList extends StatefulWidget {
  const ChatList({Key? key}) : super(key: key);

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  late ChatState state;

  @override
  void initState() {
    super.initState();
    state = Provider.of<ChatState>(context, listen: false);
    state.init();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatState>(
      builder: (context, state, child) {
        if (state.listChats == null)
          return circle();
        else if (state.listChats!.isEmpty)
          return Center(
            child: Text('no message'),
          );
        return Scaffold(
          body: RefreshIndicator(
            onRefresh: () async {
              await state.getChatsList();
            },
            child: ListView.separated(
                padding: EdgeInsets.symmetric(
                    vertical: doubleHeight(2), horizontal: doubleWidth(4)),
                itemBuilder: (context, index) => ChatListItem(
                      chat: state.listChats![index],
                      state: state,
                    ),
                separatorBuilder: (context, index) =>
                    Divider(color: grayCallDark),
                itemCount: state.listChats!.length),
          ),
        );
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
    return ListTile(
      onTap: () async{
        state.selectedChat = chat;
        state.chats.clear();
        state.notify();
        DataChatMessage? message = await Go.pushSlideAnim(
            context,
            ChatBuilder(
              state: state,
            ));
        if(message!=null){
          state.selectedChat.chatMessages.add(message);
          state.notify();
        }
      },
      leading: SizedBox(
        width: doubleWidth(15),
        child: Stack(
          children: [
            if (chat.personalInformations[1].personalInformation != null)
              ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: chat.personalInformations[1].personalInformation!
                              .profilePhoto ==
                          null
                      ? null
                      : imageNetwork(
                          chat.personalInformations[1].personalInformation!
                                  .profilePhoto ??
                              '',
                          fit: BoxFit.fill)),
            if (chat.personalInformations[1].personalInformation!.isOnline)
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
          chat.personalInformations[1].personalInformation?.fullName ?? ''),
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

const Color greenCall = Color.fromRGBO(78, 255, 187, 1);
