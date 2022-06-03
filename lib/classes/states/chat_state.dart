import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shooting_app/classes/models.dart';
import 'package:shooting_app/classes/services/my_service.dart';

import '../../main.dart';
import '../services/chat_service.dart';

class ChatState extends ChangeNotifier {
  bool loadingListCaht = false;
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
    }
    ;
    Map<String, dynamic> back =
        await ChatService.getAllRoomsByUserId(service, pageNumber: pageNumber);
        // await ChatService.getMyPrivateChats(service, pageNumber: pageNumber);
    if (loadingListCaht) {
      loadingListCaht = false;
      notifyListeners();
    }
    listChats.addAll(back['chats']);
    chatHasNext = pageNumber < back['total_pages'];
    notifyListeners();
  }

  getChats({DataChatRoom? chatRoom}) async {
    if(chatRoom!=null)
      selectedChat=chatRoom;
    if(selectedChat.chatType==1){
      chats = await ChatService.getPrivateChat(service, chatId: selectedChat.id);
      notifyListeners();
    }else{
      // this.selectedChat= await ChatService.getPrivateChat(service, chatId: groupChatId);
      chats = await ChatService.getGroupChatMessages(service, chatId: selectedChat.id);
      notifyListeners();
    }
    // List<DataChatMessage> temps = await ChatService.getPrivateChat(service, chatId: selectedChat.id);
    // print('temps.length ${temps.length}');
    // print('chats.length ${chats.length}');
    // if(temps.length!=chats.length)
    //   for(int j=0;j<temps.length;j++){
    //     int index = chats.indexWhere((element) => element.id==temps[j].id);
    //
    //     if(index==-1){
    //       print('index $index');
    //       chats.add(temps[j]);
    //       notifyListeners();
    //       notifyListeners();
    //     }
    //   }
    notifyListeners();
  }


  sendMessage({String? message, XFile? file}) async {
    await ChatService.sendMessage(service,
        chatRoomId: selectedChat.id, message: message, file: file);
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
