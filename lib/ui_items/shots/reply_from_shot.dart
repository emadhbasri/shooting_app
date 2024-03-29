import 'package:flutter_svg/flutter_svg.dart';

import '../../classes/services/my_service.dart';
import '../../classes/services/shots_service.dart';
import '../../classes/states/main_state.dart';
import '../../main.dart';
import '../../pages/profile/profile.dart';
import '../dialogs/dialog1.dart';
import 'index.dart';

class CommentReply extends StatefulWidget {
  final String shotId;
  final VoidCallback delete;
  const CommentReply({Key? key, required this.reply, required this.shotId, required this.delete})
      : super(key: key);
  final DataCommentReply reply;
  @override
  _CommentReplyState createState() => _CommentReplyState();
}

class _CommentReplyState extends State<CommentReply> {
  late DataCommentReply reply;
  @override
  void initState() {
    super.initState();
    reply = widget.reply;
  }

  @override
  Widget build(BuildContext context) {
    if (reply.personalInformationViewModel == null) return const SizedBox();
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(horizontal: doubleWidth(3)),
      child: Container(
        // decoration: BoxDecoration(
        //     border: Border(bottom: BorderSide(color: grayCall))),
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
                                    username: reply.personalInformationViewModel!.userName));
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: Container(
                                color: white,
                                width: doubleHeight(5),
                                height: doubleHeight(5),
                                child: Builder(
                                  builder: (context) {
                                    if (reply.personalInformationViewModel!.profilePhoto != null) {
                                      return imageNetwork(
                                        reply.personalInformationViewModel!.profilePhoto!,
                                        fit: BoxFit.fill,
                                      );
                                    }
                                    return profilePlaceHolder(context);
                                  },
                                )),
                          )),
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
                              image: reply.personalInformationViewModel!.team != null
                                  ? DecorationImage(
                                      image: networkImage(
                                          reply.personalInformationViewModel!.team!.team_badge ??
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
                reply.personalInformationViewModel!.userName,
                style: TextStyle(
                    // color: black,
                    fontWeight: FontWeight.bold,
                    fontSize: doubleWidth(3.5)),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(makeDurationToString(reply.createdAt),
                      style: TextStyle(
                          color: grayCall,
                          fontWeight: FontWeight.bold,
                          fontSize: doubleWidth(2.5))),
                  SizedBox(width: doubleWidth(4)),
                  GestureDetector(
                    onTap: () async {
                      dynamic back = await Go.pushSlideAnimSheet(
                          context, MyBottomSheetReply(reply, widget.shotId));
                      if (back != null) {
                        if (back is DataCommentReply) {
                          setState(() {
                            reply = back;
                          });
                        } else if (back is String) {
                          setState(() {
                            reply.replyDetail = back;
                          });
                        }
                      }
                    },
                    child: Container(
                      width: doubleWidth(6),
                      height: doubleWidth(5),
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(226, 224, 235, 1),
                          borderRadius: BorderRadius.circular(5)),
                      padding: EdgeInsets.symmetric(horizontal: doubleWidth(0.8)),
                      child: Image.asset('assets/images/menu.png'),
                    ),
                  )
                ],
              ),
            ),
            sizeh(doubleHeight(1)),
            convertHashtag(context, reply.replyDetail ?? '', (e) {}),
            sizeh(doubleHeight(1)),
            SizedBox(
              width: max,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: doubleWidth(5),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      GestureDetector(
                          onTap: () async {
                            MyService service = await getIt<MyService>();
                            if (!reply.replyLikedBythisUser) {
                              String? back =
                                  await ShotsService.replyLike(service, commentReplyId: reply.id);
                              if (back != null)
                                setState(() {
                                  reply.replyLikes.add(DataReplyLike(back, ''));
                                  reply.replyLikedBythisUser = true;
                                  reply.replyLikeCount++;
                                });
                            } else {
                              if (reply.replyLikes.isNotEmpty) {
                                bool back = await ShotsService.deleteReplyLike(service,
                                    replyId: reply.replyLikes.first.id);
                                if (back)
                                  setState(() {
                                    reply.replyLikes.clear();
                                    reply.replyLikedBythisUser = false;
                                    reply.replyLikeCount--;
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
                                  color: reply.replyLikedBythisUser ? greenCall : null,
                                  width: doubleWidth(7),
                                  height: doubleWidth(7),
                                ),
                              ))
                          // Icon(
                          //     reply.replyLikedBythisUser
                          //         ? Icons.favorite
                          //         : Icons.favorite_border,
                          //     color:
                          //         reply.replyLikedBythisUser ? greenCall : context.watch<ThemeState>().isDarkMode?white:black),
                          ),
                      sizew(doubleWidth(1)),
                      Text(makeCount(reply.replyLikeCount)),
                    ],
                  ),
                  if (widget.reply.personalInformationId == getIt<MainState>().userId)
                    Tooltip(
                      message: AppLocalizations.of(context)!.remove_the_reply,
                      child: SizedBox(
                        width: doubleWidth(5),
                        height: doubleWidth(5),
                        child: GestureDetector(
                          onTap: () async {
                            if (reply.personalInformationId != getIt<MainState>().userId) {
                              toast(AppLocalizations.of(context)!.you_can_not_delete_this_reply);
                              return;
                            }
                            bool? alert = await MyAlertDialog(context,
                                content:
                                    AppLocalizations.of(context)!.do_you_want_to_delete_the_reply);
                            // showDialog(
                            //   context: context,
                            //   barrierDismissible: true,
                            //   builder: (BuildContext dialogContext) {
                            //     return ;
                            //   },
                            // );
                            if (alert != null && alert) {
                              MyService service = await getIt<MyService>();
                              bool back =
                                  await ShotsService.deleteReply(service, replyId: reply.id);
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
          ],
        ),
      ),
    );
  }
}
