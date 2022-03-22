import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shooting_app/classes/live_match_model.dart';
import 'models.dart';
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
    debugPrint('body ${utf.body}');

    try {
      var json = utf8.decode(utf.bodyBytes);
      var jsonn = jsonDecode(json);
      // debugPrint('jsonnjsonn ${jsonn.runtimeType}');
      if (utf.statusCode == 201 ||
          utf.statusCode == 200 ||
          utf.statusCode == 204) {
        return {'status': true, 'data': jsonn};
      } else {
        return {'status': false, 'error': jsonn['message']};
      }
    } catch (e) {
      debugPrint('cathc e $e');
      return {'status': false, "data": false};
    }
  }

  Future<List<DataCountry>> countries() async {
    debugPrint('shotsAll()');
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
  Future<List<DataMatch1>> matchs({
    required String date,
    required int league,
    required int season,
}) async {
    debugPrint('matchs(${'fixtures?date=$date&league=$league&season=$season'})');
    // return [];
    Map<String, dynamic> back = await httpGet('fixtures?date=$date&league=$league&season=$season');
    // debugPrint('back ${back}');
    return convertDataList<DataMatch1>(
        back['data'], 'response', 'DataMatch1');
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
    debugPrint('matchStatics()');
    Map<String, dynamic> back = await httpGet('fixtures/events?fixture=$fixture');
    // debugPrint('back ${back}');
    return convertDataList<DataEvent>(
        back['data'], 'response', 'DataEvent');
  }
  Future<Map<String,DataLineUps?>> matchLineUps({required int fixture}) async {
    debugPrint('matchLineUps()');
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
