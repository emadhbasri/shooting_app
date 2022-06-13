import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

import '../../classes/functions.dart';

class ChooseSharingWay extends StatelessWidget {
  const ChooseSharingWay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),

      child: Container(
        margin: EdgeInsets.all(doubleWidth(4)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            Center(
              child: Text('Please Pick a Way',style: Theme.of(context).textTheme.titleLarge ),
            ),
            SizedBox(height: doubleHeight(2)),

            Container(
              decoration: BoxDecoration(
                border: Border.all(width: 1,color: Colors.black),
                borderRadius: BorderRadius.circular(5),
              ),
              child: ListTile(
                onTap: ()async{
                  Go.pop(context,'shot');
                },
                title: Text('Make New Shot'),
                trailing: SizedBox(
                    width: 24,
                    height: 24,
                    child: Image.asset('assets/images/soccer.png')),
              ),
            ),SizedBox(height: doubleHeight(1)),
            Container(
              decoration: BoxDecoration(
                border: Border.all(width: 1,color: Colors.black),
                borderRadius: BorderRadius.circular(5),
              ),
              child: ListTile(
                onTap: ()async{
                  Go.pop(context,'chat');
                },
                title: Text('Send to Group/Chat'),
                trailing: SizedBox(
                    width: 24,
                    height: 24,
                    child: Image.asset('assets/images/chat.png')),
              ),
            ),

            SizedBox(height: doubleHeight(1)),
          ],
        ),
      ),
    );
  }
}
