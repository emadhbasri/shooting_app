
import 'package:flutter/material.dart';
import '../models.dart';

import 'my_service.dart';
class ChatService{

  static Future<List<DataChatMessage>> getPrivateChat(MyService service,{
    required String chatId,
  }) async {
    debugPrint('getPrivateChat()');//3530f18b-a1ed-406e-0914-08da04b81c0f
    Map<String, dynamic> back = await service.httpGet('/api/v1/Message/getChatRoomById$chatId');
    debugPrint('back ${back}');
    debugPrint('data ${back['data']}');
    debugPrint('datadata ${back['data']['data']}');

    return convertDataList<DataChatMessage>(back['data'], 'results', 'DataChatMessage');
  }
  static Future<Map<String,dynamic>> getMyPrivateChats(MyService service,{
    int pageNumber=1,
  }) async {
    debugPrint('getMyPrivateChats()');//3530f18b-a1ed-406e-0914-08da04b81c0f
    Map<String, dynamic> back = await service.httpGet('/api/v1/Message/getPrivateChatRoomByUserId?pageNumber=$pageNumber');
    debugPrint('back ${back}');

    return {
      'total_pages':back['data']['total_pages'],
      'currentPage':back['data']['page'],
      'chats':convertDataList<DataChatRoom>(back['data'], 'results','DataChatRoom')
    };
  }
  static Future<String> createPrivateChat(MyService service,{
    required String friendId,
  }) async {
    debugPrint('createPrivateChat()');//3530f18b-a1ed-406e-0914-08da04b81c0f
    Map<String, dynamic> back = await service.httpPost('/api/v1/Message/createPrivateRoom?friendId=$friendId',{});
    debugPrint('back ${back}');

    return back['data'];//todo
  }
  static Future<bool> sendMessage(MyService service,{
    required String chatRoomId,
    required String message,
  }) async {
    debugPrint('sendMessage()');//3530f18b-a1ed-406e-0914-08da04b81c0f
    Map<String, dynamic> back = await service.httpPost('/api/v1/Message/sendMessage?'
        'chatRoomId=$chatRoomId&timeStamp=${DateTime.now()}&message=$message',{});
    debugPrint('back ${back}');

    return back['status'];
  }
}
