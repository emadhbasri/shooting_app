import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shooting_app/classes/models.dart';
import 'package:shooting_app/classes/states/main_state.dart';
import 'package:shooting_app/main.dart';

import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';

import '../functions.dart';

class MyService {
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
    if (_access == null) return false;
    MainState state = getIt<MainState>();
    await state.init();
    return true;
    // if (_refresh != null) await getAccess();
  }

  Future<void> setToken(
      {required String refresh, required String access}) async {
    await setString('refresh', refresh);
    await setString('access', access);
    _refresh = refresh;
    _access = access;
    print('setToken ${_access} ${access}');
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

  Future<Map<String, dynamic>> httpPost(String url, Map<String, dynamic> body,
      {bool jsonType = false}) async {
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

    http.Response utf = await http
        .post(Uri.parse(_server + url), body: out, headers: headers)
        .catchError((e) {
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
    try {
      jsonn = jsonDecode(json);
    } catch (e) {}
    // debugPrint('json $json');
    // debugPrint('jsonn $jsonn');
    if (utf.statusCode == 201 ||
        utf.statusCode == 200 ||
        utf.statusCode == 204) {
      return {'status': true, 'data': jsonn};
    } else {
      if (jsonn.containsKey('errors')) {
        return {'status': false, 'error': jsonn['errors']};
      }else if(jsonn.containsKey('data') && jsonn['data'] is List){
        List ll = jsonn['data'];
        return {'status': false, 'error': ll.length>1?ll.join('\n'):ll.first};
      } else {
        return {'status': false, 'error': jsonn['message']};
      }
    }
  }

  Future<Map<String, dynamic>> httpPut(String url, Map<String, dynamic> body,
      {bool jsonType = false}) async {
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

    http.Response utf = await http
        .put(Uri.parse(_server + url), body: out, headers: headers)
        .catchError((e) {
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
    try {
      jsonn = jsonDecode(json);
    } catch (e) {}
    // debugPrint('json $json');
    // debugPrint('jsonn $jsonn');
    if (utf.statusCode == 201 ||
        utf.statusCode == 200 ||
        utf.statusCode == 204) {
      return {'status': true, 'data': jsonn};
    } else {
      return {'status': false, 'error': jsonn['message']};
    }
  }

  Future<Map<String, dynamic>> httpPatch(String url, Map<String, dynamic> body,
      {bool jsonType = false}) async {
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

    http.Response utf = await http
        .patch(Uri.parse(_server + url), body: out, headers: headers)
        .catchError((e) {
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
    try {
      jsonn = jsonDecode(json);
    } catch (e) {}
    // debugPrint('json $json');
    // debugPrint('jsonn $jsonn');
    if (utf.statusCode == 201 ||
        utf.statusCode == 200 ||
        utf.statusCode == 204) {
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
    }else{
      await getToken();
    }
    debugPrint('Get ${_server + url} $headers');
    http.Response utf = await http
        .get(Uri.parse(_server + url), headers: headers)
        .catchError((e) {
      FutureOr<http.Response> out = http.Response('nonet', 403);
      return out;
    });
    if (utf.statusCode == 403 && utf.body == 'nonet') {
      return {'status': false, "data": false};
    }
    debugPrint('body $url $utf');

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
      return {'status': false, "data": null};
    }
    // finally{
    //   debugPrint('finaly');
    //
    // }
  }

  Future<bool> httpDelete(String url) async {
    Map<String, String> headers = {
      // 'uuid': await deviceData(),
      // "Accept": "application/json",
      // "Access-Control_Allow_Origin": "*"
    };
    if (_access != null && _access != '') {
      headers['Authorization'] = 'Bearer $_access';
    }
    debugPrint('Get ${_server + url} $headers');
    http.Response utf = await http
        .delete(Uri.parse(_server + url), headers: headers)
        .catchError((e) {
      FutureOr<http.Response> out = http.Response('nonet', 403);
      return out;
    });
    if (utf.statusCode == 403 && utf.body == 'nonet') {
      return false;
    }
    debugPrint('body ${utf.body}');

    try {
      if (utf.statusCode == 201 ||
          utf.statusCode == 200 ||
          utf.statusCode == 204) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      debugPrint('cathc e $e');
      return false;
    }
    // finally{
    //   debugPrint('finaly');
    //
    // }
  }

  Future<Map<String, dynamic>> httpPostMulti(String url, FormData formData,
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
    Response utf = await dio
        .post(_server + url,
            options: Options(headers: {
              // 'Content-Type':'multipart/form-data',
              'Authorization': 'Bearer $_access'
            }),
            data: formData)
        .catchError((e) {
      debugPrint('post catchError $e');
      FutureOr<Response> out = Response(
          statusCode: 403,
          data: 'nonet',
          requestOptions: RequestOptions(path: ''));
      return out;
    });
    print('formData ${formData.fields}');

    debugPrint('Post ${_server + url} ${{
      // 'Content-Type':'multipart/form-data',
      'Authorization': 'Bearer $_access'
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
    if (utf.statusCode == 201 ||
        utf.statusCode == 200 ||
        utf.statusCode == 204) {
      return {'status': true, 'data': utf.data};
    } else {
      return {'status': false, 'error': utf.data['message']};
    }
  }

  Future<DataShortVideoStory?> createStory({//todo
    required XFile mediaURI,
    required String mimeType,
    String? caption,
    String? color,
    String? font,
    String? content,
  }) async {
    debugPrint('createShot()');
    Map<String, dynamic> map = {
      'mimeType': mimeType,
      'createdAt': DateTime.now().toString()
    };
    MultipartFile file =
        await MultipartFile.fromFile(mediaURI.path, filename: mediaURI.name);
    map['mediaURI'] = file;

    print('map $map');
    // return null;
    Map<String, dynamic> back =
        await httpPostMulti('/api/v1/VideoStory/create', FormData.fromMap(map));
    if(back['status']==false){
      toast(back['error']);
      return null;
    }
    debugPrint('back ${back}');
    return convertData(back['data'], 'data', DataType.clas,
        classType: 'DataShortVideoStory');
  }

  Future<List<DataStoryMain>> getStories() async {//todo
    debugPrint('getStories()');
    Map<String, dynamic> back = await httpGet('/api/v1/VideoStory/all/friends');
    debugPrint('backgetStories ${back}');
    if(back['status']==false){
      toast(back['error']);
      return [];
    }
    return convertDataList<DataStoryMain>(
        back['data'], 'data', 'DataStoryMain');
  }

  Future<List<DataStoryMain>> myStories() async {
    debugPrint('myStories()');
    Map<String, dynamic> back = await httpGet('/api/v1/VideoStory/all');
    debugPrint('backgmyStories ${back}');
    if(back['status']==false){
      toast(back['error']);
      return [];
    }
    return convertDataList<DataStoryMain>(
        back['data'], 'data', 'DataStoryMain');
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
