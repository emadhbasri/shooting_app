import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shooting_app/classes/states/main_state.dart';
import 'package:shooting_app/main.dart';

import '../functions.dart';
import '../models.dart';
import 'my_service.dart';

class AuthenticationService {
  static logOut(context) {
    removeShare('refresh');
    removeShare('access');
    MainState state = getIt<MainState>();
    state.userId = '';
    state.userName = '';
    removeShare('userid');
    removeShare('username');
    Go.pushAndRemove(context, AppFirst());
  }

  static Future<bool> register(
    MyService service, {
    required String fullName,
    required String userName,
    required String phoneNumber,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    debugPrint('register()');
    if (fullName == '') {
      toast('The fullName field is required.');
      return false;
    } else if (userName == '') {
      toast('The userName field is required.');
      return false;
    } else if (phoneNumber == '') {
      toast('The phoneNumber field is required.');
      return false;
    } else if (email == '') {
      toast('The email field is required.');
      return false;
    } else if (password == '') {
      toast('The password field is required.');
      return false;
    }
    Map<String, dynamic> out = {
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
    out['notificationToken'] = 'test';
    // out['notificationToken'] = await messaging.getToken();
    Map<String, dynamic> back = await service
        .httpPost('/api/v1/Authentication/register', out, jsonType: true);
    if (back['status'] == false) {
      dynamic error = back['error'];
      if (error is Map && error.containsKey('email')) {
        toast(error['email'].first);
      } else {
        toast(error, duration: Toast.LENGTH_LONG);
      }
      return false;
    }
    await service.setToken(
        refresh: back['data']['data']['refreshToken'],
        access: back['data']['data']['accessToken']);
    MainState state = getIt<MainState>();
    DataPersonalInformation pif =
        DataPersonalInformation.fromJson(back['data']['data']);
    state.userId = pif.id;
    state.userName = pif.userName!;
    await setString('userid', pif.id);
    await setString('username', pif.userName!);
    //The email field is required.
    //
    //The password field is required.
    //The userName field is required.

    return back['status'];
  }

  static Future<bool> login(
    MyService service, {
    required String username,
    required String password,
  }) async {
    debugPrint('login()');
    Map<String, dynamic> out = {
      "user": username,
      "password": password,
      "rememberMe": true
    };
    out['notificationToken'] = 'test';
    // out['notificationToken'] = await messaging.getToken();
    Map<String, dynamic> back = await service
        .httpPost('/api/v1/Authentication/login', out, jsonType: true);
    debugPrint('back ${back}');
    if(back['status']==false){
      toast(back['error']);
      return false;
    }
    await service.setToken(
        refresh: back['data']['data']['refreshToken'],
        access: back['data']['data']['accessToken']);

    MainState state = getIt<MainState>();
    DataPersonalInformation pif =
        DataPersonalInformation.fromJson(back['data']['data']);
    state.userId = pif.id;
    state.userName = pif.userName!;
    await setString('userid', pif.id);
    await setString('username', pif.userName!);

    return back['status'];
  }

  static Future<bool> validateOtp(
    MyService service, {
    required String user,
    required String oTP,
    required String password,
  }) async {
    debugPrint('validateOtp()');
    Map<String, dynamic> out = {
      "user": user,
      "password": password,
      "oTP": oTP,
      "rememberMe": true
    };
    out['notificationToken'] = 'test';
    // out['notificationToken'] = await messaging.getToken();
    Map<String, dynamic> back =
        await service.httpPost('/api/v1/Authentication/validateOtp', out);
    if(back['status']==false){
      toast(back['error']);
    }
    return back['status'];
  }

  static Future<bool> logout(
    MyService service,
  ) async {
    debugPrint('logout()');
    Map<String, dynamic> back =
        await service.httpPost('/api/v1/Authentication/logout', {});
    if(back['status']==false){
      toast(back['error']);
    }
    return back['status'];
  }

  static Future<bool> changePhone(MyService service, String phoneNumber) async {
    debugPrint('changePhone($phoneNumber)');
    Map<String, dynamic> back = await service.httpPost(
        '/api/v1/Administration/users/UpdatePhoneRequest',
        {'phoneNumber': phoneNumber},
        jsonType: true);
    debugPrint('changePhone back ${back}');
    if(back['status']==false){
      toast(back['error']);
    }
    return back['status'];
  }
  static Future<bool> phoneVerify(MyService service,
      {required String phoneNumber,required String otp}) async {
    debugPrint('phoneVerify($phoneNumber,$otp)');
    Map<String, dynamic> back = await service.httpPost(
        '/api/v1/Administration/users/phone/update',
        {'oTP': otp, 'newPhoneNumber': phoneNumber},
        jsonType: true);
    debugPrint('phoneVerify back ${back}');
    if(back['status']==false){
      toast(back['error']);
    }
    return back['status'];
  }

  static Future<bool> changePassword(MyService service,
      {required String password,required String newPassword,required String newPasswordConfirm}) async {
    debugPrint('changePassword(($password,$newPassword,$newPasswordConfirm)');
    Map<String, dynamic> back = await service.httpPost(
        '/api/v1/Administration/users/password/update',
        {
          // 'id': getIt<MainState>().userId,
          'currentPassword':password,
          'newPassword':newPassword,
          'confirmPassword':newPasswordConfirm,
        },
        jsonType: true);
    debugPrint('changePassword( back ${back}');
    if(back['status']==false){
      toast(back['error']);
    }
    return back['status'];
  }

  static Future<bool> change2FA(MyService service,
      {required bool is2FA}) async {
    debugPrint('change2FA($is2FA)');
    Map<String, dynamic> back = await service.httpPatch(
        '/api/v1/Administration/update2FA'
            '?userId=${getIt<MainState>().userId}',
        {'is2FA': is2FA},
        jsonType: true);
    debugPrint('change2FA back ${back}');
    if(back['status']==false){
      toast(back['error']);
    }
    return back['status'];
  }

}
