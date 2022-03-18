import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shooting_app/classes/functions.dart';
import 'package:shooting_app/classes/models.dart';
import 'package:shooting_app/classes/my_service.dart';

import '../../main.dart';

class ChatState extends ChangeNotifier {
  static DataChat defaultChat = DataChat(
      image: profileImageDefault,
      username: 'missssipi',
      name: 'Vernon Bradley',
      messages: [
        DataMessage(
          date: DateTime.now(),
          isMine: false,
          message: 'Nadal, Can you please let me know the price of that condo?',
          read: true,
        ),
        DataMessage(
          date: DateTime.now(),
          isMine: false,
          message: 'I am thinking to take it!!',
          read: true,
        ),
        DataMessage(
          date: DateTime.now(),
          isMine: true,
          message: 'Hey Melvin. I need to check. That post is quite old.',
          read: true,
        ),
      ],
      newMessages: 1,
      isOnline: true
  );

  List<DataChatRoom> listChats=[];
  List<DataChatMessage> chats=[];
  late DataChatRoom selectedChat;
  MyService service = getIt<MyService>();
  init()async{
    print('init()');
    getChatsList();

  }
  getChatsList()async{
    Map<String,dynamic> back = await ChatService.getMyPrivateChats(service,pageNumber: 1);
    listChats =back['chats'];
    print('listChats $listChats');
    notifyListeners();
  }
  getChats()async{
    chats = await ChatService.getPrivateChat(service,chatId:selectedChat.id );
    print('chats $chats');
    notifyListeners();
  }
  sendMessage(String message)async{
    await ChatService.sendMessage(service, chatRoomId: selectedChat.id, message: message);
    getChats();
  }

  notify() => notifyListeners();
}

class DataChat {
  final String image;
  final String name;
  final String username;
  List<DataMessage> messages = [];
  final int newMessages;
  bool isOnline = false;

  DataChat(
      {required this.username,
        required this.image,
      required this.name,
      required this.messages,
      required this.newMessages,
      required this.isOnline});

}

class DataMessage {
  final String message;
  final DateTime date;
  final bool isMine;
  bool read = false;

  DataMessage(
      {required this.message,
      required this.date,
      required this.isMine,
      required this.read});
}

class ChatStateProvider extends StatelessWidget {
  final Widget child;
  const ChatStateProvider({Key? key, required this.child,this.state}) : super(key: key);
  final ChatState? state;
  @override
  Widget build(BuildContext context) {
    return ListenableProvider<ChatState>(
      create: (context) => state??ChatState(),
      child: child,
    );
  }
}
