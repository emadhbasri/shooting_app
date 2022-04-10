import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shooting_app/classes/models.dart';
import 'package:shooting_app/classes/services/my_service.dart';

import '../../main.dart';
import '../services/chat_service.dart';

class ChatState extends ChangeNotifier {
  bool loadingListCaht=false;
  List<DataChatRoom> listChats=[];
  List<DataChatMessage> chats = [];
  late DataChatRoom selectedChat;
  MyService service = getIt<MyService>();
  init() async {
    // if (listChats != null) return;
    print('init()');
    getChatsList(clean: true);
  }
bool chatHasNext=false;
  int pageNumber=1;
  getChatsList({bool clean=false}) async {
    loadingListCaht=true;notifyListeners();
    if(clean) {
      pageNumber=1;
      listChats.clear();
    };
    Map<String, dynamic> back =
        await ChatService.getMyPrivateChats(service, pageNumber: pageNumber);
    loadingListCaht=false;notifyListeners();
    listChats.addAll(back['chats']);
    chatHasNext=pageNumber<back['total_pages'];
    print('listChats $listChats');
    notifyListeners();
  }

  getChats() async {
    chats = await ChatService.getPrivateChat(service, chatId: selectedChat.id);
    print('chats $chats');
    notifyListeners();
  }

  sendMessage(String message) async {
    await ChatService.sendMessage(service,
        chatRoomId: selectedChat.id, message: message);
    getChats();
  }

  notify() => notifyListeners();
}

class ChatStateProvider extends StatelessWidget {
  final Widget child;
  const ChatStateProvider({Key? key, required this.child, this.state})
      : super(key: key);
  final ChatState? state;
  @override
  Widget build(BuildContext context) {
    return ListenableProvider<ChatState>(
      create: (context) => state ?? getIt<ChatState>(),
      child: child,
    );
  }
}
