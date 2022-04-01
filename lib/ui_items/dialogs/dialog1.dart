import 'package:flutter/material.dart';

import '../../classes/functions.dart';

class MyAlertDialog extends StatelessWidget {
  const MyAlertDialog({Key? key,this.title='Alert',required this.content}) : super(key: key);
  final String title;
  final String content;
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          child: Text('no'),
          onPressed: (){
            Go.pop(context,false);
          },
        ),
        TextButton(
          child: Text('yes'),
          onPressed: (){
            Go.pop(context,true);
          },
        ),
      ],
    );
  }
}
