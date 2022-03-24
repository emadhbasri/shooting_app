
import 'package:flutter/material.dart';
import 'package:shooting_app/classes/states/main_state.dart';
import 'package:shooting_app/main.dart';

import '../functions.dart';
import '../models.dart';
import 'my_service.dart';
class AuthenticationService{
  static logOut(context){
    removeShare('refresh');
    removeShare('access');
    MainState state = getIt<MainState>();
    state.userId='';
    state.userName='';
    removeShare('userid');
    removeShare('username');
    Go.pushAndRemove(context, AppFirst());
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
