import 'package:flutter/material.dart';
import 'package:shooting_app/classes/dataTypes.dart';

import '../../classes/functions.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
MyAlertDialog(context, {String? title, String? content})async{
  return await Alert(
    context: context,
    type: AlertType.warning,
    title: title,
    desc: content,
    padding: EdgeInsets.symmetric(
      horizontal: doubleWidth(4)
    ).copyWith(
        top: doubleHeight(3)
    ),
    style: AlertStyle(
      animationType: AnimationType.grow,
      isCloseButton: false,
      overlayColor: Colors.black.withOpacity(0.5)
    ),
    buttons: [
      DialogButton(
        child: Text(
          'NO',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        onPressed: () => Go.pop(context,false),
        color: pink,
      ),
      DialogButton(
        child: Text(
          "YES",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        onPressed: (){
          Go.pop(context,true);
        },
        color: mainGreen1,
      )
    ],
  ).show();
}
// class MyAlertDialog extends StatelessWidget {
//   const MyAlertDialog({Key? key,this.title='',required this.content}) : super(key: key);
//   final String title;
//   final String content;
//   Widget build(BuildContext context) {
//
//     return const SizedBox();
//     return AlertDialog(
//       title: title==''?null:Text(title),
//       content: Text(content),
//       actions: [
//         TextButton(
//           child: Text('no'),
//           onPressed: (){
//             Go.pop(context,false);
//           },
//         ),
//         TextButton(
//           child: Text('yes'),
//           onPressed: (){
//             Go.pop(context,true);
//           },
//         ),
//       ],
//     );
//   }
// }
