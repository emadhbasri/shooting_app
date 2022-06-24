import 'package:flutter/material.dart';
import 'package:shooting_app/classes/dataTypes.dart';
import 'package:shooting_app/classes/states/main_state.dart';

import '../classes/functions.dart';
import '../classes/models.dart';
import '../main.dart';
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
              if(post.person!=null && post.person!.userName==getIt<MainState>().userName)
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
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
                            'Edit',
                            style: TextStyle(color: mainBlue),
                          ),
                          onPressed: () {

                          },
                        ),
                      )),
                  SizedBox(height: doubleHeight(1)),
                ],
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
                            context, ReportSheet(post:post));
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
class MyBottomSheetComment extends StatelessWidget {
  const MyBottomSheetComment(this.comment, {Key? key}) : super(key: key);
  final DataPostComment comment;
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
              //   subtitle: Text(comment.engagement.toString()),
              // ),
              // ListTile(
              //   title: Text('Reach'),
              //   subtitle: Text(comment.reach.toString()),
              // ),
              ListTile(
                title: Text('Replies'),
                subtitle: Text(comment.commentReplyCount.toString()),
              ),
              // ListTile(
              //   title: Text('Shares'),
              //   subtitle: Text(post.shares.toString()),
              // ),
              ListTile(
                title: Text('Likes'),
                subtitle: Text(comment.commentLikeCount.toString()),
              ),
              // ListTile(
              //   title: Text('Profile Clicks'),
              //   subtitle: Text(comment.profileClicks.toString()),
              // ),
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
                            context, ReportSheet(comment:comment));
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
class MyBottomSheetReply extends StatelessWidget {
  const MyBottomSheetReply(this.reply, {Key? key}) : super(key: key);
  final DataCommentReply reply;
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
              // ListTile(
              //   title: Text('Reach'),
              //   subtitle: Text(reply.reach.toString()),
              // ),
              // ListTile(
              //   title: Text('Replies'),
              //   subtitle: Text(reply.postCommentCount.toString()),
              // ),
              // ListTile(
              //   title: Text('Shares'),
              //   subtitle: Text(reply.shares.toString()),
              // ),
              ListTile(
                title: Text('Likes'),
                subtitle: Text(reply.replyLikeCount.toString()),
              ),
              // ListTile(
              //   title: Text('Profile Clicks'),
              //   subtitle: Text(reply.profileClicks.toString()),
              // ),
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
                            context, ReportSheet(reply: reply,));
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
