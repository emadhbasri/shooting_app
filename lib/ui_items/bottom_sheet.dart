import 'package:flutter/material.dart';
import 'package:shooting_app/classes/dataTypes.dart';

import '../classes/functions.dart';
import '../classes/models.dart';
import 'report_sheet.dart';

class MyBottomSheet extends StatelessWidget {
  const MyBottomSheet(this.post, {Key? key}) : super(key: key);
  final DataPost post;
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
              // ListTile(
              //   title: Text('Engagement'),
              //   subtitle: Text(post.engagement.toString()),
              // ),
              ListTile(
                title: Text('Reach'),
                subtitle: Text(post.reach.toString()),
              ),
              ListTile(
                title: Text('Replies'),
                subtitle: Text(post.postCommentCount.toString()),
              ),
              // ListTile(
              //   title: Text('Shares'),
              //   subtitle: Text(post.shares.toString()),
              // ),
              ListTile(
                title: Text('Likes'),
                subtitle: Text(post.postLikeCount.toString()),
              ),
              ListTile(
                title: Text('Profile Clicks'),
                subtitle: Text(post.profileClicks.toString()),
              ),
              SizedBox(
                  width: double.maxFinite,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: doubleWidth(4)),
                    child: OutlinedButton(
                      style: ButtonStyle(
                          side: MaterialStateProperty.all(
                              BorderSide(color: Colors.red)),
                          padding: MaterialStateProperty.all(
                              EdgeInsets.symmetric(
                                  vertical: doubleHeight(2.5)))),
                      child: Text(
                        'Report',
                        style: TextStyle(color: Colors.red),
                      ),
                      onPressed: () {
                        Go.pushSlideAnimSheet(
                            context, ReportSheet(post));
                        // Go.pop(context);
                      },
                    ),
                  )),

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
