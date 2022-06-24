
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../functions.dart';
import '../models.dart';

import 'my_service.dart';
class ChatService{

  ///-----------------------------------------------group
  static Future<List<DataChatMessage>> getGroupChatMessages(MyService service,{//todo
    required String chatId,
  }) async {
    debugPrint('getGroupChatMessages()');//3530f18b-a1ed-406e-0914-08da04b81c0f
    Map<String, dynamic> back = await service.httpGet('/api/v1/Message/getGroupChatRoomMessagesById$chatId');
    // debugPrint('getGroupChatMessages ${back}');
    if(back['status']==false){
      toast(back['error']);
      return [];
    }

    return convertDataList<DataChatMessage>(back['data'], 'data', 'DataChatMessage');
  }

  static Future<Map<String,dynamic>> getMyGrouphats(MyService service,{//todo
    int pageNumber=1,
  }) async {
    debugPrint('getMyGrouphats()');//3530f18b-a1ed-406e-0914-08da04b81c0f
    Map<String, dynamic> back = await service.httpGet('/api/v1/Message/getChatRoomByUserId?pageNumber=$pageNumber');
    debugPrint('back ${back}');
    if(back['status']==false){
      toast(back['error']);
      return {};
    }
    return {
      'total_pages':back['data']['total_pages'],
      'chats':convertDataList<DataChatRoom>(back['data'], 'results','DataChatRoom')
    };
  }

  static Future<DataChatRoom?> joinGroupChat(MyService service,{//todo
    required String chatRoomId,
    required String userId,
  }) async {
    debugPrint('joinGroupChat($userId,$chatRoomId)');
    Map<String, dynamic> back = await service.httpPost('/api/v1/Message/joinRoom?'
        'chatRoomId=$chatRoomId&userId=$userId',{});
    debugPrint('back joinGroupChat ${back}');
    if(back['status']==false){
      toast(back['error']);
      return null;
    }
    return convertData<DataChatRoom>(back['data'], 'data', DataType.clas,classType: 'DataChatRoom');
  }
  static Future<String?> createGroupChat(MyService service,{//todo
    required String name,
    XFile? image,
  }) async {
    Map<String, dynamic> map = {
      'name':name,
    };
    if(image!=null){
      MultipartFile temp = await MultipartFile.fromFile(image.path,
          filename: image.name);
      map['profilePhoto']=temp;
    }
    debugPrint('createGroupChat($name)');//3530f18b-a1ed-406e-0914-08da04b81c0f
    // Map<String, dynamic> back = await service.httpPost('/api/v1/Message/createRoom?name=$name',{});
    Map<String, dynamic> back = await service.httpPostMulti('/api/v1/Message/createRoom',FormData.fromMap(map),jsonType: true);

    debugPrint('back createGroupChat ${back}');
    if(back['status']==false){
      toast(back['error']);
      return null;
    }
    DataChatRoom out = convertData(back['data'], 'data', DataType.clas,classType: 'DataChatRoom');
    return out.id;
  }

  ///------------------------------------------------chat
  static Future<List<DataChatMessage>> getPrivateChat(MyService service,{//todo
    required String chatId,
  }) async {
    debugPrint('getPrivateChat()');//3530f18b-a1ed-406e-0914-08da04b81c0f
    Map<String, dynamic> back = await service.httpGet('/api/v1/Message/getChatRoomById$chatId');
    if(back['status']==false){
      toast(back['error']);
      return [];
    }

    return convertDataList<DataChatMessage>(back['data'], 'data', 'DataChatMessage');
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


  // static Future<Map<String,dynamic>> getMyPrivateChats(MyService service,{//todo
  //   int pageNumber=1,
  // }) async {
  //   debugPrint('getMyPrivateChats()');//3530f18b-a1ed-406e-0914-08da04b81c0f
  //   Map<String, dynamic> back = await service.httpGet('/api/v1/Message/getPrivateChatRoomByUserId?pageNumber=$pageNumber');
  //   debugPrint('back ${back}');
  //   if(back['status']==false){
  //     toast(back['error']);
  //     return {};
  //   }
  //   return {
  //     'total_pages':back['data']['total_pages'],
  //     'chats':convertDataList<DataChatRoom>(back['data'], 'results','DataChatRoom')
  //   };
  // }
  ///----------------------------------------------all
  static Future<bool> deleteMessage(
      MyService service, {
        required String messageId,
      }) async {
    print('deleteMessage($messageId)');
    bool back =
    await service.httpDelete('/api/v1/Message/DeleteChatMessageById$messageId');
    debugPrint('deleteMessage back $back');
    return back;
  }

  static Future<Map<String,dynamic>> getAllRoomsByUserId(MyService service,{//todo
    int pageNumber=1,
  }) async {
    debugPrint('GetAllRoomsByUserId()');//3530f18b-a1ed-406e-0914-08da04b81c0f
    Map<String, dynamic> back = await service.httpGet('/api/v1/Message/GetAllRoomsByUserId?pageNumber=$pageNumber');
    debugPrint('back ${back}');
    if(back['status']==false){
      toast(back['error']);
      return {};
    }
    return {
      'total_pages':back['data']['total_pages'],
      'chats':convertDataList<DataChatRoom>(back['data'], 'results','DataChatRoom')
    };
  }

  static Future<bool> sendMessage(MyService service,{
    required String chatRoomId,
    String? message,
    XFile? file
  }) async {
    Map<String, dynamic> map = {
      'chatRoomId':chatRoomId,
      'timeStamp':DateTime.now().toString(),
    };
    if(message!=null){
      map['message']=message;
    }else if(file!=null){
      MultipartFile temp = await MultipartFile.fromFile(file.path,
          filename: file.name);
      map['mediaType']=temp;
    }
    debugPrint('sendMessage($chatRoomId,$message)');//3530f18b-a1ed-406e-0914-08da04b81c0f
    Map<String, dynamic> back = await service.httpPostMulti('/api/v1/Message/sendMessage',FormData.fromMap(map),jsonType: true);
    debugPrint('back sendMessage ${back}');
    if(back['status']==false){
      toast(back['error']);
    }
    return back['status'];
  }
  static Future<List<DataPersonalInformation>> search(MyService service,
      {required String search,int pageNumber=1}) async {//todo
    debugPrint('search()');
    Map<String, dynamic> back = await service.httpGet(
        '/api/v1/Message/SearchMessageUsers?'
            'PartialOrFullUserName=$search&pageNumber=$pageNumber');
    debugPrint('back search ${back}');
    if(back['status']==false){
      // toast(back['error']);
      return [];
    }
    return convertDataList<DataPersonalInformation>(back['data'], 'results', 'DataPersonalInformation');
  }







}
