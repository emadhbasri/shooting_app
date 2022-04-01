import 'package:flutter/material.dart';
import 'package:shooting_app/classes/dataTypes.dart';

import '../../../classes/functions.dart';
import '../../../classes/services/authentication_service.dart';

class ChangeEmailDone extends StatefulWidget {
  final String email;

  const ChangeEmailDone({Key? key,required this.email}) : super(key: key);

  @override
  State<ChangeEmailDone> createState() => _ChangeEmailDoneState();
}

class _ChangeEmailDoneState extends State<ChangeEmailDone> {



  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        return false;
      },
      child: Scaffold(
        appBar: AppBar(elevation: 0, title: Text('Change Email'),automaticallyImplyLeading: false),
        backgroundColor: Color.fromRGBO(247, 247, 247, 1),
        body: SizedBox.expand(
            child: Padding(
          padding: EdgeInsets.symmetric(horizontal: doubleWidth(4)),
          child: Column(children: [
            SizedBox(height: doubleHeight(6)),
            Text(
              'A link has been sent to\n${widget.email}',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: doubleHeight(2)),
            Text(
              'Check your email to verify these changes',
              style: TextStyle(color: grayCall),
            ),
            SizedBox(height: doubleHeight(8)),
            // SizedBox(
            //     width: double.maxFinite,
            //     child: Padding(
            //       padding: EdgeInsets.symmetric(horizontal: doubleWidth(4)),
            //       child: OutlinedButton(
            //         style: ButtonStyle(
            //             side: MaterialStateProperty.all(
            //                 BorderSide(color: mainBlue)),
            //             padding: MaterialStateProperty.all(
            //                 EdgeInsets.symmetric(vertical: doubleHeight(2.5)))),
            //         child: Text(
            //           'Back to Profile',
            //           style: TextStyle(color: mainBlue),
            //         ),
            //         onPressed: () {
            //           Go.pop(context);
            //         },
            //       ),
            //     )),
          ]),
        )),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 5),(){
      AuthenticationService.logOut(context);
    });
  }
}
