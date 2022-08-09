import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shooting_app/classes/functions.dart';
import 'package:shooting_app/classes/live_match_model.dart';
import 'package:shooting_app/classes/states/main_state.dart';
import 'package:shooting_app/main.dart';
import '../models.dart';
import 'my_service.dart';

class UsersService {
  static Future<DataPersonalInformation?> myProfile(MyService service) async {
    //todo
    debugPrint('myProfile()');
    Map<String, dynamic> back =
        await service.httpGet('/api/v1/Administration/users/getUserById');
    debugPrint('myProfileback ${back}');
    if (back['status'])
      return DataPersonalInformation.fromJson(back['data']['data']);
    else {
      toast(back['error']);
      return null;
    }
  }
  static Future<List<DataPersonalInformation>> search(MyService service,
      {required String search,int pageNumber=1}) async {//todo
    debugPrint('search()');
    Map<String, dynamic> back = await service.httpGet(
        '/api/v1/Administration/users/SearchUsername?'
        'PartialOrFullUserName=$search&pageNumber=$pageNumber');
    debugPrint('back search ${back}');
    if(back['status']==false){
      toast(back['error']);
      return [];
    }
    return convertDataList<DataPersonalInformation>(back['data'], 'results', 'DataPersonalInformation');
  }
  static Future<DataPersonalInformation?> getUser(
      //todo
      MyService service,
      String username) async {
    username = username.replaceAll('@', '');
    debugPrint('getUser($username)');
    Map<String, dynamic> back = await service.httpGet(
        '/api/v1/Administration/getByUsername?userName=$username&myID=${getIt<MainState>().userId}');
    debugPrint('getUserback ${back}');
    if (back['status'])
      return DataPersonalInformation.fromJson(back['data']['data']);
    else {
      try{
        toast(back['error']);
      } catch (e){}

      return null;
    }
  }

  static Future<bool> followUser(MyService service, String id) async {
    debugPrint('followUser($id)');
    Map<String, dynamic> back = await service.httpPost(
        '/api/v1/Administration/users/follower/add',
        {'friendId': id},
        jsonType: true);
    debugPrint('followUserback ${back}');
    if (back['status'] == false) {
      toast(back['error']);
    }
    return back['status'];
  }

  static Future<bool> unFollowUser(MyService service, String id) async {
    debugPrint('unFollowUser($id)');
    Map<String, dynamic> back = await service.httpPost(
        '/api/v1/Administration/users/unfollow?',
        {'friendId': id},jsonType: true);
    debugPrint('unFollowUserback ${back}');
    if (back['status'] == false) {
      toast(back['error']);
    }
    return back['status'];
  }
  static Future<bool> blockUser(MyService service, String blockId) async {
    debugPrint('blockUser($blockId)');
    Map<String, dynamic> back = await service.httpPost(
        '/api/v1/Administration/BlockFriend?BlockeeId=$blockId',
        {});
    debugPrint('blockUser back ${back}');
    if (back['status'] == false) {
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
        await service.httpPostMulti('/api/v1/Administration/users/photoUpdate', FormData.fromMap(map));
    if (back['status'] == false) {
      toast(back['error']);
    }
    return back['status'];
  }

  static Future<bool> changeTeam(MyService service, DataMatchTeam team) async {
    debugPrint('changeTeam(${team.id})');
    var out = {
      'team_key': '${team.id}',
      'team_name': team.name,
      'team_logo': team.logo,
      'team_country': team.country,
      'dateAdded': DateTime.now().toString(),
    };
    print('out $out');
    Map<String, dynamic> back = await service.httpPost(
        '/api/v1/Team/addTeamToUser',
        out,
        jsonType: true);
    debugPrint('changeTeamBack ${back}');
    if (back['status'] == false) {
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
    if (back['status'] == false) {
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
