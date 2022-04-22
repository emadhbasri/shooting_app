import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shooting_app/classes/functions.dart';
import 'package:shooting_app/classes/states/main_state.dart';
import 'package:shooting_app/main.dart';

import '../models.dart';
import 'package:dio/dio.dart';
import 'my_service.dart';

class ShotsService {
  static Future<DataPost?> createShot(//todo
    MyService service, {
    required List<XFile> images,
    required String details,
    bool isFriend = false,
    bool isPublic = true,
        int? matchId
  }) async {
    debugPrint('createShot()');
    Map<String, dynamic> map = {
      'Details': details,
      'IsFriend': isFriend,
      'IsPublic': isPublic,
      'createdAt': DateTime.now().toString()
    };
    if(matchId!=null) map['MatchId']=matchId.toString();
    if (images.isNotEmpty) {
      List<MultipartFile> temp = [];
      for (int j = 0; j < images.length; j++) {
        MultipartFile file = await MultipartFile.fromFile(images[j].path,
            filename: images[j].name);
        temp.add(file);
      }
      map['MediaType'] = temp;
    }
    print('map $map');
    Map<String, dynamic> back =
        await service.httpPostMulti('/api/v1/Shots/add', FormData.fromMap(map));
    debugPrint('back ${back}');
    if(back['status']==false){
      toast(back['error']);
      return null;
    }
    return convertData(back['data'], 'data', DataType.clas,
        classType: 'DataPost');
  }

  static Future<List<DataPost>> shotsAll(MyService service,//todo
      {int pageNumber = 1}) async {
    debugPrint('shotsAll()');
    Map<String, dynamic> back =
        await service.httpGet('/api/v1/Shots/all?pageNumber=$pageNumber');
    debugPrint('back ${back}');
    if(back['status'])
      return convertDataList<DataPost>(back['data'], 'results', 'DataPost');
    else{
      toast(back['error']);
      return [];
    }
  }

  static Future<List<DataPost>> search(MyService service,
      {required String search}) async {//todo
    debugPrint('search()');
    Map<String, dynamic> back = await service.httpPost(
        '/api/v1/Shots/search?searchTag=$search&userId=${getIt<MainState>().userId}',
        {});
    debugPrint('back ${back}');
    if(back['status']==false){
      toast(back['error']);
      return [];
    }
    return convertDataList<DataPost>(back, 'data', 'DataPost');
  }

  static Future<Map<String,dynamic>> fanFeed(MyService service,//todo
      {int pageNumber = 1}) async {
    debugPrint('fanFeed()');
    Map<String, dynamic> back = await service.httpGet(
        '/api/v1/Shots/fanFeeds?pageNumber=$pageNumber');
    debugPrint('back ${back}');
    if(back['status']==false){
      toast(back['error']);
      return {};
    }
    return {
      'totalPage':back['data']['total_pages'],
      'list':convertDataList<DataPost>(back['data'], 'results', 'DataPost')};
  }
  static Future<Map<String,dynamic>> getByUserId(MyService service,//todo
          {int pageNumber = 1,int PageSize=15}) async {
    debugPrint('geByUserId($pageNumber)');
    Map<String, dynamic> back = await service.httpGet(
        '/api/v1/Shots/getPostsByUserId?pageNumber=${pageNumber}&PageSize=$PageSize');
    debugPrint('back ${back}');
    if(back['status']==false){
      toast(back['error']);
      return {};
    }
    return {
      'totalPage':back['data']['total_pages'],
      'hasNext':back['data']['hasNext'],
      'list':convertDataList<DataPost>(back['data'], 'results', 'DataPost')};
  }

  static Future<Map<String,dynamic>> getByUsername(MyService service,//todo
          {int pageNumber = 1,int PageSize=15,required String username}) async {
    username=username.replaceAll('@', '');
    debugPrint('geByUsername($username)');
    Map<String, dynamic> back = await service.httpGet(
        '/api/v1/Shots/getPostsByUsername?pageNumber=${pageNumber}&PageSize=${PageSize}&username=$username');
    debugPrint('back ${back}');
    if(back['status']==false){
      toast(back['error']);
      return {};
    }
    return {
      'totalPage':back['data']['total_pages'],
      'hasNext':back['data']['hasNext'],
      'list':convertDataList<DataPost>(back['data'], 'results', 'DataPost')};
  }

  static Future<DataPost?> getShotById(MyService service, String shotId) async {
    debugPrint('getShotById($shotId)');
    Map<String, dynamic> back =
        await service.httpGet('/api/v1/Shots/PostById$shotId');
    debugPrint('back ${back}');
    if(back['status']==false){
      toast(back['error']);
      return null;
    }
    return convertData(back['data'], 'data', DataType.clas,
        classType: 'DataPost');
  }

  static Future<List<DataPost>> getMatchUps(//todo
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
    if(back['status']==false){
      // toast(back['error']);
      return [];
    }
    return convertDataList<DataPost>(back['data'], 'data', 'DataPost');
  }

  // Future<DataPost> shotsById({required String id})async {

  // }

  static Future<DataPostComment?> shotsComment(//todo
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

  static Future<DataCommentReply?> commentReply(//todo
    MyService service, {
    required String commentId,
    required String reply,
  }) async {
    debugPrint('commentReply($commentId,$reply)');
    Map<String,dynamic> go =  {
      "UserId": getIt<MainState>().userId,
      "PostCommentId": commentId,
      "ReplyDetail": reply,
      'createdAt': DateTime.now().toString()
      // "MediaType": ""
    };
    print('gogo $go');
    Map<String, dynamic> back = await service.httpPost(
        '/api/v1/Shots/comment/reply', go,
        jsonType: false);
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
        , {});
    debugPrint('shotLike back $back');
    if(back['status']==false){
      toast(back['error']);
      return null;
    }
    // return back['status'];
    return back['data']['data'];
  }

  static Future<bool> shotReport(
      MyService service, {
        required DataPost post,
        required String message
      }) async {
    debugPrint('shotReport()');
    Map<String, dynamic> back = await service.httpPost(
        '/api/v1/Shots/addPostReport', {
      "message": message,
      "postId": post.id,
      "postOwnerId": post.person==null?'':post.person!.personalInformationId,
      "dateReported": DateTime.now().toString()
    },jsonType: true);
    debugPrint('shotReport back $back');
    if(back['status']==false){
      toast(back['error']);
    }
    return back['status'];
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
    if(back['status']==false){
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
    if(back['status']==false){
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
    bool back =
        await service.httpDelete('/api/v1/Shots/delete$shotId');
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
