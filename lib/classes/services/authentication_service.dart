
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
    if(fullName==''){
      toast('The fullName field is required.');
      return false;
    }else if(userName==''){
      toast('The userName field is required.');
      return false;
    }else if(phoneNumber==''){
      toast('The phoneNumber field is required.');
      return false;
    }else if(email==''){
      toast('The email field is required.');
      return false;
    }else if(password==''){
      toast('The password field is required.');
      return false;
    }
    Map<String,dynamic> out = {
      "fullName": fullName,
      "userName": userName,
      "phoneNumber": phoneNumber,
      "notificationToken": "string",
      "is2FA": false,
      "isOnline": true,
      "email": email,
      "password": password,
      "confirmPassword": confirmPassword
    };
    out['notificationToken']=await messaging.getToken();
    Map<String, dynamic> back = await service.httpPost('/api/v1/Authentication/register', out,jsonType: true);
    if(back['status']==false){
      dynamic error = back['error'];
      if(error is Map && error.containsKey('email')){
        toast(error['email'].first);
      }else{
        toast(error,duration: Toast.LENGTH_LONG);
      }
      return false;
    }
    await service.setToken(refresh: back['data']['data']['refreshToken'], access: back['data']['data']['accessToken']);
    MainState state = getIt<MainState>();
    DataPersonalInformation pif = DataPersonalInformation.fromJson(back['data']['data']);
    state.userId=pif.id;
    state.userName=pif.userName!;
    await setString('userid', pif.id);
    await setString('username', pif.userName!);
    //The email field is required.
    //
    //The password field is required.
    //The userName field is required.
    return back['status'];
  }

  static Future<bool> login(MyService service,{
    required String username,
    required String password,
  }) async {
    debugPrint('login()');
    Map<String,dynamic> out = {
      "user": username,
      "password": password,
      "rememberMe": true
    };
    out['notificationToken']=await messaging.getToken();
    Map<String, dynamic> back = await service.httpPost('/api/v1/Authentication/login', out,jsonType: true);
    debugPrint('back ${back}');
    await service.setToken(refresh: back['data']['data']['refreshToken'], access: back['data']['data']['accessToken']);
    MainState state = getIt<MainState>();
    DataPersonalInformation pif = DataPersonalInformation.fromJson(back['data']['data']);
    state.userId=pif.id;
    state.userName=pif.userName!;
    await setString('userid', pif.id);
    await setString('username', pif.userName!);
    return back['status'];
  }

  static Future<bool> validateOtp(MyService service,{
    required String user,
    required String oTP,
    required String password,
  }) async {
    debugPrint('validateOtp()');
    Map<String,dynamic> out = {
      "user": user,
      "password": password,
      "oTP": oTP,
      "rememberMe": true
    };
    out['notificationToken']=await messaging.getToken();
    Map<String, dynamic> back = await service.httpPost('/api/v1/Authentication/validateOtp', out);
    return back['status'];
  }

  static Future<bool> logout(MyService service,) async {
    debugPrint('logout()');
    Map<String, dynamic> back = await service.httpPost('/api/v1/Authentication/logout',{});
    return back['status'];
  }
}
