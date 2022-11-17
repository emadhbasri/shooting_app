import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shooting_app/classes/states/main_state.dart';
import 'package:video_player/video_player.dart';

import '../../classes/services/my_service.dart';
import '../../classes/services/shots_service.dart';
import '../../classes/states/theme_state.dart';
import '../../main.dart';
import '../../pages/profile/profile.dart';
import '../../pages/shoot/search_user_mention.dart';
import '../dialogs/dialog1.dart';
import '../gal.dart';
import 'index.dart';
import 'video_item.dart';
import 'package:provider/provider.dart';

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
  late VideoPlayerController controller;
  bool loadingVideo = true;
  @override
  void initState() {
    super.initState();
    comment = widget.comment;

    init();
  }

  init() async {
    if (comment.mediaTypes.isNotEmpty &&
        comment.mediaTypes.first.media.contains('video/upload')) {
      controller =
          VideoPlayerController.network(comment.mediaTypes.first.media);
      await controller.initialize();
      setState(() {
        loadingVideo = false;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (comment.mediaTypes.isNotEmpty &&
        comment.mediaTypes.first.media.contains('video/upload'))
      controller.dispose();
  }

  bool isInOtherPage = false;
  bool loading = false;
  TextEditingController controllerT = TextEditingController();
  @override
  Widget build(BuildContext context) {
    // bool isDarkMode = getIt<ThemeState>().isDarkMode;
    if (comment.personalInformationViewModel == null) return const SizedBox();
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(horizontal: doubleWidth(3)),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                                      .personalInformationViewModel!.userName));
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Container(
                              color: white,
                              width: doubleHeight(5),
                              height: doubleHeight(5),
                              child: Builder(
                                builder: (context) {
                                  if (comment.personalInformationViewModel!
                                          .profilePhoto !=
                                      null) {
                                    return imageNetwork(
                                      comment.personalInformationViewModel!
                                          .profilePhoto!,
                                      fit: BoxFit.fill,
                                    );
                                  }
                                  return profilePlaceHolder(context);
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
                                  comment.personalInformationViewModel!.team !=
                                          null
                                      ? DecorationImage(
                                          image: networkImage(comment
                                                  .personalInformationViewModel!
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
                comment.personalInformationViewModel!.userName,
                // comment.personalInformationViewModel!.fullName ?? '',
                style: TextStyle(
                    // color: black,
                    fontWeight: FontWeight.bold,
                    fontSize: doubleWidth(3.5)),
              ),
              // subtitle: Text(
              //     '@${comment.personalInformationViewModel!.userName}',
              //     style: TextStyle(
              //         color: grayCall,
              //         fontWeight: FontWeight.bold,
              //         fontSize: doubleWidth(2.5))),
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
                    onTap: () async {
                      DataPostComment? back = await Go.pushSlideAnimSheet(
                          context, MyBottomSheetComment(comment));
                      if (back != null) {
                        setState(() {
                          comment = back;
                        });
                      }
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
            convertHashtag(context, comment.comment ?? '', (e) {}),
            sizeh(doubleHeight(1)),
            if (comment.mediaTypes.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SizedBox(
                  width: max,
                  height: doubleWidth(70),
                  child: Builder(builder: (context) {
                    if (comment.mediaTypes.isNotEmpty &&
                        comment.mediaTypes.first.media
                            .contains('video/upload')) {
                      if (loadingVideo) {
                        return Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const CircularProgressIndicator(),
                              SizedBox(height: doubleHeight(1)),
                              const Text(
                                'loading ...',
                                textDirection: TextDirection.ltr,
                                style: TextStyle(
                                    color: mainBlue,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        );
                      }
                      return Center(
                        child: VideoItem(
                            controller: controller,
                            url: comment.mediaTypes.first.media,
                            aspectRatio: 2),
                      );
                    } else
                      return PageView.builder(
                        controller: PageController(
                            initialPage: 0, viewportFraction: 0.85),
                        physics: BouncingScrollPhysics(),
                        itemCount: comment.mediaTypes.length,
                        itemBuilder: (_, index) => Padding(
                          padding: EdgeInsets.only(
                              right: comment.mediaTypes.length - 1 != index
                                  ? doubleHeight(2)
                                  : 0),
                          child: GestureDetector(
                            onTap: () {
                              Go.push(
                                  context,
                                  Gal(
                                      images: comment.mediaTypes
                                          .map((e) => e.media)
                                          .toList()));
                            },
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: imageNetwork(
                                  comment.mediaTypes[index].media,
                                  fit: BoxFit.fill,
                                )),
                          ),
                        ),
                      );
                  }),
                ),
              ),
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
                          width: doubleWidth(7),
                          height: doubleWidth(7),
                          child: Center(
                            child: SvgPicture.asset(
                              'assets/icons/comment.svg',
                              color: context.watch<ThemeState>().isDarkMode
                                  ? greenCall
                                  : mainBlue,
                              width: doubleWidth(7),
                              height: doubleWidth(7),
                            ),
                          )),
                      // SizedBox(
                      //     width: doubleWidth(5),
                      //     height: doubleWidth(5),
                      //     child: Image.asset(
                      //       'assets/images/chat(2).png',
                      //       color: greenCall,
                      //     )),
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
                        child: SizedBox(
                          width: doubleWidth(7),
                          height: doubleWidth(7),
                          child: Center(
                            child: SvgPicture.asset(
                              'assets/icons/like.svg',
                              color: comment.commentLikedBythisUser?greenCall:null,
                              width: doubleWidth(7),
                              height: doubleWidth(7),
                            ),
                          ))
                        // Icon(
                        //     comment.commentLikedBythisUser
                        //         ? Icons.favorite
                        //         : Icons.favorite_border,
                        //     color: comment.commentLikedBythisUser
                        //         ? greenCall
                        //         : context.watch<ThemeState>().isDarkMode
                        //             ? white
                        //             : black),
                      ),
                      sizew(doubleWidth(1)),
                      Text(makeCount(comment.commentLikeCount),
                          style: TextStyle(
                              color: context.watch<ThemeState>().isDarkMode
                                  ? white
                                  : black)),
                    ],
                  ),
                  if (comment.personalInformationId ==
                      getIt<MainState>().userId)
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

                            bool? alert = await MyAlertDialog(context,
                                content: 'Do you want to delete the shot?');
                            print('alert $alert');
                            // showDialog(
                            //   context: context,
                            //   barrierDismissible: true,
                            //   builder: (BuildContext dialogContext) {
                            //     return ;
                            //   },
                            // );
                            if (alert != null && alert) {
                              MyService service = await getIt<MyService>();
                              bool back = await ShotsService.deleteComment(
                                  service,
                                  commentId: comment.id);
                              if (back) widget.delete();
                            }
                          },
                          child: trashIcon(context),
                        ),
                      ),
                    )
                  else
                    const SizedBox(
                      width: 24,
                    )
                ],
              ),
            ),
            sizeh(doubleHeight(1)),
            ...comment.commentReplies
                .map((e) => Padding(
                      padding: EdgeInsets.only(left: doubleWidth(4)),
                      child: CommentReply(
                          shotId: comment.postId,
                          key: UniqueKey(),
                          reply: e,
                          delete: () {
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
                  controller: controllerT,
                  onChanged: (e) async {
                    if (isInOtherPage) return;
                    if (e.endsWith('@')) {
                      isInOtherPage = true;
                      DataPersonalInformation? userName =
                          await Go.pushSlideAnim(context, SearchUserMention());
                      controllerT.text = controllerT.value.text
                          .substring(0, controllerT.value.text.length - 1);
                      if (userName != null) {
                        String pp = '';
                        if (!controllerT.value.text.endsWith(' ')) pp = ' ';
                        controllerT.text = controllerT.value.text +
                            pp +
                            '@' +
                            userName.userName +
                            ' ';
                      }
                      isInOtherPage = false;
                    }
                  },
                  decoration: InputDecoration(
                      hintStyle:
                          TextStyle(color: Color.fromRGBO(214, 216, 217, 1)),
                      suffixIcon: GestureDetector(
                          onTap: () async {
                            if (loading || controllerT.value.text.trim() == '')
                              return;
                            setState(() {
                              loading = true;
                            });

                            DataCommentReply? back =
                                await ShotsService.commentReply(
                                    getIt<MyService>(),
                                    stadia: comment.stadiaId != null,
                                    commentId: comment.id,
                                    reply: controllerT.value.text.trim());
                            setState(() {
                              loading = false;
                            });
                            if (back != null) {
                              setState(() {
                                comment.commentReplies.add(back);
                              });
                              controllerT.clear();
                            }
                          },
                          child: loading
                              ? Transform.scale(
                                  scale: 0.5,
                                  child: CircularProgressIndicator())
                              : Icon(
                                  Icons.send,
                                  color: context.watch<ThemeState>().isDarkMode
                                      ? greenCall
                                      : mainBlue,
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
  late VideoPlayerController controller;
  bool loadingVideo = true;
  @override
  void initState() {
    super.initState();
    comment = widget.comment;

    init();
  }

  init() async {
    if (comment.mediaTypes.isNotEmpty &&
        comment.mediaTypes.first.media.contains('video/upload')) {
      controller =
          VideoPlayerController.network(comment.mediaTypes.first.media);
      await controller.initialize();
      setState(() {
        loadingVideo = false;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (comment.mediaTypes.isNotEmpty &&
        comment.mediaTypes.first.media.contains('video/upload'))
      controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // bool isDarkMode = getIt<ThemeState>().isDarkMode;
    if (comment.personalInformationViewModel == null) return const SizedBox();
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
                                      .personalInformationViewModel!.userName));
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Container(
                              color: white,
                              width: doubleHeight(5),
                              height: doubleHeight(5),
                              child: Builder(
                                builder: (context) {
                                  if (comment.personalInformationViewModel!
                                          .profilePhoto !=
                                      null) {
                                    return imageNetwork(
                                      comment.personalInformationViewModel!
                                          .profilePhoto!,
                                      fit: BoxFit.fill,
                                    );
                                  }
                                  return profilePlaceHolder(context);
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
                                  comment.personalInformationViewModel!.team !=
                                          null
                                      ? DecorationImage(
                                          image: networkImage(comment
                                                  .personalInformationViewModel!
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
                comment.personalInformationViewModel!.userName,
                style: TextStyle(
                    // color: black,
                    fontWeight: FontWeight.bold,
                    fontSize: doubleWidth(3.5)),
              ),
              // subtitle: Text(
              //     '@${comment.personalInformationViewModel!.userName}',
              //     style: TextStyle(
              //         color: grayCall,
              //         fontWeight: FontWeight.bold,
              //         fontSize: doubleWidth(2.5))),
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
                    onTap: () async {
                      DataPostComment? back = await Go.pushSlideAnimSheet(
                          context, MyBottomSheetComment(comment));
                      if (back != null) {
                        setState(() {
                          comment = back;
                        });
                      }
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
            convertHashtag(context, comment.comment ?? '', (e) {}),
            sizeh(doubleHeight(1)),
            if (comment.mediaTypes.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SizedBox(
                  width: max,
                  height: doubleWidth(70),
                  child: Builder(builder: (context) {
                    if (comment.mediaTypes.isNotEmpty &&
                        comment.mediaTypes.first.media
                            .contains('video/upload')) {
                      if (loadingVideo) {
                        return Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const CircularProgressIndicator(),
                              SizedBox(height: doubleHeight(1)),
                              const Text(
                                'loading ...',
                                textDirection: TextDirection.ltr,
                                style: TextStyle(
                                    color: mainBlue,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        );
                      }
                      return Center(
                        child: VideoItem(
                            controller: controller,
                            url: comment.mediaTypes.first.media,
                            aspectRatio: 2),
                      );
                    } else
                      return PageView.builder(
                        controller: PageController(
                            initialPage: 0, viewportFraction: 0.85),
                        physics: BouncingScrollPhysics(),
                        itemCount: comment.mediaTypes.length,
                        itemBuilder: (_, index) => Padding(
                          padding: EdgeInsets.only(
                              right: comment.mediaTypes.length - 1 != index
                                  ? doubleHeight(2)
                                  : 0),
                          child: GestureDetector(
                            onTap: () {
                              Go.push(
                                  context,
                                  Gal(
                                      images: comment.mediaTypes
                                          .map((e) => e.media)
                                          .toList()));
                            },
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: imageNetwork(
                                  comment.mediaTypes[index].media,
                                  fit: BoxFit.fill,
                                )),
                          ),
                        ),
                      );
                  }),
                ),
              ),
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
                          width: doubleWidth(7),
                          height: doubleWidth(7),
                          child: Center(
                            child: SvgPicture.asset(
                              'assets/icons/comment.svg',
                              color: context.watch<ThemeState>().isDarkMode
                                  ? greenCall
                                  : mainBlue,
                              width: doubleWidth(7),
                              height: doubleWidth(7),
                            ),
                          )),
                      // SizedBox(
                      //     width: doubleWidth(5),
                      //     height: doubleWidth(5),
                      //     child: Image.asset('assets/images/chat(2).png',
                      //         color: greenCall)),
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
                        child: SizedBox(
                          width: doubleWidth(7),
                          height: doubleWidth(7),
                          child: Center(
                            child: SvgPicture.asset(
                              'assets/icons/like.svg',
                              color: comment.commentLikedBythisUser?greenCall:null,
                              width: doubleWidth(7),
                              height: doubleWidth(7),
                            ),
                          ))
                        // Icon(
                        //     comment.commentLikedBythisUser
                        //         ? Icons.favorite
                        //         : Icons.favorite_border,
                        //     color: comment.commentLikedBythisUser
                        //         ? greenCall
                        //         : context.watch<ThemeState>().isDarkMode
                        //             ? white
                        //             : black),
                      ),
                      sizew(doubleWidth(1)),
                      Text(makeCount(comment.commentLikeCount),
                          style: TextStyle(
                              color: context.watch<ThemeState>().isDarkMode
                                  ? white
                                  : black)),
                    ],
                  ),
                  if (comment.personalInformationId ==
                      getIt<MainState>().userId)
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
                            bool? alert = await MyAlertDialog(context,
                                content: 'Do you want to delete the shot?');
                            // showDialog(
                            //   context: context,
                            //   barrierDismissible: true,
                            //   builder: (BuildContext dialogContext) {
                            //     return ;
                            //   },
                            // );
                            if (alert != null && alert) {
                              MyService service = await getIt<MyService>();
                              bool back = await ShotsService.deleteComment(
                                  service,
                                  commentId: comment.id);
                              if (back) widget.delete();
                            }
                          },
                          child: trashIcon(context),
                        ),
                      ),
                    )
                  else
                    const SizedBox(
                      width: 24,
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
