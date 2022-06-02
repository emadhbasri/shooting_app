import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
// 
import 'package:shooting_app/classes/functions.dart';
import 'package:shooting_app/classes/live_match_model.dart';
import '../models.dart';
import 'package:http/http.dart' as http;

class LiveMatchService {
  final String _server = 'https://api-football-v1.p.rapidapi.com/v3/';

  Future<Map<String, dynamic>> httpGet(String url) async {
    Map<String, String> headers = {
      'x-rapidapi-host': 'api-football-v1.p.rapidapi.com',
      "x-rapidapi-key": "c52704a0f1mshce78bef813e31f1p1f4499jsn6cd34369fc03",
    };
    http.Response utf = await http
        .get(Uri.parse(_server + url), headers: headers)
        .catchError((e) {
      FutureOr<http.Response> out = http.Response('nonet', 403);
      return out;
    });
    if (utf.statusCode == 403 && utf.body == 'nonet') {
      return {'status': false, "data": false};
    }
    debugPrint('body ${utf.statusCode} ${utf.body}');

    try {
      var json = utf8.decode(utf.bodyBytes);
      var jsonn = jsonDecode(json);
      // debugPrint('jsonnjsonn ${jsonn.runtimeType}');
      if (utf.statusCode == 201 ||
          utf.statusCode == 200 ||
          utf.statusCode == 204) {
        return {'status': true, 'data': jsonn};
      } else {
        return {'status': false, 'error': jsonn['messages']};
      }
    } catch (e) {
      debugPrint('cathc e $e');
      return {'status': false, "data": false};
    }
  }

  Future<http.StreamedResponse?> httpGetStream(String url) async {
    Map<String, String> headers = {
      'x-rapidapi-host': 'api-football-v1.p.rapidapi.com',
      "x-rapidapi-key": "c52704a0f1mshce78bef813e31f1p1f4499jsn6cd34369fc03",
    };
    http.Request request = http.Request('GET', Uri.parse(_server + url));
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send()
        .catchError((e) {
      FutureOr<http.StreamedResponse> out = http.StreamedResponse(Stream<List<int>>.empty(),403);
      return out;
    });
    if (response.statusCode == 403) {
      return null;
    }
return response;



  }

  Future<List<DataCountry>> countries() async {
    debugPrint('countries()');
    Map<String, dynamic> back = await httpGet('countries');
    // debugPrint('back ${back}');
    return convertDataList<DataCountry>(
        back['data'], 'response', 'DataCountry');
  }

  Future<List<DataLeagueMain>> leagues({required String country}) async {
    debugPrint('leagues()');
    Map<String, dynamic> back = await httpGet('leagues?country=$country');
    // debugPrint('back ${back}');
    return convertDataList<DataLeagueMain>(
        back['data'], 'response', 'DataLeagueMain');
  }
  Future<List<DataMatchTeam>> teams({required String search}) async {
    debugPrint('teams($search)');
    Map<String, dynamic> back = await httpGet('teams?search=$search');
    if(back['status']){
      List<DataMatchTeam> out = [];
      for(int j=0;j<back['data']['response'].length;j++){
        out.add(
            convertData(back['data']['response'][j], 'team', DataType.clas,classType: 'DataMatchTeam')
        );
      }
      // debugPrint('back ${back}');
      return out;
    }else{
      print('back $back');
      toast(back['error'],isLong: true);
      return [];
    }
  }
  Future<List<DataMatchTeam>> getTeams({required int league,required int season}) async {
    debugPrint('getTeams($league,$season)');
    Map<String, dynamic> back = await httpGet('teams?league=$league&season=$season');
    List<DataMatchTeam> out = [];
    for(int j=0;j<back['data']['response'].length;j++){
      out.add(
          convertData(back['data']['response'][j], 'team', DataType.clas,classType: 'DataMatchTeam')
      );
    }
    return out;
  }
  Future<List<DataMatch1>> matchsV2({
    required String date,
  }) async {
    debugPrint('matchs($date)');
    // return [];
    Map<String, dynamic> back = await httpGet('fixtures?date=$date');
    // debugPrint('back ${back}');
    return convertDataList<DataMatch1>(
        back['data'], 'response', 'DataMatch1');
  }

  Future<DataMatch1> match({
    required int id,
}) async {
    debugPrint('matchs($id)');
    // return [];
    Map<String, dynamic> back = await httpGet('fixtures?id=$id');
    debugPrint('back ${back['data']['response'].length}');
    return DataMatch1.fromAllJson(back['data']['response'][0] as Map<String,dynamic>);
  }

  Future<Map<String,List<DataStatistics>>> matchStatics({required int fixture}) async {
    debugPrint('matchStatics()');
    Map<String, dynamic> back = await httpGet('fixtures/statistics?fixture=$fixture');
    // debugPrint('back ${back}');
    List list=back['data']['response'];
    if(list.isEmpty)return {
      'home':[],
      'away':[],
    };
    return {
      'home':convertDataList<DataStatistics>(
          list[0], 'statistics', 'DataStatistics'),
      'away':convertDataList<DataStatistics>(
          list[1], 'statistics', 'DataStatistics'),
    };
  }

  Future<List<DataEvent>> matchEvents({required int fixture}) async {
    debugPrint('matchEvents($fixture)');
    Map<String, dynamic> back = await httpGet('fixtures/events?fixture=$fixture');
    // debugPrint('back ${back}');
    return convertDataList<DataEvent>(
        back['data'], 'response', 'DataEvent');
  }
  Future<Map<String,DataLineUps?>> matchLineUps({required int fixture}) async {
    debugPrint('matchLineUps($fixture)');
    Map<String, dynamic> back = await httpGet('fixtures/lineups?fixture=$fixture');
    debugPrint('back ${back}');
    List<DataLineUps> list=convertDataList<DataLineUps>(
        back['data'], 'response', 'DataLineUps');
    if(list.isEmpty)return {
      'home':null,
      'away':null,
    };
    return {
      'home':list[0],
      'away':list[1],
    };
  }
}
