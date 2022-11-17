import 'dart:io';

import 'package:shooting_app/classes/services/authentication_service.dart';
import 'package:shooting_app/classes/services/my_service.dart';
import 'package:shooting_app/main.dart';
import 'package:shooting_app/pages/AppPage.dart';
import 'package:shooting_app/ui_items/shots/index.dart';

import 'auth/auth.dart';

class Intro1 extends StatefulWidget {
  @override
  State<Intro1> createState() => _Intro1State();
}

class _Intro1State extends State<Intro1> with SingleTickerProviderStateMixin{
  late AnimationController _controller;



  init()async{
    _controller=AnimationController(
      vsync: this,value: 0,duration: Duration(milliseconds: 500),reverseDuration: Duration(milliseconds: 500)
    );
    _controller.forward();
    _controller.addStatusListener((status) {
      if(status==AnimationStatus.completed)
        _controller.reverse();
      else if(status==AnimationStatus.dismissed)
        _controller.forward();
    });
    
    MyService service = getIt<MyService>();
    service.getToken().then((bool value) async{
      if (value) {
        String? userName = await getString('username');
        if(userName==null){
          Go.pushAndRemoveSlideAnim(context, Auth());
          return;
        }

        // Go.pushAndRemoveSlideAnim(context, AppPageBuilder(update:false,));
// return;

        await getVersion(service,userName);
        await getDevice(service,userName);
        if(login==true){
          AuthenticationService.logOut(context);
          // Go.pushAndRemoveSlideAnim(context, Auth());
          return;
        }else{
          Go.pushAndRemoveSlideAnim(context, AppPageBuilder(update: update??false,));
          return;
        }
        // Future.delayed(Duration(seconds: 2),
        //         () {
        //           _controller.stop();
        //           _controller.dispose();
      // });
      } else {
        Future.delayed(
            Duration(seconds: 2), ()
        {
          _controller.stop();
          _controller.dispose();
        Go.pushAndRemoveSlideAnim(context, Auth());
        }
        );
      }
    });
  }

  bool? update,login;

  getVersion(MyService service,String userName)async{
    debugPrint('getVersion()');
    String out = '';
    if(Platform.isAndroid){
      out='androidVersion=24';
    }else{
      out='iosVersion=24';
    }
    var back =
    await service.httpPost('/api/v1/Authentication/CheckVersion?'
        '$out&username=$userName', {});
    print('back getVersion $back');
    if(back['data']['message'].toString()=="Update : true"){
      print('getVersiongetVersion true');
      update=true;
    }else{
      print('getVersiongetVersion false');
      update=false;
    }
  }
  getDevice(MyService service,String userName)async{
    debugPrint('getDevice()');
    String deviceId= await deviceData();
    var back =
    await service.httpPost('/api/v1/Authentication/Config?'
        'deviceId=$deviceId&username=$userName', {});
    print('back2 $back');
    if(back['data']['message'].toString()=="Login : true"){
      login=true;
    }else{
      login=false;
    }
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(50, 255, 185, 1),
      body: Center(
        child: ScaleTransition(
          scale: Tween<double>(begin: 1,end: 0.7).animate(_controller),
          child:
          // CircleAvatar(
          //   backgroundImage: AssetImage('assets/images/appicon.png'),
          //   radius: 70,
          // )
          SizedBox(
            width: doubleWidth(30),
            height: doubleWidth(30),
            child: Image.asset('assets/images/appicon.png',fit: BoxFit.fill,),
          ),
        ),
      ),
    );
  }
}
