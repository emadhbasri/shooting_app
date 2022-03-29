
import 'package:flutter/material.dart';
import '../functions.dart';
import '../models.dart';

import 'my_service.dart';
class ChatService{

  static Future<List<DataChatMessage>> getPrivateChat(MyService service,{//todo
    required String chatId,
  }) async {
    debugPrint('getPrivateChat()');//3530f18b-a1ed-406e-0914-08da04b81c0f
    Map<String, dynamic> back = await service.httpGet('/api/v1/Message/getChatRoomById$chatId');
    if(back['status']==false){
      toast(back['error']);
      return [];
    }

    return convertDataList<DataChatMessage>(back['data'], 'results', 'DataChatMessage');
  }

  static Future<Map<String,dynamic>> getMyPrivateChats(MyService service,{//todo
    int pageNumber=1,
  }) async {
    debugPrint('getMyPrivateChats()');//3530f18b-a1ed-406e-0914-08da04b81c0f
    Map<String, dynamic> back = await service.httpGet('/api/v1/Message/getPrivateChatRoomByUserId?pageNumber=$pageNumber');
    debugPrint('back ${back}');
    if(back['status']==false){
      toast(back['error']);
      return {};
    }
    return {
      'total_pages':back['data']['total_pages'],
      'currentPage':back['data']['page'],
      'chats':convertDataList<DataChatRoom>(back['data'], 'results','DataChatRoom')
    };
  }

  static Future<DataChatRoom?> createPrivateChat(MyService service,{//todo
    required String friendId,
  }) async {
    debugPrint('createPrivateChat($friendId)');//3530f18b-a1ed-406e-0914-08da04b81c0f
    Map<String, dynamic> back = await service.httpPost('/api/v1/Message/createPrivateRoom?friendId=$friendId',{});
    debugPrint('backcreatePrivateChat ${back}');
    if(back['status']==false){
      toast(back['error']);
      return null;
    }
    return convertData(back['data'], 'data', DataType.clas,classType: 'DataChatRoom');
  }

  static Future<bool> sendMessage(MyService service,{
    required String chatRoomId,
    required String message,
  }) async {
    debugPrint('sendMessage()');//3530f18b-a1ed-406e-0914-08da04b81c0f
    Map<String, dynamic> back = await service.httpPost('/api/v1/Message/sendMessage?'
        'chatRoomId=$chatRoomId&timeStamp=${DateTime.now()}&message=$message',{});
    debugPrint('back ${back}');
    if(back['status']==false){
      toast(back['error']);
    }
    return back['status'];
  }
}
