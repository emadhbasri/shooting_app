import 'package:flutter/material.dart';
import 'package:shooting_app/classes/states/main_state.dart';
import 'package:shooting_app/main.dart';
import 'package:shooting_app/pages/AppPage.dart';
import 'package:shooting_app/pages/auth/team.dart';

import '../../ui_items/my_toast.dart';
import '../functions.dart';
import '../models.dart';
import '../states/google_sign_in_state.dart';
import 'my_service.dart';
import 'package:device_info_plus/device_info_plus.dart' as dip;
import 'dart:io';

Future<String> deviceData() async {
  dip.DeviceInfoPlugin deviceInfo = dip.DeviceInfoPlugin();
  if (Platform.isIOS) {
    dip.IosDeviceInfo info = await deviceInfo.iosInfo;
    print('deviceData ${info.identifierForVendor}');
    return info.identifierForVendor!;
  } else {
    dip.AndroidDeviceInfo info = await deviceInfo.androidInfo;
    // print('deviceData ${info.id}');
    // print('deviceData ${info.type}');
    // print('deviceData ${info.androidId}');
    // print('deviceData ${info.hardware}');
    print('deviceData ${info.toMap()}');
    // print('deviceData ${info.id}');
    // print('deviceData ${info.id}');
    // print('deviceData ${info.id}');
    return info.id!;
  }
}

class DataRegisterGoogleRespone {
  final String? refreshToken, accessToken, userid, username, applicationUserId;
  final String? teamId;
  DataRegisterGoogleRespone(
      {required this.refreshToken,
      required this.accessToken,
      required this.userid,
      required this.username,
      required this.applicationUserId,
      required this.teamId});
}

class AuthenticationService {
  static deleteAccount(context) async {
    String? appId = await getString('applicationUserId');
    // print('appId $appId');
    // return;
    getIt<MyService>().httpDelete('/api/v1/Administration/deleteUser$appId');
    removeShare('refresh');
    removeShare('access');
    removeShare('date');
    MainState state = getIt<MainState>();
    state.personalInformation = null;
    state.match = null;
    state.newStories = null;
    state.storyViewed = null;
    state.isOnMatchPage = false;
    state.userId = '';
    state.userName = '';
    removeShare('userid');
    removeShare('username');
    removeShare('applicationUserId');
    Go.pushAndRemove(context, AppFirst());
  }

  static logOut(context) {
    getIt<MyService>().httpPost('/api/v1/Authentication/logout', {});
    removeShare('refresh');
    removeShare('access');
    removeShare('date');
    MainState state = getIt<MainState>();
    state.personalInformation = null;
    state.match = null;
    state.newStories = null;
    state.storyViewed = null;
    state.isOnMatchPage = false;
    state.userId = '';
    state.userName = '';
    removeShare('userid');
    removeShare('username');
    Go.pushAndRemove(context, AppFirst());
  }

  static Future registerWithGoogle(
      BuildContext context, MyService service, GlobalKey<MyToastState> key,
      {required DataSignIn user}) async {
    Map<String, dynamic> out = {
      "fullName": user.fullName,
      "userName": user.username,
      "profilePhoto": user.profilePhoto,
      "isOnline": true,
      'deviceId': await deviceData(),
      "email": user.email,
    };
    out['notificationToken'] = await messaging.getToken();
    print('registerWithGoogleOut $out');
    Map<String, dynamic> back = await service
        .httpPost('/api/v1/Authentication/ExternalLogin', out, jsonType: true);
    print('back ${back}');
    if (back['status'] == false) {
      if (back['data'] != false) myToast(key, back['error']);
      return false;
    }
    if (back['status'] &&
        back['data']['data'].containsKey('accessToken') == false) {
      myToast(key, back['data']['message']);
      return false;
    }
    // DataPersonalInformation pif =
    //     DataPersonalInformation.fromJson(back['data']['data']);

    if (back['data']['data'].containsKey('accessToken') &&
        back['data']['data'].containsKey('refreshToken') &&
        back['data']['data'].containsKey('id') &&
        back['data']['data'].containsKey('applicationUserId') &&
        back['data']['data'].containsKey('teamId')) {
      await service.setToken(
          refresh: back['data']['data']['refreshToken'],
          access: back['data']['data']['accessToken']);
      MainState state = getIt<MainState>();
      DataPersonalInformation pif =
          DataPersonalInformation.fromJson(back['data']['data']);
      state.userId = pif.id;
      state.userName = pif.userName;
      await setString('userid', pif.id);
      await setString('username', pif.userName);
      await setString('applicationUserId', pif.applicationUserId);

      DataRegisterGoogleRespone googleData = DataRegisterGoogleRespone(
          refreshToken: back['data']['data']['refreshToken'],
          accessToken: back['data']['data']['accessToken'],
          userid: back['data']['data']['id'],
          username: user.username,
          applicationUserId: back['data']['data']['applicationUserId'],
          teamId: back['data']['data']['teamId']);
      if (googleData.teamId != null) {
        Go.pushAndRemoveSlideAnim(context, AppPageBuilder());
      } else {
        Go.pushSlideAnim(context, Team());
      }
    } else {
      return false;
    }
  }

  static Future<bool> register(
    MyService service,
    GlobalKey<MyToastState> key,context, {
    required String fullName,
    required String userName,
    required String phoneNumber,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    debugPrint('register()');
    if (fullName.trim() == '') {
      myToast(key, AppLocalizations.of(context)!.the_fullName_field_is_required);
      return false;
    } else if (userName.trim() == '') {
      myToast(key, AppLocalizations.of(context)!.the_username_field_is_required);
      return false;
    }

    else if (email.trim() == '') {
      myToast(key, AppLocalizations.of(context)!.the_email_field_is_required);
      return false;
    } else if (password.trim() == '') {
      myToast(key, AppLocalizations.of(context)!.the_password_field_is_required);
      return false;
    }
    Map<String, dynamic> out = {
      "fullName": fullName.trim(),
      "userName": userName.trim(),
      "phoneNumber": phoneNumber.trim(),
      "is2FA": false,
      "isOnline": true,
      'deviceId': await deviceData(),
      "email": email.trim(),
      "password": password.trim(),
      "confirmPassword": confirmPassword.trim()
    };
    out['notificationToken'] = await messaging.getToken();
    print('outsssssss $out');
    Map<String, dynamic> back = await service
        .httpPost('/api/v1/Authentication/register', out, jsonType: true);
    if (back['status'] == false) {
      dynamic error = back['error'];
      if (error is Map && error.containsKey('email')) {
        myToast(key, error['email'].first);
      } else {
        myToast(key, error, isLong: true);

      }
      return false;
    }
    return back['status'];
    // await service.setToken(
    //     refresh: back['data']['data']['refreshToken'],
    //     access: back['data']['data']['accessToken']);
    // MainState state = getIt<MainState>();
    // DataPersonalInformation pif =
    //     DataPersonalInformation.fromJson(back['data']['data']);
    // state.userId = pif.id;
    // state.userName = pif.userName;
    // await setString('userid', pif.id);
    // await setString('username', pif.userName);
    // //The email field is required.
    // //
    // //The password field is required.
    // //The userName field is required.
    //
    // return back['status'];
  }

  static Future<bool?> login(
    MyService service,
    GlobalKey<MyToastState> key, {
    required String username,
    required String password,
  }) async {
    debugPrint('login()');
    Map<String, dynamic> out = {
      "user": username.trim(),
      "password": password.trim(),
      'deviceId': await deviceData(),
      "rememberMe": true
    };
    // out['notificationToken'] = 'test';
    out['notificationToken'] = await messaging.getToken();
    Map<String, dynamic> back = await service
        .httpPost('/api/v1/Authentication/login', out, jsonType: true);
    debugPrint('back ${back}');
    if (back['status'] == false) {
      myToast(key, back['error']);
      return null;
    }
    if (back['status'] &&
        back['data']['data'].containsKey('accessToken') == false) {
      myToast(key, back['data']['message']);
      return false;
    }

    await service.setToken(
        refresh: back['data']['data']['refreshToken'],
        access: back['data']['data']['accessToken']);

    MainState state = getIt<MainState>();
    DataPersonalInformation pif =
        DataPersonalInformation.fromJson(back['data']['data']);
    state.userId = pif.id;
    state.userName = pif.userName;
    await setString('userid', pif.id);
    await setString('username', pif.userName);
    await setString('applicationUserId', pif.applicationUserId);

    return back['status'];
  }

  static Future<bool> validateOtp(
    MyService service,
    GlobalKey<MyToastState> key, {
    required String user,
    required String oTP,
    required String password,
  }) async {
    debugPrint('validateOtp($user,$oTP,$password)');
    Map<String, dynamic> out = {
      "user": user.trim(),
      "password": password.trim(),
      "oTP": oTP.trim(),
      "rememberMe": true
    };
    // out['notificationToken'] = 'test';
    out['notificationToken'] = await messaging.getToken();
    print('outemd $out');
    Map<String, dynamic> back = await service
        .httpPost('/api/v1/Authentication/validateOtp', out, jsonType: true);
    print('validateOtp back $back');
    if (back['status'] == false) {
      myToast(key, back['error']);
      return back['status'];
    }
    await service.setToken(
        refresh: back['data']['data']['refreshToken'],
        access: back['data']['data']['accessToken']);

    MainState state = getIt<MainState>();
    DataPersonalInformation pif =
        DataPersonalInformation.fromJson(back['data']['data']);
    state.userId = pif.id;
    state.userName = pif.userName;
    await setString('userid', pif.id);
    await setString('username', pif.userName);
    await setString('applicationUserId', pif.applicationUserId);
    return back['status'];
  }

  static Future<bool> logout(
    MyService service,
  ) async {
    debugPrint('logout()');
    Map<String, dynamic> back =
        await service.httpPost('/api/v1/Authentication/logout', {});
    if (back['status'] == false) {
      toast(back['error']);
    }
    return back['status'];
  }

  static Future<bool> changeEmail(MyService service, String email) async {
    debugPrint('changeEmail($email)');
    Map<String, dynamic> back = await service.httpPost(
        '/api/v1/Administration/users/email/update', {'email': email},
        jsonType: true);
    debugPrint('changeEmail back ${back}');
    if (back['status'] == false) {
      toast(back['error']);
    }
    return back['status'];
  }

  static Future<bool> forgotPassword(
      MyService service, GlobalKey<MyToastState> key, String userName) async {
    debugPrint('forgotPassword($userName)');
    Map<String, dynamic> back = await service.httpPost(
        '/api/v1/Administration/forgotPassword', {'user': userName},
        jsonType: true);
    debugPrint('forgotPassword back ${back}');
    if (back['status'] == false) {
      myToast(key, back['error']);
    }
    myToast(key, back['data']['message'], isLong: true);
    return back['status'];
  }

  static Future<bool> resetPassword(MyService service, String userName,
      String password, String confirmPassword, String otp) async {
    debugPrint('resetPassword($userName)');
    Map<String, dynamic> back = await service.httpPost(
        '/api/v1/Administration/resetPassword',
        {
          "password": password,
          "user": userName,
          "confirmPassword": confirmPassword,
          "oTP": otp
        },
        jsonType: true);
    debugPrint('resetPassword back ${back}');
    if (back['status'] == false) {
      toast(back['error']);
      return false;
    }
    toast(back['data']['message'], isLong: true);
    return back['status'];
  }

  static Future<bool> changePhone(MyService service) async {
    debugPrint('changePhone(${getIt<MainState>().personalInformation!.email})');
    Map<String, dynamic> back = await service.httpPost(
        '/api/v1/Administration/users/UpdatePhoneRequest',
        {'email': getIt<MainState>().personalInformation!.email},
        jsonType: true);
    debugPrint('changePhone back ${back}');
    if (back['status'] == false) {
      toast(back['error']);
    }
    return back['status'];
  }

  static Future<bool> phoneVerify(MyService service,
      {required String phoneNumber, required String otp}) async {
    debugPrint('phoneVerify($phoneNumber,$otp)');
    Map<String, dynamic> back = await service.httpPost(
        '/api/v1/Administration/users/phone/update',
        {'oTP': otp, 'newPhoneNumber': phoneNumber},
        jsonType: true);
    debugPrint('phoneVerify back ${back}');
    if (back['status'] == false) {
      toast(back['error']);
    }
    return back['status'];
  }

  static Future<bool> changePassword(MyService service,
      {required String password,
      required String newPassword,
      required String newPasswordConfirm}) async {
    debugPrint('changePassword(($password,$newPassword,$newPasswordConfirm)');
    Map<String, dynamic> back = await service.httpPost(
        '/api/v1/Administration/users/password/update',
        {
          // 'id': getIt<MainState>().userId,
          'currentPassword': password,
          'newPassword': newPassword,
          'confirmPassword': newPasswordConfirm,
        },
        jsonType: true);
    debugPrint('changePassword( back ${back}');
    if (back['status'] == false) {
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
    if (back['status'] == false) {
      toast(back['error']);
    }
    return back['status'];
  }
}

myToast(GlobalKey<MyToastState> key, String message, {bool isLong = false}) {
  if (key.currentState != null) {
    key.currentState!
        .toastAnimate(message, duration: isLong ? Duration(seconds: 10) : null);
  }
}
