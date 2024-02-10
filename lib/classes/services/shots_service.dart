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

  static Future<List<String>> getStadiaTags(MyService service) async {
    debugPrint('getStadiaTags()');
    Map<String, dynamic> back =
    await service.httpGet('/api/v1/Shots/GetTopTrendingPost');
    debugPrint('getStadiaTags back ${back}');
    if (back['status'] == false) {
      try{toast(back['error']);}catch(e){}
      return [];
    }
    return (back['data']['data'] as List<dynamic>).cast<String>();
  }
  static Future<List<DataPost>> getStadiaShots(MyService service) async {
    debugPrint('getStadiaShots()');
    Map<String, dynamic> back =
    await service.httpGet('/api/v1/Shots/stadiaPosts');
    debugPrint('back ${back}');
    if (back['status'] == false) {
      toast(back['error']);
      return [];
    }
    return convertDataList<DataPost>(back['data'], 'data','DataPost');
  }
  static Future<Map<String, dynamic>> getStadiaShotsPlus(MyService service,
      {int pageNumber = 1,
      int pageSize = 15}) async {
    debugPrint('getStadiaShots()');
    Map<String, dynamic> back =
    await service.httpGet('/api/v1/Shots/stadiaPostsPagination?PageNumber=$pageNumber&PageSize=$pageSize');
    debugPrint('back ${back}');
    if (back['status'] == false) {
      toast(back['error']);
      return {};
    }
    return {
      'hasNext': back['data']['data']['hasNext'],
      'list': convertDataList<DataPost>(back['data']['data'], 'getFanFeedDTOs', 'DataPost')
    };
  }
  static Future<List<DataPost>> getStadiaSearch(MyService service, String tag) async {
    debugPrint('getStadiaSearch($tag)');
    Map<String, dynamic> back =
    await service.httpGet('/api/v1/Shots/searchTrending?searchTag=$tag');
    debugPrint('back ${back}');
    if (back['status'] == false) {
      toast(back['error']);
      return [];
    }
    return convertDataList<DataPost>(back['data'], 'data','DataPost');
  }

  static Future<DataPost?> editShot(
      MyService service,
      {
        List<String> mediaIds=const [],
        List<XFile> images = const [],
        XFile? video,
        required String details,
        required String shotId,
        }) async {
    debugPrint('editShot()');
    Map<String, dynamic> map = {
      'Details': details,
      'EditedAt':DateTime.now().toString()
    };
    if (images.isNotEmpty) {
      List<MultipartFile> temp = [];
      for (int j = 0; j < images.length; j++) {
        MultipartFile file = await MultipartFile.fromFile(images[j].path,
            filename: images[j].name);
        temp.add(file);
      }
      map['MediaType'] = temp;
    } else if (video != null) {
      MultipartFile file =
      await MultipartFile.fromFile(video.path, filename: video.name);
      map['MediaType'] = file;
    }
    if(mediaIds.isNotEmpty);
      map['mediaIds']=mediaIds.join(',');
    print('map $map');
    print('url ${'/api/v1/Shots/edit/$shotId'}');
    Map<String, dynamic> back =
    await service.httpPutMulti('/api/v1/Shots/edit/$shotId', FormData.fromMap(map),jsonType: true);
    debugPrint('back ${back}');
    if (back['status'] == false) {
      toast(back['error']);
      return null;
    }
    DataPost out =
      convertData(back['data'], 'data', DataType.clas, classType: 'DataPost');

    return out;
  }



  static Future<DataPost?> createShot(
      MyService service,
      {List<XFile> images = const [],
      XFile? video,
      required String details,
      bool isFriend = false,
      required bool stadia,
      bool isPublic = true,
      int? matchId}) async {
    debugPrint('createShot()');
    Map<String, dynamic> map = {
      'Details': details,
      'IsFriend': isFriend,
      'IsPublic': isPublic,
      'CreatedAt': DateTime.now().toString()
    };
    if (stadia) map['StadiaId']='123';
    if (matchId != null) map['MatchId'] = matchId.toString();
    if (images.isNotEmpty) {
      List<MultipartFile> temp = [];
      for (int j = 0; j < images.length; j++) {
        MultipartFile file = await MultipartFile.fromFile(images[j].path,
            filename: images[j].name);
        temp.add(file);
      }
      map['MediaType'] = temp;
    } else if (video != null) {
      MultipartFile file =
          await MultipartFile.fromFile(video.path, filename: video.name);
      map['MediaType'] = file;
    }
    print('map $map');
    Map<String, dynamic> back =
        await service.httpPostMulti('/api/v1/Shots/add', FormData.fromMap(map));
    debugPrint('back ${back}');
    if (back['status'] == false) {
      toast(back['error']);
      return null;
    }
    DataPost out =
        convertData(back['data'], 'data', DataType.clas, classType: 'DataPost');
    if (matchId == null) {
      List<String> split = details.split(' ');
      for (int j = 0; j < split.length; j++) {
        if (split[j].length > 0 && split[j][0] == '@') {
          String theUserName = split[j].replaceAll('@', '');
          // Map<String, dynamic> backM =
          await service.httpPost(
              '/api/v1/Shots/tagUserInPost'
              '?friendUsername=${theUserName}&postId=${out.id}',
              {});
        }
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

  static Future<Map<String, dynamic>> fanFeedPlus(MyService service, //todo
          {int pageNumber = 1,
        int pageSize = 15}) async {
    debugPrint('fanFeed()');
    Map<String, dynamic> back =
    await service.httpGet('/api/v1/Shots/fanFeedsPagination?pageNumber=$pageNumber&PageSize=$pageSize');
    debugPrint('back ${back}');
    if (back['status'] == false) {
      toast(back['error']);
      return {};
    }
    return {
      'hasNext': back['data']['data']['hasNext'],
      'list': convertDataList<DataPost>(back['data']['data'], 'getFanFeedDTOs', 'DataPost')
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
      'list': convertDataList<DataPost>(
          back['data']['results'], 'getFanFeedDTOs', 'DataPost')
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


  static Future<DataPostComment?> editComment(
      //todo
      MyService service, {
        required String commentId,
        required String comment,
        List<String> mediaIds=const [],
        List<XFile> images = const [],
        XFile? video,
      }) async {
    debugPrint('editComment($commentId,$comment)');

    Map<String, dynamic> map = {
      'Comment': comment,
      'EditedAt':DateTime.now().toString()
    };
    if(mediaIds.isNotEmpty)
      map['mediaIds']=mediaIds.join(',');

    if (images.isNotEmpty) {
      List<MultipartFile> temp = [];
      for (int j = 0; j < images.length; j++) {
        MultipartFile file = await MultipartFile.fromFile(images[j].path,
            filename: images[j].name);
        temp.add(file);
      }
      map['MediaType'] = temp;
    } else if (video != null) {
      MultipartFile file =
      await MultipartFile.fromFile(video.path, filename: video.name);
      map['MediaType'] = file;
    }

    print('out ${map}');

    Map<String, dynamic> back = await service.httpPutMulti(
        '/api/v1/Shots/comment/edit/$commentId', FormData.fromMap(map));
    debugPrint('back shotsComment ${back}');
    if (back['status'])
      return DataPostComment.fromJson(back['data']['data']);
    else {
      toast(back['error']);
      return null;
    }
  }

  static Future<DataPostComment?> shotsComment(
    //todo
    MyService service, {
        required bool stadia,
    required String postId,
    required String comment,
    List<XFile> images = const [],
    XFile? video,
  }) async {
    debugPrint('shotsComment($postId,$comment)');
    MainState mainS = getIt<MainState>();

    Map<String, dynamic> map = {
      "UserId": mainS.userId,
      "PostId": postId,
      'Comment': comment,
      'createdAt': DateTime.now().toString()
    };
    if (stadia) map['StadiaId']='123';
    if (images.isNotEmpty) {
      List<MultipartFile> temp = [];
      for (int j = 0; j < images.length; j++) {
        MultipartFile file = await MultipartFile.fromFile(images[j].path,
            filename: images[j].name);
        temp.add(file);
      }
      map['MediaType'] = temp;
    } else if (video != null) {
      MultipartFile file =
          await MultipartFile.fromFile(video.path, filename: video.name);
      map['MediaType'] = file;
    }

    print('out ${map}');

    Map<String, dynamic> back = await service.httpPostMulti(
        '/api/v1/Shots/comment', FormData.fromMap(map));

    // Map<String, dynamic> back = await service.httpPost(
    //     '/api/v1/Shots/comment',
    //     {
    //       "UserId": mainS.userId,
    //       "PostId": postId,
    //       "Comment": comment,
    //       'createdAt': DateTime.now().toString()
    //       // "MediaType": ""
    //     },
    //     jsonType: false);
    debugPrint('back shotsComment ${back}');
    if (back['status'])
      return DataPostComment.fromJson(back['data']['data']);
    else {
      toast(back['error']);
      return null;
    }
  }

  static Future<DataCommentReply?> editReply(
      //todo
      MyService service, {
        required String replyId,
        required String reply,
      }) async {
    debugPrint('editReply($replyId,$reply)');
    Map<String, dynamic> go = {
      "Reply": reply,
      'EditedAt':DateTime.now().toString()
      // "MediaType": ""
    };
    print('gogo $go');
    Map<String, dynamic> back = await service
        .httpPut('/api/v1/Shots/commentReply/edit$replyId', go, jsonType: false);
    debugPrint('back commentReply ${back}');
    if (back['status'])
      return DataCommentReply.fromJson(back['data']['data']);
    else {
      toast(back['error']);
      return null;
    }
  }

  static Future<DataCommentReply?> commentReply(
    //todo
    MyService service, {
        required bool stadia,
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
    if (stadia) go['StadiaId']='123';
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

  static Future<bool> shotReport(MyService service,context,
      {required DataPost post, required String message}) async {
    debugPrint('shotReport()');

    List<bool> checks = [];
    bool? cText = await checkReportText(post.details ?? '');
    if (cText == null) {
      toast(AppLocalizations.of(context)!.please_check_your_connection);
      return false;
    } else {
      checks.add(cText);
    }
    for (int j = 0; j < post.mediaTypes.length; j++) {
      bool? cImage = await checkReportImage(post.mediaTypes[j].media);
      if (cImage == null) {
        toast(AppLocalizations.of(context)!.please_check_your_connection);
        return false;
      } else {
        checks.add(cImage);
      }
    }
    bool shouldReport = false;
    for (int j = 0; j < checks.length; j++) {
      if (checks[j]) {
        shouldReport = true;
        break;
      }
    }
    print('checks ${checks}');
    print('shouldReport $shouldReport');

    if (shouldReport) {
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
    } else {
      toast(AppLocalizations.of(context)!.report_send_successfully);
      return false;
    }
  }

  static Future<bool> commentReport(MyService service,context,
      {required DataPostComment comment, required String message}) async {
    debugPrint('shotReport()');

    List<bool> checks = [];
    bool? cText = await checkReportText(comment.comment ?? '');
    if (cText == null) {
      toast(AppLocalizations.of(context)!.please_check_your_connection);
      return false;
    } else {
      checks.add(cText);
    }
    for (int j = 0; j < comment.mediaTypes.length; j++) {
      bool? cImage = await checkReportImage(comment.mediaTypes[j].media);
      if (cImage == null) {
        toast(AppLocalizations.of(context)!.please_check_your_connection);
        return false;
      } else {
        checks.add(cImage);
      }
    }
    bool shouldReport = false;
    for (int j = 0; j < checks.length; j++) {
      if (checks[j]) {
        shouldReport = true;
        break;
      }
    }
    print('checks ${checks}');
    print('shouldReport $shouldReport');

    if (shouldReport) {
      Map<String, dynamic> back = await service.httpPost(
          '/api/v1/Shots/addCommentReport',
          {
            "message": message,
            "commentId": comment.id,
            "commentOwnerId": comment.personalInformationId,
            "dateReported": DateTime.now().toString()
          },
          jsonType: true);
      debugPrint('shotReport back $back');
      if (back['status'] == false) {
        toast(back['error']);
      }
      return back['status'];
    } else {
      toast(AppLocalizations.of(context)!.report_send_successfully);
      return false;
    }
  }

  static Future<bool> replyReport(MyService service,context,
      {required DataCommentReply reply, required String message}) async {
    debugPrint('shotReport()');

    List<bool> checks = [];
    bool? cText = await checkReportText(reply.replyDetail ?? '');
    if (cText == null) {
      toast(AppLocalizations.of(context)!.report_send_successfully);
      return false;
    } else {
      checks.add(cText);
    }
    // for(int j=0;j<post.mediaTypes.length;j++){
    //   bool? cImage = await checkReportImage(post.mediaTypes[j].media);
    //   if(cImage==null){
    //     toast(AppLocalizations.of(context)!.please_check_your_connection);
    //     return false;
    //   }else{
    //     checks.add(cImage);
    //   }
    // }
    bool shouldReport = false;
    for (int j = 0; j < checks.length; j++) {
      if (checks[j]) {
        shouldReport = true;
        break;
      }
    }
    print('checks ${checks}');
    print('shouldReport $shouldReport');

    if (shouldReport) {
      Map<String, dynamic> back = await service.httpPost(
          '/api/v1/Shots/addReplyReport',
          {
            "message": message,
            "commentReplyId": reply.id,
            "commentReplyOwnerId": reply.personalInformationId,
            "dateReported": DateTime.now().toString()
          },
          jsonType: true);
      debugPrint('shotReport back $back');
      if (back['status'] == false) {
        toast(back['error']);
      }
      return back['status'];
    } else {
      toast(AppLocalizations.of(context)!.report_send_successfully);
      return false;
    }
  }

  static Future<bool?> checkReportText(String text) async {
    String url = ""
        "http://api1.webpurify.com/services/rest/?"
        "format=json&api_key=64b03d7273c0635157a724ac65a56835&text="
        "${text}&lang=en";
    http.Response utf = await http.get(Uri.parse(url)).catchError((e) {
      print('ev$e');
      FutureOr<http.Response> out = http.Response('nonet', 403);
      return out;
    });
    print('utf.body ${utf.body}');
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
        return !b1;
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
        bool out = false;
        for (int j = 0; j < list.length; j++) {
          if (list[j] > 50) {
            print('jj $j');
            out = true;
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
