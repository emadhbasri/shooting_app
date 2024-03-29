import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shooting_app/classes/states/chat_state.dart';
import 'package:shooting_app/pages/chat/chat.dart';

import '../../classes/functions.dart';
import '../../classes/models.dart';
import '../../classes/dataTypes.dart';
import '../../classes/states/main_state.dart';
import '../../main.dart';
import '../group_chat/create_group.dart';
import '../group_chat/group_chat.dart';

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
        if (state.listChats.isNotEmpty &&
            _listController.position.atEdge &&
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
                          child: Center(child: Text('${AppLocalizations.of(context)!.nomessage} 🙂'))),
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
                                  if (e.chatType == 1)
                                    ChatListItem(
                                      chat: e,
                                      state: state,
                                    )
                                  else
                                    GroupChatListItem(
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
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: mainGreen,
            onPressed: () async {
              bool? bb = await Go.pushSlideAnim(context, CreateGroup());
              if (bb != null && bb) {
                state.getChatsList(clean: true);
              }
            },
            heroTag: 'Create New Group Chat',
            child: Icon(Icons.group,color: black,),
            // heroTag: 'Create New Chat',
            // child: Icon(Icons.message),
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
    int index = chat.personalInformations.indexWhere((element) =>
        element == null ? false : element.id != getIt<MainState>().userId);
    print('emad personalInformations ${chat.personalInformations.length}');

    DataPersonalInformation? roomUser = chat.personalInformations[index];
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
          state.selectedChat.chatMessages.insert(0, message);
          state.getChatsList(clean: true);
          state.notify();
        }
      },
      leading: SizedBox(
        width: doubleWidth(15),
        child: Stack(
          children: [
            if (roomUser != null)
              SizedBox(
                width: doubleHeight(5),
                height: doubleHeight(5),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: roomUser.profilePhoto == null
                        ? profilePlaceHolder(context)
                        : imageNetwork(roomUser.profilePhoto ?? '',
                            fit: BoxFit.fill)),
              ),
            Align(
              alignment: Alignment(1, -1),
              child: SizedBox(
                width: doubleHeight(3),
                height: doubleHeight(3),
                child: Builder(
                  builder: (context) {
                    if (roomUser!.team != null &&
                        roomUser.team!.team_badge != null) {
                      return Container(
                        decoration: BoxDecoration(
                            color: white,
                            border: Border.all(color: white, width: 2),
                            borderRadius: BorderRadius.circular(100),
                            image: DecorationImage(
                              image: networkImage(roomUser.team!.team_badge!),
                            )),
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ),
            )
            // if (roomUser!=null && roomUser.isOnline)
            //   Align(
            //     alignment: Alignment(0.9, 0.9),
            //     child: CircleAvatar(
            //       backgroundColor: greenCall,
            //       radius: 5,
            //     ),
            //   )
          ],
        ),
      ),
      title: Text(roomUser?.fullName ?? ''),
      subtitle: chat.chatMessages.isEmpty
          ? null
          : Text(
              chat.chatMessages.first.text ?? '',
              style: TextStyle(height: 2),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
    );
  }
}

class GroupChatListItem extends StatelessWidget {
  const GroupChatListItem({Key? key, required this.chat, required this.state})
      : super(key: key);
  final DataChatRoom chat;
  final ChatState state;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () async {
        state.selectedChat = chat;
        state.chats.clear();
        state.notify();
        DataChatMessage? message = await Go.pushSlideAnim(
            context,
            GroupChatBuilder(
              state: state,
            ));
        if (message != null) {
          state.selectedChat.chatMessages.insert(0, message);
          state.getChatsList(clean: true);
          state.notify();
        }
      },
      leading: AspectRatio(
        aspectRatio: 1,
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.black),
              borderRadius: BorderRadius.circular(100),
              image: chat.roomPhoto == null
                  ? null
                  : DecorationImage(
                      fit: BoxFit.fill, image: networkImage(chat.roomPhoto!))),
          // width: doubleWidth(10),
          child: chat.roomPhoto != null
              ? null
              : Center(
                  child: Text(
                  chat.name == null ? '' : chat.name![0],
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 17,
                      fontWeight: FontWeight.bold),
                )),
        ),
      ),
      title: Text(chat.name ?? ''),
      subtitle: Text('${chat.personalInformations.length} ${AppLocalizations.of(context)!.members}'),

      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [

        ],
      ),
    );
  }
}
