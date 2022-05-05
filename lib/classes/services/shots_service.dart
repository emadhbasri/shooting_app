import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shooting_app/classes/functions.dart';
import 'package:shooting_app/classes/states/main_state.dart';
import 'package:shooting_app/main.dart';

import '../models.dart';
import 'package:dio/dio.dart';
import 'my_service.dart';
import 'package:http/http.dart' as http;

class ShotsService {
  static Future<DataPost?> createShot(
      //todo
      MyService service,
      {required List<XFile> images,
        XFile? video,
      required String details,
      bool isFriend = false,
      bool isPublic = true,
      int? matchId}) async {
    debugPrint('createShot()');
    Map<String, dynamic> map = {
      'Details': details,
      'IsFriend': isFriend,
      'IsPublic': isPublic,
      'createdAt': DateTime.now().toString()
    };
    if (matchId != null) map['MatchId'] = matchId.toString();
    if (images.isNotEmpty) {
      List<MultipartFile> temp = [];
      for (int j = 0; j < images.length; j++) {
        MultipartFile file = await MultipartFile.fromFile(images[j].path,
            filename: images[j].name);
        temp.add(file);
      }
      map['MediaType'] = temp;
    }else if(video!=null){
      MultipartFile file = await MultipartFile.fromFile(video.path,
          filename: video.name);
      map['MediaType']=file;
    }
    print('map $map');
    Map<String, dynamic> back =
        await service.httpPostMulti('/api/v1/Shots/add', FormData.fromMap(map));
    debugPrint('back ${back}');
    if (back['status'] == false) {
      toast(back['error']);
      return null;
    }
    DataPost out = convertData(back['data'], 'data', DataType.clas,
        classType: 'DataPost');
    ///api/v1/Shots/tagUserInPost
    List<String> split = details.split(' ');
    for(int j=0;j<split.length;j++){
      if (split[j].length > 0 && split[j][0] == '@'){
        String theUserName = split[j].replaceAll('@', '');
        Map<String, dynamic> backM =
        await service.httpPost('/api/v1/Shots/tagUserInPost'
            '?friendUsername=${theUserName}&postId=${out.id}', {});
      }
    }
    return out;
  }

  static Future<List<DataPost>> shotsAll(MyService service, //todo
      {int pageNumber = 1}) async {
    debugPrint('shotsAll()');
    Map<String, dynamic> back =
        await service.httpGet('/api/v1/Shots/all?pageNumber=$pageNumber');
    debugPrint('back ${back}');
    if (back['status'])
      return convertDataList<DataPost>(back['data'], 'results', 'DataPost');
    else {
      toast(back['error']);
      return [];
    }
  }

  static Future<List<DataPost>> search(MyService service,
      {required String search}) async {
    //todo
    debugPrint('search()');
    Map<String, dynamic> back = await service.httpPost(
        '/api/v1/Shots/search?searchTag=$search&userId=${getIt<MainState>().userId}',
        {});
    debugPrint('back ${back}');
    if (back['status'] == false) {
      toast(back['error']);
      return [];
    }
    return convertDataList<DataPost>(back, 'data', 'DataPost');
  }

  static Future<Map<String, dynamic>> fanFeed(MyService service, //todo
      {int pageNumber = 1}) async {
    debugPrint('fanFeed()');
    Map<String, dynamic> back =
        await service.httpGet('/api/v1/Shots/fanFeeds?pageNumber=$pageNumber');
    debugPrint('back ${back}');
    if (back['status'] == false) {
      toast(back['error']);
      return {};
    }
    return {
      'totalPage': back['data']['total_pages'],
      'list': convertDataList<DataPost>(back['data'], 'results', 'DataPost')
    };
  }

  static Future<Map<String, dynamic>> getByUserId(MyService service, //todo
      {int pageNumber = 1,
      int PageSize = 15}) async {
    debugPrint('geByUserId($pageNumber)');
    Map<String, dynamic> back = await service.httpGet(
        '/api/v1/Shots/getPostsByUserId?pageNumber=${pageNumber}&PageSize=$PageSize');
    debugPrint('back ${back}');
    if (back['status'] == false) {
      // toast(back['error']);
      return {};
    }
    return {
      'totalPage': back['data']['total_pages'],
      'hasNext': back['data']['hasNext'],
      'list': convertDataList<DataPost>(back['data'], 'results', 'DataPost')
    };
  }

  static Future<Map<String, dynamic>> getByUsername(MyService service, //todo
      {int pageNumber = 1,
      int PageSize = 15,
      required String username}) async {
    username = username.replaceAll('@', '');
    debugPrint('geByUsername($username)');
    Map<String, dynamic> back = await service.httpGet(
        '/api/v1/Shots/getPostsByUsername?pageNumber=${pageNumber}&PageSize=${PageSize}&username=$username');
    debugPrint('back ${back}');
    if (back['status'] == false) {
      // toast(back['error']);
      return {};
    }
    return {
      'totalPage': back['data']['total_pages'],
      'hasNext': back['data']['hasNext'],
      'list': convertDataList<DataPost>(back['data'], 'results', 'DataPost')
    };
  }

  static Future<DataPost?> getShotById(MyService service, String shotId) async {
    debugPrint('getShotById($shotId)');
    Map<String, dynamic> back =
        await service.httpGet('/api/v1/Shots/PostById$shotId');
    debugPrint('back ${back}');
    if (back['status'] == false) {
      toast(back['error']);
      return null;
    }
    return convertData(back['data'], 'data', DataType.clas,
        classType: 'DataPost');
  }

  static Future<List<DataPost>> getMatchUps(
    //todo
    MyService service, {
    required int matchId,
    // int pageNumber=1
    // required int teamHomeId,
    // required int teamAwayId,
    // required String date,
  }) async {
    debugPrint('getMatchUps(${{
      // 'team1_key': '$teamHomeId',
      // 'team2_key': '$teamAwayId',
      // 'date': date,
      // 'pageNumber': pageNumber,
      'matchId': matchId,
    }})');
    // return [];
    //
    Map<String, dynamic> back =
        await service.httpGet('/api/v1/Shots/matchup?matchId=$matchId'
            // d&pageNumber=$pageNumber'
            );
    debugPrint('back111 ${back}');
    if (back['status'] == false) {
      // toast(back['error']);
      return [];
    }
    return convertDataList<DataPost>(back['data'], 'data', 'DataPost');
  }

  // Future<DataPost> shotsById({required String id})async {

  // }

  static Future<DataPostComment?> shotsComment(
    //todo
    MyService service, {
    required String postId,
    required String comment,
  }) async {
    debugPrint('shotsComment($postId,$comment)');
    MainState mainS = getIt<MainState>();
    Map<String, dynamic> back = await service.httpPost(
        '/api/v1/Shots/comment',
        {
          "UserId": mainS.userId,
          "PostId": postId,
          "Comment": comment,
          'createdAt': DateTime.now().toString()
          // "MediaType": ""
        },
        jsonType: false);
    print('out ${{
      "UserId": mainS.userId,
      "PostId": postId,
      "Comment": comment,
      'createdAt': DateTime.now().toString()
      // "MediaType": ""
    }}');
    debugPrint('back shotsComment ${back}');
    if (back['status'])
      return DataPostComment.fromJson(back['data']['data']);
    else {
      toast(back['error']);
      return null;
    }
  }

  static Future<DataCommentReply?> commentReply(
    //todo
    MyService service, {
    required String commentId,
    required String reply,
  }) async {
    debugPrint('commentReply($commentId,$reply)');
    Map<String, dynamic> go = {
      "UserId": getIt<MainState>().userId,
      "PostCommentId": commentId,
      "ReplyDetail": reply,
      'createdAt': DateTime.now().toString()
      // "MediaType": ""
    };
    print('gogo $go');
    Map<String, dynamic> back = await service
        .httpPost('/api/v1/Shots/comment/reply', go, jsonType: false);
    debugPrint('back commentReply ${back}');
    if (back['status'])
      return DataCommentReply.fromJson(back['data']['data']);
    else {
      toast(back['error']);
      return null;
    }
  }

  static Future<String?> shotLike(
    MyService service, {
    required String postId,
  }) async {
    debugPrint('shotLike()');
    Map<String, dynamic> back = await service.httpPost(
        '/api/v1/Shots/like$postId'
        // '?userId=${getIt<MainState>().userId}'
        ,
        {});
    debugPrint('shotLike back $back');
    if (back['status'] == false) {
      toast(back['error']);
      return null;
    }
    // return back['status'];
    return back['data']['data'];
  }

  static Future<bool> shotReport(MyService service,
      {required DataPost post, required String message}) async {
    debugPrint('shotReport()');

    List<bool> checks=[];
    bool? cText=await checkReportText(post.details??'');
    if(cText==null){
      toast('please check your connection');
      return false;
    }else{
      checks.add(cText);
    }
    for(int j=0;j<post.mediaTypes.length;j++){
      bool? cImage = await checkReportImage(post.mediaTypes[j].media);
      if(cImage==null){
        toast('please check your connection');
        return false;
      }else{
        checks.add(cImage);
      }
    }
    bool shouldReport=false;
    for(int j=0;j<checks.length;j++){
        if(checks[j]){
          shouldReport=true;
          break;
        }
    }
    print('checks ${checks}');
    print('shouldReport $shouldReport');


    if(shouldReport){
      Map<String, dynamic> back = await service.httpPost(
          '/api/v1/Shots/addPostReport',
          {
            "message": message,
            "postId": post.id,
            "postOwnerId":
            post.person == null ? '' : post.person!.personalInformationId,
            "dateReported": DateTime.now().toString()
          },
          jsonType: true);
      debugPrint('shotReport back $back');
      if (back['status'] == false) {
        toast(back['error']);
      }
      return back['status'];
    }else{
      toast('there is no problem with this content.');
      return false;
    }

  }

  static Future<bool?> checkReportText(String text) async {
    http.Response utf = await http
        .get(Uri.parse(""
            "http://api1.webpurify.com/services/rest/?"
            "format=json&api_key=64b03d7273c0635157a724ac65a56835&text="
            "${text}&lang=en"))
        .catchError((e) {
      FutureOr<http.Response> out = http.Response('nonet', 403);
      return out;
    });
    if (utf.statusCode == 403 && utf.body == 'nonet') {
      return null;
    }
    try {
      var json = utf8.decode(utf.bodyBytes);
      // Map<String,dynamic> jsonn = jsonDecode(json);
      // debugPrint('jsonnjsonn ${jsonn.runtimeType}');
      if (utf.statusCode == 201 ||
          utf.statusCode == 200 ||
          utf.statusCode == 204) {
        print('contain ${json.contains('"found": "0"')}');
        bool b1 = json.contains('"found": "0"');
        // bool b2 = json.contains('found": "0"');
        return b1;
      } else {
        return null;
      }
    } catch (e) {
      debugPrint('cathc e $e');
      return null;
    }
  }

  static checkReportImage(String text) async {
    http.Response utf = await http
        .get(Uri.parse(""
            "https://im-api1.webpurify.com/services/rest/?"
        "api_key=aebaa29966e1fac36d56933af4246d54&format="
        "json&method=webpurify.aim.imgcheck&cats=nudity,wad,offensive,gore,ocr,scam"
            "&imgurl=$text"))
        .catchError((e) {
      FutureOr<http.Response> out = http.Response('nonet', 403);
      return out;
    });
    print('text $text');
    if (utf.statusCode == 403 && utf.body == 'nonet') {
      return null;
    }
    try {
      var json = utf8.decode(utf.bodyBytes);
      var jsonn = jsonDecode(json);
      // debugPrint('jsonnjsonn ${jsonn.runtimeType}');
      if (utf.statusCode == 201 ||
          utf.statusCode == 200 ||
          utf.statusCode == 204) {
        Map<String, dynamic> res = jsonn['rsp'];
        print('res $res');
        List<int> list = [];
        list.add(convertData(res, 'nudity', DataType.int));
        list.add(convertData(res, 'nuditypartial', DataType.int));
        // list.add(convertData(res, 'nuditysafe', DataType.int));
        list.add(convertData(res, 'weapon', DataType.int));
        list.add(convertData(res, 'alcohol', DataType.int));
        list.add(convertData(res, 'drugs', DataType.int));
        list.add(convertData(res, 'offensive', DataType.int));
        list.add(convertData(res, 'gore', DataType.int));
        list.add(convertData(res, 'artificialtext', DataType.int));
        // list.add(convertData(res, 'naturaltext', DataType.int));
        list.add(convertData(res, 'scam', DataType.int));
        bool out=false;
        for(int j=0;j<list.length;j++){
              if(list[j]>50){
                print('jj $j');
                out=true;
                break;
              }
        }
        return out;
      } else {
        return null;
      }
    } catch (e) {
      debugPrint('cathc e $e');
      return null;
    }
  }

  static Future<String?> commentLike(
    MyService service, {
    required String postCommentId,
  }) async {
    debugPrint('commentLike()');
    Map<String, dynamic> back = await service.httpPost(
        '/api/v1/Shots/comment/like$postCommentId?userId=${getIt<MainState>().userId}',
        {},
        jsonType: false);
    debugPrint('commentLike back $back');
    if (back['status'] == false) {
      toast(back['error']);
      return null;
    }
    return back['data']['data'];
  }

  static Future<String?> replyLike(
    MyService service, {
    required String commentReplyId,
  }) async {
    print('replyLike($commentReplyId)');
    Map<String, dynamic> back = await service
        .httpPost('/api/v1/Shots/commentReplyLike$commentReplyId', {});
    debugPrint('replyLike back $back');
    if (back['status'] == false) {
      toast(back['error']);
      return null;
    }
    return back['data']['data'];
  }

  static Future<bool> deleteComment(
    MyService service, {
    required String commentId,
  }) async {
    print('replyLike($commentId)');
    bool back =
        await service.httpDelete('/api/v1/Shots/delete/commentById$commentId');
    debugPrint('deleteComment back $back');
    return back;
  }

  static Future<bool> deleteCommentLike(
    MyService service, {
    required String commentId,
  }) async {
    print('deleteCommentLike($commentId)');
    bool back =
        await service.httpDelete('/api/v1/Shots/delete/comment/Like$commentId');
    debugPrint('deleteCommentLike back $back');
    return back;
  }

  static Future<bool> deleteReply(
    MyService service, {
    required String replyId,
  }) async {
    print('deleteReply($replyId)');
    bool back =
        await service.httpDelete('/api/v1/Shots/delete/comment/Reply$replyId');
    debugPrint('deleteReply back $back');
    return back;
  }

  static Future<bool> deleteReplyLike(
    MyService service, {
    required String replyId,
  }) async {
    print('deleteReplyLike($replyId)');
    bool back =
        await service.httpDelete('/api/v1/Shots/delete/Reply/Like$replyId');
    debugPrint('deleteReplyLike back $back');
    return back;
  }

  static Future<bool> deleteShot(
    MyService service, {
    required String shotId,
  }) async {
    print('deleteShot($shotId)');
    bool back = await service.httpDelete('/api/v1/Shots/delete$shotId');
    debugPrint('deleteShot back $back');
    return back;
  }

  static Future<bool> deleteShotLike(
    MyService service, {
    required String shotId,
  }) async {
    print('deleteShotLike($shotId)');
    bool back = await service.httpDelete('/api/v1/Shots/delete/like$shotId');
    debugPrint('deleteShotLike back $back');
    return back;
  }
}
