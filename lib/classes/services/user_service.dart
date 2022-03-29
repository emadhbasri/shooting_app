import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shooting_app/classes/functions.dart';
import 'package:shooting_app/classes/states/main_state.dart';
import 'package:shooting_app/main.dart';
import '../models.dart';
import 'my_service.dart';

class UsersService {
  static Future<DataPersonalInformation?> myProfile(MyService service) async {//todo
    debugPrint('myProfile()');
    Map<String, dynamic> back =
        await service.httpGet('/api/v1/Administration/users/getUserById');
    debugPrint('myProfileback ${back}');
    if (back['status'])
      return DataPersonalInformation.fromJson(back['data']['data']);
    else{
      toast(back['error']);
      return null;
    }
  }

  static Future<DataPersonalInformation?> getUser(//todo
      MyService service, String username) async {
    username = username.replaceAll('@', '');
    debugPrint('getUser($username)');
    Map<String, dynamic> back = await service.httpGet(
        '/api/v1/Administration/getByUsername?userName=$username&myID=${getIt<MainState>().userId}');
    debugPrint('getUserback ${back}');
    if (back['status'])
      return DataPersonalInformation.fromJson(back['data']['data']);
    else {
      toast(back['error']);
      return null;
    }
  }

  static Future<bool> followUser(MyService service, String id) async {
    debugPrint('followUser($id)');
    Map<String, dynamic> back = await service.httpPost(
        '/api/v1/Administration/users/follower/add',
        {'userId': id, 'followerId': getIt<MainState>().userId},
        jsonType: true);
    debugPrint('followUserback ${back}');
    if(back['status']==false){
      toast(back['error']);
    }
    return back['status'];
  }

  static Future<bool> unFollowUser(MyService service, String id) async {
    debugPrint('unFollowUser($id)');
    Map<String, dynamic> back = await service.httpPost(
        '/api/v1/Administration/users/unfollow?'
        'userID=${getIt<MainState>().userId}&FollowingID=$id',
        {});
    debugPrint('unFollowUserback ${back}');
    if(back['status']==false){
      toast(back['error']);
    }
    return back['status'];
  }

  static Future<bool> changePhoto(MyService service, XFile file) async {
    debugPrint('changePhoto(${file.path})');
    Map<String, dynamic> map = {
      'id': getIt<MainState>().userId,
    };
    map['profilePhoto'] =
        await MultipartFile.fromFile(file.path, filename: file.name);
    Map<String, dynamic> back =
        await service.httpPostMulti('/api/v1/Shots/add', FormData.fromMap(map));
    if(back['status']==false){
      toast(back['error']);
    }
    return back['status'];
  }

  static Future<bool> changeTeam(MyService service, String team_key) async {
    debugPrint('changeTeam($team_key)');
    Map<String, dynamic> back =
        await service.httpGet('/api/v1/Team/addTeamToUser?'
            'userId=${getIt<MainState>().userId}&team_key=$team_key');
    debugPrint('changeTeamBack ${back}');
    if(back['status']==false){
      toast(back['error']);
    }
    return back['status'];
  }

  static Future<bool> changeName(MyService service, String name) async {
    debugPrint('changeName($name)');
    Map<String, dynamic> back = await service.httpPut(
        '/api/v1/Administration/editUser', {'fullName': name},
        jsonType: true);
    debugPrint('changeNameBack ${back}');
    if(back['status']==false){
      toast(back['error']);
    }
    return back['status'];
  }
//{
//   "email": "RD7m3G@HUwjf.pkte",
//   "userName": "tempor",
//   "fullName": "anim mollit amet"
// }
}
