import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:shooting_app/classes/services/my_service.dart';
import 'package:shooting_app/classes/states/chat_state.dart';
import 'package:shooting_app/pages/chat/chat.dart';
import '../../classes/functions.dart';
import '../../classes/models.dart';
import '../../classes/dataTypes.dart';
import '../../classes/services/chat_service.dart';
import '../../classes/states/main_state.dart';
import '../../main.dart';
import '../../pages/group_chat/group_chat.dart';

class ChooseChatBuilder extends StatelessWidget {
  const ChooseChatBuilder({Key? key, this.sharedFiles, this.sharedText})
      : super(key: key);
  final List<SharedMediaFile>? sharedFiles;
  final String? sharedText;
  @override
  Widget build(BuildContext context) {
    return ChatStateProvider(
      child: ChooseChat(sharedText: sharedText,sharedFiles: sharedFiles),
    );
  }
}

class ChooseChat extends StatefulWidget {
  final List<SharedMediaFile>? sharedFiles;
  final String? sharedText;
  const ChooseChat({Key? key, this.sharedFiles, this.sharedText})
      : super(key: key);
  @override
  State<ChooseChat> createState() => _ChooseChatState();
}

class _ChooseChatState extends State<ChooseChat> {
  // late ChatState state;
  late ScrollController _listController;
  bool chatHasNext = false;
  int pageNumber = 1;
  List<DataChatRoom> listChats = [];
  bool loadingListCaht = false;
  init() {
    getChatsList(clean: true);
  }

  getChatsList({bool clean = false}) async {
    if (clean) {
      pageNumber = 1;
      listChats.clear();
      setState(() {
        loadingListCaht = true;
      });
    }

    Map<String, dynamic> back = await ChatService.getAllRoomsByUserId(
        getIt<MyService>(),
        pageNumber: pageNumber);
    // await ChatService.getMyPrivateChats(service, pageNumber: pageNumber);
    if (loadingListCaht) {
      setState(() {
        loadingListCaht = false;
      });
    }

    setState(() {
      listChats.addAll(back['chats']);
      chatHasNext = pageNumber < back['total_pages'];
    });
  }

  @override
  void initState() {
    init();
    super.initState();
    _listController = ScrollController()
      ..addListener(() {
        if (listChats.isNotEmpty &&
            _listController.position.atEdge &&
            _listController.offset != 0.0) {
          debugPrint("notifHasNext ${chatHasNext}");
          if (chatHasNext) {
            pageNumber++;
            getChatsList();
          }
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    if (loadingListCaht) return circle();
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.select_a_chat.toUpperCase()),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await getChatsList(clean: true);
        },
        child: listChats.isEmpty
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
            ...listChats
                .map((e) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (e.chatType == 1)
                  ChatListItem(
                    sharedText: widget.sharedText,
                    sharedFiles: widget.sharedFiles,
                    chat: e,
                  )
                else
                  GroupChatListItem(
                    sharedText: widget.sharedText,
                    sharedFiles: widget.sharedFiles,
                    chat: e,
                  ),
                if (e != listChats.last)
                  Divider(color: grayCallDark)
              ],
            ))
                .toList(),
            if (chatHasNext)
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
    );
  }
}

class ChatListItem extends StatelessWidget {
  const ChatListItem(
      {Key? key,
      required this.chat,
      required this.sharedFiles,
      required this.sharedText})
      : super(key: key);
  final DataChatRoom chat;
  final List<SharedMediaFile>? sharedFiles;
  final String? sharedText;
  @override
  Widget build(BuildContext context) {
    int index = chat.personalInformations.indexWhere((element) =>
        element == null ? false : element.id != getIt<MainState>().userId);
    DataPersonalInformation? roomUser = chat.personalInformations[index];
    ChatState state = getIt<ChatState>();
    return ListTile(
      onTap: () async {
        if (sharedFiles != null && sharedFiles!.isNotEmpty) {
          for (int j = 0; j < sharedFiles!.length; j++) {
            XFile file = XFile(sharedFiles![j].path, name: sharedFiles![j].path);
            ChatService.sendMessage(getIt<MyService>(),
                chatRoomId: chat.id, file: file);
          }
        }
        state.selectedChat=chat;
        Go.replaceSlideAnim(
            context,
            ChatBuilder(
              sharedText: sharedText,
              state: state,
            ));
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
            if (roomUser != null && roomUser.isOnline)
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
      title: Text(roomUser?.fullName ?? ''),
      subtitle: chat.chatMessages.isEmpty
          ? null
          : Text(
              chat.chatMessages.first.text ?? '',
              style: TextStyle(height: 2),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [

        ],
      ),
    );
  }
}

class GroupChatListItem extends StatelessWidget {
  const GroupChatListItem(
      {Key? key,
      required this.chat,
      required this.sharedFiles,
      required this.sharedText})
      : super(key: key);
  final DataChatRoom chat;
  final List<SharedMediaFile>? sharedFiles;
  final String? sharedText;
  @override
  Widget build(BuildContext context) {
    ChatState state = getIt<ChatState>();

    return ListTile(
      onTap: () async {
        if (sharedFiles != null && sharedFiles!.isNotEmpty) {
          for (int j = 0; j < sharedFiles!.length; j++) {
            XFile file = XFile(sharedFiles![j].path, name: sharedFiles![j].path);
            ChatService.sendMessage(getIt<MyService>(),
                chatRoomId: chat.id, file: file);
          }

        }
        state.selectedChat=chat;
        Go.replaceSlideAnim(
            context,
            GroupChatBuilder(
              state: state,
              sharedText: sharedText,
            ));
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
