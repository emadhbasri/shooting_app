import 'package:shooting_app/classes/states/main_state.dart';

import '../../classes/services/my_service.dart';
import '../../classes/services/shots_service.dart';
import '../../main.dart';
import '../../pages/profile/profile.dart';
import '../dialogs/dialog1.dart';
import 'index.dart';

class CommentFromShot extends StatefulWidget {
  final VoidCallback delete;
  const CommentFromShot({Key? key, required this.comment, required this.delete})
      : super(key: key);
  final DataPostComment comment;
  @override
  _CommentFromShotState createState() => _CommentFromShotState();
}

class _CommentFromShotState extends State<CommentFromShot> {
  late DataPostComment comment;
  @override
  void initState() {
    super.initState();
    comment = widget.comment;
  }

  bool loading = false;
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(horizontal: doubleWidth(3)),
      child: Container(
        child: Column(
          children: <Widget>[
            ListTile(
              contentPadding: EdgeInsets.zero,
              dense: true,
              leading: SizedBox(
                width: doubleWidth(13),
                child: Stack(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                        onTap: () {
                          Go.pushSlideAnim(
                              context,
                              ProfileBuilder(
                                  username: comment
                                      .personalInformationViewModel.userName));
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: SizedBox(
                              width: doubleHeight(5),
                              height: doubleHeight(5),
                              child: Builder(
                                builder: (context) {
                                  if (comment.personalInformationViewModel
                                          .profilePhoto !=
                                      null) {
                                    return imageNetwork(
                                      comment.personalInformationViewModel
                                          .profilePhoto!,
                                      fit: BoxFit.fill,
                                    );
                                  }
                                  return profilePlaceHolder();
                                },
                              )),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment(1, -1),
                      child: SizedBox(
                        width: doubleHeight(3),
                        height: doubleHeight(3),
                        child: Container(
                          decoration: BoxDecoration(
                              color: white,
                              border: Border.all(color: white, width: 2),
                              borderRadius: BorderRadius.circular(100),
                              image:
                                  comment.personalInformationViewModel.team !=
                                          null
                                      ? DecorationImage(
                                          image: networkImage(comment
                                                  .personalInformationViewModel
                                                  .team!
                                                  .team_badge ??
                                              ''),
                                        )
                                      : null),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              title: Text(
                comment.personalInformationViewModel.fullName ?? '',
                style: TextStyle(
                    color: black,
                    fontWeight: FontWeight.bold,
                    fontSize: doubleWidth(3.5)),
              ),
              subtitle: Text(
                  '@${comment.personalInformationViewModel.userName}',
                  style: TextStyle(
                      color: grayCall,
                      fontWeight: FontWeight.bold,
                      fontSize: doubleWidth(2.5))),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(makeDurationToString(comment.createdAt),
                      style: TextStyle(
                          color: grayCall,
                          fontWeight: FontWeight.bold,
                          fontSize: doubleWidth(2.5))),
                  SizedBox(width: doubleWidth(4)),
                  GestureDetector(
                    onTap: () {
                      Go.pushSlideAnimSheet(
                          context, MyBottomSheetComment(widget.comment));
                    },
                    child: Container(
                      width: doubleWidth(6),
                      height: doubleWidth(5),
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(226, 224, 235, 1),
                          borderRadius: BorderRadius.circular(5)),
                      padding:
                      EdgeInsets.symmetric(horizontal: doubleWidth(0.8)),
                      child: Image.asset('assets/images/menu.png'),
                    ),
                  )
                ],
              ),
            ),
            sizeh(doubleHeight(1)),
            convertHashtag(comment.comment ?? '', (e) {}),
            sizeh(doubleHeight(1)),
            SizedBox(
              width: max,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      SizedBox(
                          width: doubleWidth(5),
                          height: doubleWidth(5),
                          child: Image.asset(
                            'assets/images/chat(2).png',
                            color: greenCall,
                          )),
                      sizew(doubleWidth(1)),
                      Text(makeCount(comment.commentReplies.length))
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () async {
                          MyService service = await getIt<MyService>();
                          if (!comment.commentLikedBythisUser) {
                            String? back = await ShotsService.commentLike(
                                service,
                                postCommentId: comment.id);
                            if (back != null) {
                              setState(() {
                                comment.commentLikes
                                    .add(DataCommentLike(back, ''));
                                comment.commentLikedBythisUser = true;
                                comment.commentLikeCount++;
                              });
                            }
                          } else {
                            if (comment.commentLikes.isNotEmpty) {
                              bool back = await ShotsService.deleteCommentLike(
                                  service,
                                  commentId: comment.commentLikes.first.id);
                              if (back)
                                setState(() {
                                  comment.commentLikes.clear();
                                  comment.commentLikedBythisUser = false;
                                  comment.commentLikeCount--;
                                });
                            }
                          }
                        },
                        child: Icon(
                            comment.commentLikedBythisUser
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: comment.commentLikedBythisUser
                                ? greenCall
                                : null),
                      ),
                      sizew(doubleWidth(1)),
                      Text(makeCount(comment.commentLikeCount)),
                    ],
                  ),
                  Tooltip(
                    message: 'remove the comment',
                    child: SizedBox(
                      width: doubleWidth(5),
                      height: doubleWidth(5),
                      child: GestureDetector(
                        onTap: () async {
                          if (comment.personalInformationId !=
                              getIt<MainState>().userId) {
                            toast('you can not delete this comment');
                            return;
                          }

                          bool? alert = await showDialog(
                            context: context,
                            barrierDismissible: true,
                            builder: (BuildContext dialogContext) {
                              return MyAlertDialog(
                                  content: 'Do you want to delete the shot?');
                            },
                          );
                          if (alert != null && alert) {
                            MyService service = await getIt<MyService>();
                            bool back = await ShotsService.deleteComment(
                                service,
                                commentId: comment.id);
                            if (back) widget.delete();
                          }
                        },
                        child: Icon(Icons.remove_circle_outline),
                      ),
                    ),
                  )
                ],
              ),
            ),
            sizeh(doubleHeight(1)),
            ...comment.commentReplies
                .map((e) => Padding(
                      padding: EdgeInsets.only(left: doubleWidth(4)),
                      child: CommentReply(
                          key: UniqueKey(),
                          reply: e,
                          delete: () {
                            int index = comment.commentReplies.indexOf(e);
                            List<DataCommentReply> temp =
                                comment.commentReplies.toList();
                            // temp.removeAt(index);

                            setState(() {
                              comment.commentReplies.remove(e);
                              // comment.commentReplies = temp.toList();
                            });
                          }),
                    ))
                .toList()
              ..add(Padding(
                padding: EdgeInsets.only(left: doubleWidth(8)),
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                      hintStyle:
                          TextStyle(color: Color.fromRGBO(214, 216, 217, 1)),
                      suffixIcon: GestureDetector(
                          onTap: () async {
                            if (loading || controller.value.text.trim() == '')
                              return;
                            setState(() {
                              loading = true;
                            });

                            DataCommentReply? back =
                                await ShotsService.commentReply(
                                    getIt<MyService>(),
                                    commentId: comment.id,
                                    reply: controller.value.text.trim());
                            setState(() {
                              loading = false;
                            });
                            if (back != null) {
                              setState(() {
                                comment.commentReplies.add(back);
                              });
                              controller.clear();
                            }
                          },
                          child: loading
                              ? Transform.scale(
                                  scale: 0.5,
                                  child: CircularProgressIndicator())
                              : Icon(
                                  Icons.send,
                                  color: mainBlue,
                                )),
                      hintText: 'Write your reply...',
                      border: InputBorder.none),
                ),
              )),
            Divider(
              color: grayCall,
            ),
          ],
        ),
      ),
    );
  }
}

class CommentFromMatch extends StatefulWidget {
  final VoidCallback delete;
  const CommentFromMatch(
      {Key? key, required this.comment, required this.delete})
      : super(key: key);
  final DataPostComment comment;
  @override
  _CommentFromMatchState createState() => _CommentFromMatchState();
}

class _CommentFromMatchState extends State<CommentFromMatch> {
  late DataPostComment comment;
  @override
  void initState() {
    super.initState();
    comment = widget.comment;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(horizontal: doubleWidth(3)),
      child: Container(
        child: Column(
          children: <Widget>[
            ListTile(
              contentPadding: EdgeInsets.zero,
              dense: true,
              leading: SizedBox(
                width: doubleWidth(13),
                child: Stack(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                        onTap: () {
                          Go.pushSlideAnim(
                              context,
                              ProfileBuilder(
                                  username: comment
                                      .personalInformationViewModel.userName));
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: SizedBox(
                              width: doubleHeight(5),
                              height: doubleHeight(5),
                              child: Builder(
                                builder: (context) {
                                  if (comment.personalInformationViewModel
                                          .profilePhoto !=
                                      null) {
                                    return imageNetwork(
                                      comment.personalInformationViewModel
                                          .profilePhoto!,
                                      fit: BoxFit.fill,
                                    );
                                  }
                                  return profilePlaceHolder();
                                },
                              )),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment(1, -1),
                      child: SizedBox(
                        width: doubleHeight(3),
                        height: doubleHeight(3),
                        child: Container(
                          decoration: BoxDecoration(
                              color: white,
                              border: Border.all(color: white, width: 2),
                              borderRadius: BorderRadius.circular(100),
                              image:
                                  comment.personalInformationViewModel.team !=
                                          null
                                      ? DecorationImage(
                                          image: networkImage(comment
                                                  .personalInformationViewModel
                                                  .team!
                                                  .team_badge ??
                                              ''),
                                        )
                                      : null),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              title: Text(
                comment.personalInformationViewModel.fullName ?? '',
                style: TextStyle(
                    color: black,
                    fontWeight: FontWeight.bold,
                    fontSize: doubleWidth(3.5)),
              ),
              subtitle: Text(
                  '@${comment.personalInformationViewModel.userName}',
                  style: TextStyle(
                      color: grayCall,
                      fontWeight: FontWeight.bold,
                      fontSize: doubleWidth(2.5))),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(makeDurationToString(comment.createdAt),
                      style: TextStyle(
                          color: grayCall,
                          fontWeight: FontWeight.bold,
                          fontSize: doubleWidth(2.5))),
                  SizedBox(width: doubleWidth(4)),
                  GestureDetector(
                    onTap: () {
                      Go.pushSlideAnimSheet(
                          context, MyBottomSheetComment(widget.comment));
                    },
                    child: Container(
                      width: doubleWidth(6),
                      height: doubleWidth(5),
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(226, 224, 235, 1),
                          borderRadius: BorderRadius.circular(5)),
                      padding:
                      EdgeInsets.symmetric(horizontal: doubleWidth(0.8)),
                      child: Image.asset('assets/images/menu.png'),
                    ),
                  )
                ],
              ),
            ),
            sizeh(doubleHeight(1)),
            convertHashtag(comment.comment ?? '', (e) {}),
            sizeh(doubleHeight(1)),
            SizedBox(
              width: max,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      SizedBox(
                          width: doubleWidth(5),
                          height: doubleWidth(5),
                          child: Image.asset('assets/images/chat(2).png',
                              color: greenCall)),
                      sizew(doubleWidth(1)),
                      // Text(makeCount(comment.commentReplyCount))
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () async {
                          MyService service = await getIt<MyService>();
                          if (!comment.commentLikedBythisUser) {
                            String? back = await ShotsService.commentLike(
                                service,
                                postCommentId: comment.id);
                            if (back != null)
                              setState(() {
                                comment.commentLikes
                                    .add(DataCommentLike(back, ''));
                                comment.commentLikedBythisUser = true;
                                comment.commentLikeCount++;
                              });
                          } else {
                            bool back = await ShotsService.deleteCommentLike(
                                service,
                                commentId: comment.commentLikes.first.id);
                            if (back)
                              setState(() {
                                comment.commentLikes.clear();
                                comment.commentLikedBythisUser = false;
                                comment.commentLikeCount--;
                              });
                          }
                        },
                        child: Icon(
                            comment.commentLikedBythisUser
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: comment.commentLikedBythisUser
                                ? greenCall
                                : null),
                      ),
                      sizew(doubleWidth(1)),
                      Text(makeCount(comment.commentLikeCount))
                    ],
                  ),
                  Tooltip(
                    message: 'remove the comment',
                    child: SizedBox(
                      width: doubleWidth(5),
                      height: doubleWidth(5),
                      child: GestureDetector(
                        onTap: () async {
                          if (comment.personalInformationId !=
                              getIt<MainState>().userId) {
                            toast('you can not delete this comment');
                            return;
                          }
                          bool? alert = await showDialog(
                            context: context,
                            barrierDismissible: true,
                            builder: (BuildContext dialogContext) {
                              return MyAlertDialog(
                                  content: 'Do you want to delete the shot?');
                            },
                          );
                          if (alert != null && alert) {
                            MyService service = await getIt<MyService>();
                            bool back = await ShotsService.deleteComment(
                                service,
                                commentId: comment.id);
                            if (back) widget.delete();
                          }
                        },
                        child: Icon(Icons.remove_circle_outline),
                      ),
                    ),
                  )
                ],
              ),
            ),
            sizeh(doubleHeight(1)),
            Divider(
              color: grayCall,
            ),
          ],
        ),
      ),
    );
  }
}
