import 'package:flutter/material.dart';
import 'package:shooting_app/classes/dataTypes.dart';
import 'package:shooting_app/classes/states/main_state.dart';
import 'package:shooting_app/pages/shoot/edit_comment.dart';
import 'package:shooting_app/pages/shoot/edit_reply.dart';
import 'package:shooting_app/pages/shoot/edit_shoot.dart';

import '../classes/functions.dart';
import '../classes/models.dart';
import '../classes/states/theme_state.dart';
import '../main.dart';
import 'report_sheet.dart';
import 'package:provider/provider.dart';
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
          color: context.watch<ThemeState>().isDarkMode
              ? Color.fromRGBO(20, 20, 20, 1)
              : MyThemes.lightTheme.scaffoldBackgroundColor,
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
              //   subtitle: Text(post.reach.toString()),
              // ),
              // ListTile(
              //   title: Text('Replies'),
              //   subtitle: Text(post.postCommentCount.toString()),
              // ),
              // // ListTile(
              // //   title: Text('Shares'),
              // //   subtitle: Text(post.shares.toString()),
              // // ),
              // ListTile(
              //   title: Text('Likes'),
              //   subtitle: Text(post.postLikeCount.toString()),
              // ),
              // ListTile(
              //   title: Text('Profile Clicks'),
              //   subtitle: Text(post.profileClicks.toString()),
              // ),
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
                        'Copy Link',
                        style: TextStyle(color: mainBlue),
                      ),
                      onPressed: () {
                        copyText('https://footballbuzz.co?shot=${post.id}');
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
                        'Share...',
                        style: TextStyle(color: mainBlue),
                      ),
                      onPressed: () {
                        sharePost('https://footballbuzz.co?shot=${post.id}');
                      },
                    ),
                  )),
              SizedBox(height: doubleHeight(1)),
              if (post.person != null &&
                  post.person!.userName == getIt<MainState>().userName)
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                        width: double.maxFinite,
                        child: Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: doubleWidth(4)),
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
                            onPressed: () async{
                              DataPost? back = await Go.pushSlideAnimSheet(context, EditShoot(
                                  post: post,
                              ));
                              if(back!=null){
                                Go.pop(context,back);
                              }
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
                        Go.pushSlideAnimSheet(context, ReportSheet(post: post));
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
          color: context.watch<ThemeState>().isDarkMode
              ? Color.fromRGBO(20, 20, 20, 1)
              : MyThemes.lightTheme.scaffoldBackgroundColor,
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
              // ListTile(
              //   title: Text('Replies'),
              //   subtitle: Text(comment.commentReplyCount.toString()),
              // ),
              // ListTile(
              //   title: Text('Shares'),
              //   subtitle: Text(post.shares.toString()),
              // ),
              // ListTile(
              //   title: Text('Likes'),
              //   subtitle: Text(comment.commentLikeCount.toString()),
              // ),
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
                              BorderSide(color: mainBlue)),
                          padding: MaterialStateProperty.all(
                              EdgeInsets.symmetric(
                                  vertical: doubleHeight(2.5)))),
                      child: Text(
                        'Copy Link',
                        style: TextStyle(color: mainBlue),
                      ),
                      onPressed: () {
                        copyText('https://footballbuzz.co?shot=${comment.postId}');
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
                        'Share...',
                        style: TextStyle(color: mainBlue),
                      ),
                      onPressed: () {
                        sharePost('https://footballbuzz.co?shot=${comment.postId}');
                      },
                    ),
                  )),
              SizedBox(height: doubleHeight(1)),
              if (comment.personalInformationId == getIt<MainState>().userId)
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                        width: double.maxFinite,
                        child: Padding(
                          padding:
                          EdgeInsets.symmetric(horizontal: doubleWidth(4)),
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
                            onPressed: () async{
                              DataPostComment? back = await Go.pushSlideAnimSheet(context, EditComment(
                                comment: comment,
                              ));
                              if(back!=null){
                                Go.pop(context,back);
                              }
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
                            context, ReportSheet(comment: comment));
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
  final String shotId;
  const MyBottomSheetReply(this.reply,this.shotId, {Key? key}) : super(key: key);
  final DataCommentReply reply;
  @override
  Widget build(BuildContext context) {

    return SizedBox.expand(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Material(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20), topLeft: Radius.circular(20)),
          color: context.watch<ThemeState>().isDarkMode
              ? Color.fromRGBO(20, 20, 20, 1)
              : MyThemes.lightTheme.scaffoldBackgroundColor,
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
              // ListTile(
              //   title: Text('Likes'),
              //   subtitle: Text(reply.replyLikeCount.toString()),
              // ),
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
                              BorderSide(color: mainBlue)),
                          padding: MaterialStateProperty.all(
                              EdgeInsets.symmetric(
                                  vertical: doubleHeight(2.5)))),
                      child: Text(
                        'Copy Link',
                        style: TextStyle(color: mainBlue),
                      ),
                      onPressed: () {
                        copyText('https://footballbuzz.co?shot=${shotId}');
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
                        'Share...',
                        style: TextStyle(color: mainBlue),
                      ),
                      onPressed: () {
                        sharePost('https://footballbuzz.co?shot=${shotId}');
                      },
                    ),
                  )),
              SizedBox(height: doubleHeight(1)),
              if (reply.personalInformationId == getIt<MainState>().userId)
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                        width: double.maxFinite,
                        child: Padding(
                          padding:
                          EdgeInsets.symmetric(horizontal: doubleWidth(4)),
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
                            onPressed: () async{
                              DataCommentReply? back = await Go.pushSlideAnimSheet(context, EditReply(
                                reply: reply,
                              ));
                              if(back!=null){
                                Go.pop(context,back);
                              }
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
                            context,
                            ReportSheet(
                              reply: reply,
                            ));
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
