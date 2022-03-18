import 'package:flutter/material.dart';
import 'package:shooting_app/dataTypes.dart';

import '../classes/functions.dart';

class MyBottomSheet extends StatelessWidget {
  const MyBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Material(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20), topLeft: Radius.circular(20)),
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: doubleHeight(4)),
              ListTile(
                title: Text('Engagement'),
                subtitle: Text('800'),
              ),
              ListTile(
                title: Text('Reach'),
                subtitle: Text('1000'),
              ),
              ListTile(
                title: Text('Replies'),
                subtitle: Text('721'),
              ),
              ListTile(
                title: Text('Shares'),
                subtitle: Text('225'),
              ),
              ListTile(
                title: Text('Likes'),
                subtitle: Text('62'),
              ),
              ListTile(
                title: Text('Profile Clicks'),
                subtitle: Text('5'),
              ),
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
                        Go.pop(context);
                      },
                    ),
                  )),
              SizedBox(height: doubleHeight(4)),
            ],
          ),
        ),
      ),
    );
  }
}
