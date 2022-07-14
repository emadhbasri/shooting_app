import 'package:flutter/material.dart';

import '../../classes/functions.dart';
import '../../classes/models.dart';
import '../../classes/dataTypes.dart';

class ShareDialog extends StatelessWidget {
  final DataPost post;
  final bool canDelete;
  const ShareDialog({Key? key, required this.post,this.canDelete=false}) : super(key: key);
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
          color: Color(16777215),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            SizedBox(height: doubleHeight(4)),
            TextButton(
                onPressed: () {
                  sharePost('https://footballbuzz.co?shot=${post.id}');
                },
                child: Text(
                  'Share',
                  style: TextStyle(color: Colors.black),
                )),
            SizedBox(height: doubleHeight(1)),
            TextButton(
                onPressed: () {
                  copyText('check out the post https://footballbuzz.co?shot=${post.id}');
                },
                child: Text(
                  'Copy share link',
                  style: TextStyle(color: Colors.black),
                )),
            // SizedBox(height: doubleHeight(1)),
            // TextButton(
            //     onPressed: (){}, child: Text('Analyrics',style: TextStyle(
            //     color: Colors.black
            // ),)),
            if(canDelete)
            SizedBox(height: doubleHeight(1)),
            if(canDelete)
            TextButton(
              onPressed: () {
                Go.pop(context,post);
              },
              child:
                  Text('Delete this Shot', style: TextStyle(color: Colors.red)),
            ),
            SizedBox(height: doubleHeight(1)),
            SizedBox(
                width: double.maxFinite,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: doubleWidth(4)),
                  child: OutlinedButton(
                    style: ButtonStyle(
                        side: MaterialStateProperty.all(
                            BorderSide(color: mainBlue)),
                        padding: MaterialStateProperty.all(
                            EdgeInsets.symmetric(vertical: doubleHeight(2.5)))),
                    child: Text(
                      'back',
                      style: TextStyle(color: mainBlue),
                    ),
                    onPressed: () {
                      Go.pop(context);
                    },
                  ),
                )),
            SizedBox(height: doubleHeight(4)),
          ])),
    );
  }
}
