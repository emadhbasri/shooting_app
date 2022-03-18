import 'package:flutter/material.dart';

import '../../classes/functions.dart';
import '../../dataTypes.dart';



class Dialog1 extends StatelessWidget {
const Dialog1({Key? key}) : super(key: key);

Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
          color: Color(16777215),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: doubleHeight(4)),
            TextButton(
                onPressed: (){}, child: Text('Share',style: TextStyle(
              color: Colors.black
            ),)),
                SizedBox(height: doubleHeight(1)),
                TextButton(
                    onPressed: (){}, child: Text('Copy share link',style: TextStyle(
                    color: Colors.black
                ),)),
                SizedBox(height: doubleHeight(1)),
                TextButton(
                    onPressed: (){}, child: Text('Analyrics',style: TextStyle(
                    color: Colors.black
                ),)),
                SizedBox(height: doubleHeight(1)),
                TextButton(
                    onPressed: (){}, child: Text('Delete this Shot',
                    style: TextStyle(color: Colors.red)),),
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
                                EdgeInsets.symmetric(
                                    vertical: doubleHeight(2.5)))),
                        child: Text(
                          'Cancel',
                          style: TextStyle(color: mainBlue),
                        ),
                        onPressed: () {
                          Go.pop(context, false);
                        },
                      ),
                    )),
                SizedBox(height: doubleHeight(4)),
          ])),
    );
  }
}
