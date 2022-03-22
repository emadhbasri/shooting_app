
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shooting_app/classes/states/main_state.dart';
import 'package:shooting_app/main.dart';

import 'models.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';

class MyService{

  clear() {
    hasAccess = false;
    _access = null;
    _refresh = null;
  }
  bool hasAccess = false;
  Future<bool> getToken() async {

    debugPrint('getToken()');
    // await deviceData();
    _refresh = await getString('refresh');
    _access = await getString('access');
    debugPrint('_refresh $_refresh');
    debugPrint('_access $_access');
    if(_access==null) return false;
    MainState state = getIt<MainState>();
    state.init();
    return true;
    // if (_refresh != null) await getAccess();
  }

  Future<void> setToken({required String refresh, required String access}) async {
    await setString('refresh', refresh);
    await setString('access', access);
    _refresh = refresh;
    _access = access;
    hasAccess = true;
  }

  getAccess() async {
    // Map<String, dynamic> back = await httpPost('/users/api/jwt/refresh/', {'refresh': _refresh});
    // debugPrint('getAccess $back');
    // _access = back['data']['access'];
    // debugPrint('access $_access');
    // hasAccess = true;
  }

  final String _server = 'http://104.131.102.60';
  String? _access = "";
  String? _refresh = "";

  Future<Map<String, dynamic>> httpPost(String url, Map<String, dynamic> body, {bool jsonType = false}) async {
    Map<String, String> headers = {
      // 'uuid': await deviceData()
    };
    if (_access != null && _access != '') {
      headers['Authorization'] = 'Bearer $_access';
    }


    debugPrint('Post ${_server + url} $headers ');

    dynamic out = body;
    if (jsonType) {
        headers['Content-Type'] = 'application/json';
      // debugPrint("myOut $out");
      out = jsonEncode(body);
    }
    debugPrint('post out $out');

    http.Response utf = await http.post(Uri.parse(_server + url),
        body: out, headers: headers).catchError((e) {
      debugPrint('post catchError $e');
      FutureOr<http.Response> out = http.Response('nonet', 403);
      return out;
    });
    debugPrint('utf ${utf.body}');
    if (utf.statusCode == 403 && utf.body == 'nonet') {
      return {'status': false, "data": false};
    }

    var json = utf8.decode(utf.bodyBytes);
    var jsonn;
    try{
      jsonn = jsonDecode(json);
    }catch(e){}
    // debugPrint('json $json');
    // debugPrint('jsonn $jsonn');
    if (utf.statusCode == 201 || utf.statusCode == 200 || utf.statusCode == 204) {
      return {'status': true, 'data': jsonn};
    } else {
      return {'status': false, 'error': jsonn['message']};
    }
  }

  Future<Map<String, dynamic>> httpPostMulti(String url, Map<String, dynamic> body, {bool jsonType = false}) async {
    Map<String, String> headers = {
      // 'uuid': await deviceData()
      'Content-Type':'multipart/form-data'
    };
    if (_access != null && _access != '') {
      headers['Authorization'] = 'Bearer $_access';
    }


    debugPrint('Post ${_server + url} $headers ');

    dynamic out = body;
    if (jsonType) {
      // debugPrint("myOut $out");
      out = jsonEncode(body);
    }
    debugPrint('post out $out');

    http.Response utf = await http.post(Uri.parse(_server + url),
        body: out, headers: headers).catchError((e) {
      debugPrint('post catchError $e');
      FutureOr<http.Response> out = http.Response('nonet', 403);
      return out;
    });
    debugPrint('utf ${utf.body}');
    if (utf.statusCode == 403 && utf.body == 'nonet') {
      return {'status': false, "data": false};
    }

    var json = utf8.decode(utf.bodyBytes);
    var jsonn = jsonDecode(json);
    // debugPrint('json $json');
    // debugPrint('jsonn $jsonn');
    if (utf.statusCode == 201 || utf.statusCode == 200 || utf.statusCode == 204) {
      return {'status': true, 'data': jsonn};
    } else {
      return {'status': false, 'error': jsonn['message']};
    }
  }


  Future<Map<String, dynamic>> httpPut(String url, Map<String, dynamic> body) async {
    debugPrint('Put ${_server + url}');
    Map<String, String> headers = {
      // 'uuid': await deviceData()
    };
    if (_access != null && _access != '') {
      headers['Authorization'] = 'Bearer $_access';
    }

    http.Response utf = await http.put(Uri.parse(_server + url), body: body, headers: headers).catchError((e) {
      FutureOr<http.Response> out = http.Response('nonet', 403);
      return out;
    });
    if (utf.statusCode == 403 && utf.body == 'nonet') {
      return {'status': false, "data": false};
    }
    String json = utf8.decode(utf.bodyBytes);
    dynamic jsonn = jsonDecode(json);
    debugPrint('jsonn $jsonn');

    if (utf.statusCode == 201 || utf.statusCode == 200 || utf.statusCode == 204) {
      return {'status': true, 'data': jsonn};
    } else {
      return {'status': false, 'error': jsonn['message']};
    }
  }

  Future<Map<String, dynamic>> httpGet(String url) async {
    Map<String, String> headers = {
      // 'uuid': await deviceData(),
      // "Accept": "application/json",
      // "Access-Control_Allow_Origin": "*"
    };
    if (_access != null && _access != '') {
      headers['Authorization'] = 'Bearer $_access';
    }
    debugPrint('Get ${_server + url} $headers');
    http.Response utf = await http.get(Uri.parse(_server + url), headers: headers).catchError((e) {
      FutureOr<http.Response> out = http.Response('nonet', 403);
      return out;
    });
    if (utf.statusCode == 403 && utf.body == 'nonet') {
      return {'status': false, "data": false};
    }
    debugPrint('body $utf');

    try {
      var json = utf8.decode(utf.bodyBytes);
      var jsonn = jsonDecode(json);
      // debugPrint('jsonnjsonn ${jsonn.runtimeType}');
      if (utf.statusCode == 201 || utf.statusCode == 200 || utf.statusCode == 204) {
        return {'status': true, 'data': jsonn};
      } else {
        return {'status': false, 'error': jsonn['message']};
      }
    } catch (e) {
      debugPrint('cathc e $e');
      return {'status': false, "data": false};
    }
    // finally{
    //   debugPrint('finaly');
    //
    // }
  }

  Future<bool> httpDelete(String url) async {
    debugPrint('Delete ${_server + url}');
    Map<String, String> headers = {
      // 'uuid': await deviceData()
    };
    if (_access != null && _access != '') {
      headers['Authorization'] = 'Bearer $_access';
    }
    http.Response utf = await http.delete(Uri.parse(_server + url), headers: headers).catchError((e) {
      FutureOr<http.Response> out = http.Response('nonet', 403);
      return out;
    });
    if (utf.statusCode == 403 && utf.body == 'nonet') {
      return false;
    }
    return utf.statusCode == 201 || utf.statusCode == 200 || utf.statusCode == 204 ? true : false;
  }

  Future<Map<String, dynamic>> httpPostMulti1(String url, FormData formData,
      {bool jsonType = false}) async {
    Dio dio = Dio();
    // var formData = FormData.fromMap({
      // 'name': 'wendux',
      // 'age': 25,
      // 'file': await MultipartFile.fromFile('./text.txt', filename: 'upload.txt'),
      // 'files': [
      //   await MultipartFile.fromFile('./text1.txt', filename: 'text1.txt'),
      //   await MultipartFile.fromFile('./text2.txt', filename: 'text2.txt'),
      // ]
    // });
    Response utf = await dio.post(_server + url,options: Options(
      headers: {
        // 'Content-Type':'multipart/form-data',
        'Authorization':'Bearer $_access'
      }
    ), data: formData).catchError((e) {
      debugPrint('post catchError $e');
      FutureOr<Response> out = Response(statusCode: 403,data: 'nonet',requestOptions: RequestOptions(path: ''));
      return out;
    });
print('formData ${formData.fields}');


    debugPrint('Post ${_server + url} ${{
      // 'Content-Type':'multipart/form-data',
      'Authorization':'Bearer $_access'
    }} ');



    debugPrint('utf ${utf.data}');
    if (utf.statusCode == 403 && utf.data == 'nonet') {
      return {'status': false, "data": false};
    }

    // var json = utf8.decode(utf.data.toString().codeUnits);
    // debugPrint('json $json');
    // var jsonn = jsonDecode(utf.data);
    // debugPrint('jsonn $jsonn');

    // debugPrint('json $json');
    // debugPrint('jsonn $jsonn');
    if (utf.statusCode == 201 || utf.statusCode == 200 || utf.statusCode == 204) {
      return {'status': true, 'data': utf.data};
    } else {
      return {'status': false, 'error': utf.data['message']};
    }
  }



///---------------------------------users

///---------------------------------users
///---------------------------------Authentication

///--------------------------------------Authentication


}
class ChatService{
  ///private

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
///private
///room

///room
}
class AuthenticationService{
  static logOut(){
    removeShare('refresh');
    removeShare('access');
    MainState state = getIt<MainState>();
    state.userId='';
    state.userName='';
    removeShare('userid');
    removeShare('username');
  }
  static Future<bool> register(MyService service,{
    required String fullName,
    required String userName,
    required String phoneNumber,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    debugPrint('register()');
    Map<String, dynamic> back = await service.httpPost('/api/v1/Authentication/register', {
      "fullName": fullName,
      "userName": userName,
      "phoneNumber": phoneNumber,
      "notificationToken": "string",
      "is2FA": false,
      "isOnline": true,
      "email": email,
      "password": password,
      "confirmPassword": confirmPassword
    });
    return back['status'];
  }

  static Future<bool> login(MyService service,{
    required String username,
    required String password,
  }) async {
    debugPrint('login()');
    Map<String, dynamic> back = await service.httpPost('/api/v1/Authentication/login', {
      "user": username,
      "password": password,
      "notificationToken": "string",
      "rememberMe": true
    },jsonType: true);
    debugPrint('back ${back}');
    service.setToken(refresh: back['data']['data']['refreshToken'], access: back['data']['data']['accessToken']);
    MainState state = getIt<MainState>();
    DataPersonalInformation pif = DataPersonalInformation.fromJson(back['data']['data']);
    state.userId=pif.id;
    state.userName=pif.userName!;
    setString('userid', pif.id);
    setString('username', pif.userName!);

    return back['status'];
  }

  static Future<bool> validateOtp(MyService service,{
    required String user,
    required String oTP,
    required String password,
  }) async {
    debugPrint('validateOtp()');
    Map<String, dynamic> back = await service.httpPost('/api/v1/Authentication/validateOtp', {
      "user": user,
      "password": password,
      "oTP": oTP,
      "notificationToken": "string",
      "rememberMe": true
    });
    return back['status'];
  }

  static Future<bool> logout(MyService service,) async {
    debugPrint('logout()');
    Map<String, dynamic> back = await service.httpPost('/api/v1/Authentication/logout',{});
    return back['status'];
  }
}
class UsersService{
  static Future<DataPersonalInformation?> myProfile(MyService service) async {
    debugPrint('shotsComment()');
    // print({
    //   "UserId": userId,
    //   "PostId": postId,
    //   "Comment": comment,
    //   // "MediaType": ""
    // });
    Map<String, dynamic> back = await service.httpGet('/api/v1/Administration/users/getUserById');
    debugPrint('back ${back}');
    if(back['status'])
      return DataPersonalInformation.fromJson(back['data']['data']);
    else return null;
  }
  static Future<DataPersonalInformation?> getUser(MyService service,String username) async {
    debugPrint('shotsComment()');
    // print({
    //   "UserId": userId,
    //   "PostId": postId,
    //   "Comment": comment,
    //   // "MediaType": ""
    // });
    Map<String, dynamic> back = await service.httpGet(
        '/api/v1/Administration/getByUsername?userName=$username&myID=${getIt<MainState>().userId}');
    debugPrint('back ${back}');
    if(back['status'])
      return DataPersonalInformation.fromJson(back['data']['data']);
    else return null;
  }
}

class ShotsService{
  static Future<DataPost?> createShot(MyService service,{
    required List<XFile> images,
    required String details,
    bool isFriend=false,
    bool isPublic=true,
  }) async {
    debugPrint('createShot()');
    Map<String,dynamic> map = {
      'Details':details,
      'IsFriend':isFriend,
      'IsPublic':isPublic,
      // 'MatchId':'1234',
      'createdAt':DateTime.now().toString()
    };
    if(images.isNotEmpty) {
      List<MultipartFile> temp =[];
      for(int j=0;j<images.length;j++){
        MultipartFile file = await MultipartFile.fromFile(images[j].path, filename: images[j].name);
        temp.add(file);
      }
      map['MediaType'] = temp;
    }
    print('map $map');
    Map<String, dynamic> back = await service.httpPostMulti1('/api/v1/Shots/add',
    FormData.fromMap(map));
    debugPrint('back ${back}');

    // List backList = convertData(back['data'], 'results', DataType.list,classType: 'DataPost');
    // List<DataPost> temp = [];
    // for(int j=0;j<backList.length;j++){
    //   temp.add(backList[j]);
    // }
    //
    // return  temp;
    return convertData(back['data'], 'data', DataType.clas,classType: 'DataPost');

    // setToken(refresh: back['data']['refreshToken'], access: back['data']['accessToken']);
    // MainState state = getIt<MainState>();
    // state.personalInformation= DataPersonalInformation.fromJson(back['data']);
    // return back['status'];
  }

  static Future<List<DataPost>> shotsAll(MyService service,{
    int pageNumber=1
  }) async {
    debugPrint('shotsAll()');
    Map<String, dynamic> back = await service.httpGet('/api/v1/Shots/all?pageNumber=$pageNumber');
    debugPrint('back ${back}');
    return convertDataList<DataPost>(back['data'], 'results', 'DataPost');
  }
  static Future<DataPost> getShotById(MyService service,String shotId) async {
    debugPrint('getShotById($shotId)');
    Map<String, dynamic> back = await service.httpGet('/api/v1/Shots/PostById$shotId');
    debugPrint('back ${back}');

      return convertData(back['data'], 'data', DataType.clas,classType: 'DataPost');
  }
  static Future<List<DataPost>> getMatchUps(MyService service,{
    required int teamHomeId,
    required int teamAwayId,
    required String date,
  }) async {
    debugPrint('getMatchUps(${{
      'team1_key':'$teamHomeId',
      'team2_key':'$teamAwayId',
      'date':date,
      'userId':getIt<MainState>().userId,
    }})');
    // return [];

    Map<String, dynamic> back = await service.httpGet('/api/v1/Shots/getmatchups?team1_key=$teamHomeId'
        '&team2_key=$teamAwayId&date=$date'
        // '&userId=${getIt<MainState>().userId}'
    );
    debugPrint('back111 ${back}');
    return convertDataList<DataPost>(back['data'], 'data', 'DataPost');
  }

  // Future<DataPost> shotsById({required String id})async {

  // }

  static Future<DataPostComment?> shotsComment(MyService service,{
    required String postId,
    required String comment,
  }) async {
    debugPrint('shotsComment()');
    MainState mainS = getIt<MainState>();
    Map<String, dynamic> back = await service.httpPost('/api/v1/Shots/comment', {
      "UserId": mainS.userId,
      "PostId": postId,
      "Comment": comment,
      'createdAt':DateTime.now().toString()
      // "MediaType": ""
    },jsonType: false);
    debugPrint('back ${back}');
    if(back['status'])
      return DataPostComment.fromJson(back['data']['data']);
    else return null;
  }

  static Future<DataCommentReply?> commentReply(MyService service,{
    required String commentId,
    required String reply,
  }) async {
    debugPrint('shotsComment()');
    Map<String, dynamic> back = await service.httpPost('/api/v1/Shots/comment/reply', {
      "UserId": getIt<MainState>().userId,
      "PostCommentId": commentId,
      "ReplyDetail": reply,
      'createdAt':DateTime.now().toString()
      // "MediaType": ""
    },jsonType: false);
    debugPrint('back ${back}');
    if(back['status'])
      return DataCommentReply.fromJson(back['data']['data']);
    else return null;
  }

  static Future<bool> shotLike(MyService service,{
    required String postId,}) async {
    debugPrint('shotLike()');
    Map<String, dynamic> back = await service.httpPost(
        '/api/v1/Shots/like$postId?userId=${getIt<MainState>().userId}',{});
    // debugPrint('back $back');
    return back['status'];
  }
  static Future<bool> commentLike(MyService service,{
    required String postCommentId,}) async {
    debugPrint('commentLike()');
    Map<String, dynamic> back = await service.httpPost(
        '/api/v1/Shots/comment/like$postCommentId?userId=${getIt<MainState>().userId}',{},jsonType: false);
    debugPrint('back $back');
    return back['status'];
  }
  static Future<bool> replyLike(MyService service,{
    required String commentReplyId,}) async {
    // debugPrint('replyLike(userId:$userId,commentReplyId:$commentReplyId)');
    // print('url: /api/v1/Shots/comment/likeReply$commentReplyId?userId=$userId');
    Map<String, dynamic> back = await service.httpPost(
        '/api/v1/Shots/comment/likeReply$commentReplyId?userId=${getIt<MainState>().userId}',{},jsonType: false);
    debugPrint('back $back');
    return back['status'];
  }
}


void removeShare(String key) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  pref.remove(key);
}

void setStringList(String key, String value) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  List<String> temp = await getStringList(key);
  temp.add(value);
  pref.setStringList(key, temp);
}

Future<List<String>> getStringList(String key) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  if (pref.containsKey(key))
    return pref.getStringList(key)!;
  else
    return [];
}

Future<void> setString(String key, String value) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  pref.setString(key, value);
}

Future<String?> getString(String key) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  if (pref.containsKey(key))
    return pref.getString(key)!;
  else
    return null;
}

void setInt(String key, int value) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  pref.setInt(key, value);
}

Future<int?> getInt(String key) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  if (pref.containsKey(key))
    return pref.getInt(key)!;
  else
    return null;
}