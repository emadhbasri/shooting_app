import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shooting_app/classes/models.dart';
import 'package:shooting_app/classes/services/my_service.dart';

import '../../main.dart';
import '../services/chat_service.dart';

class GroupChatState extends ChangeNotifier {
  bool loadingListCaht = true;
  List<DataChatRoom> listChats = [];
  List<DataChatMessage> chats = [];
  late DataChatRoom selectedChat;
  MyService service = getIt<MyService>();
  init() async {
    // if (listChats != null) return;
    print('init()');
    getChatsList(clean: true);
  }

  bool chatHasNext = false;
  int pageNumber = 1;
  getChatsList({bool clean = false}) async {
    if (clean) {
      pageNumber = 1;
      listChats.clear();
      loadingListCaht = true;
      notifyListeners();
    };
    Map<String, dynamic> back =
        await ChatService.getMyGrouphats(service, pageNumber: pageNumber);
    if (loadingListCaht) {
      loadingListCaht = false;
      notifyListeners();
    }
    listChats.addAll(back['chats']);
    chatHasNext = pageNumber < back['total_pages'];
    notifyListeners();
  }

  getChats() async {
    chats = await ChatService.getGroupChatMessages(service, chatId: selectedChat.id);

    notifyListeners();
  }

  sendMessage({String? message, XFile? file}) async {
    await ChatService.sendMessage(service,
        chatRoomId: selectedChat.id, message: message, file: file);
    getChats();
  }

  notify() => notifyListeners();
}

class GroupChatStateProvider extends StatelessWidget {
  final Widget child;
  const GroupChatStateProvider({Key? key, required this.child, this.state})
      : super(key: key);
  final GroupChatState? state;
  @override
  Widget build(BuildContext context) {
    return ListenableProvider<GroupChatState>(
      create: (context) => state ?? getIt<GroupChatState>(),
      child: child,
    );
  }
}
