import '../../classes/services/my_service.dart';
import '../../classes/services/shots_service.dart';
import '../../classes/states/main_state.dart';
import '../../main.dart';
import 'index.dart';

class CommentReply extends StatefulWidget {
  final VoidCallback delete;
  const CommentReply({Key? key, required this.reply,required this.delete}) : super(key: key);
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
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(horizontal: doubleWidth(3)),
      child: Container(
        // decoration: BoxDecoration(
        //     border: Border(bottom: BorderSide(color: grayCall))),
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
                      child: SizedBox(
                        width: doubleHeight(5),
                        height: doubleHeight(5),
                        child: Container(
                          decoration: BoxDecoration(
                              color: white,
                              borderRadius: BorderRadius.circular(100),
                              image: DecorationImage(
                                fit: BoxFit.fill,
                                image: networkImage(reply
                                        .personalInformationViewModel
                                        .profilePhoto ??
                                    ''),
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
                              image: reply.personalInformationViewModel.team !=
                                      null
                                  ? DecorationImage(
                                      image: networkImage(reply
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
                reply.personalInformationViewModel.fullName ?? '',
                style: TextStyle(
                    color: black,
                    fontWeight: FontWeight.bold,
                    fontSize: doubleWidth(3.5)),
              ),
              subtitle: Text(
                  '@${reply.personalInformationViewModel.userName ?? ''}',
                  style: TextStyle(
                      color: grayCall,
                      fontWeight: FontWeight.bold,
                      fontSize: doubleWidth(2.5))),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(makeDurationToString(reply.createdAt),
                      style: TextStyle(
                          color: grayCall,
                          fontWeight: FontWeight.bold,
                          fontSize: doubleWidth(2.5))),
                ],
              ),
            ),
            // _convertHashtag(post.text),
            sizeh(doubleHeight(1)),
            convertHashtag(reply.replyDetail ?? '', (e) {}),
            sizeh(doubleHeight(1)),
            SizedBox(
              width: max,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(width: doubleWidth(5),),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () async {
                          MyService service = await getIt<MyService>();
                          if (!reply.replyLikedBythisUser) {
                            bool back = await ShotsService.replyLike(service,
                                commentReplyId: reply.id);
                            if (back)
                              setState(() {
                                reply.replyLikedBythisUser = true;
                              });
                          } else {
                            bool back = await ShotsService.deleteReplyLike(service,
                                replyId: reply.id);
                            if (back)
                              setState(() {
                                reply.replyLikedBythisUser = false;
                              });
                          }
                        },
                        child: Icon(
                            reply.replyLikedBythisUser
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: reply.replyLikedBythisUser ? Colors.pink : null),
                      ),
                      sizew(doubleWidth(1)),
                      Text(makeCount(reply.replyLikeCount)),
                    ],
                  ),
                  Tooltip(
                    message: 'remove the reply',
                    child: SizedBox(
                      width: doubleWidth(5),
                      height: doubleWidth(5),
                      child: GestureDetector(
                        onTap: ()async{
                          if(reply.personalInformationId!=getIt<MainState>().userId){
                            toast('you can not delete this comment');
                            return;
                          }
                          MyService service = await getIt<MyService>();
                          bool back = await ShotsService.deleteReply(service,
                              replyId: reply.id);
                          if (back)
                            widget.delete();

                        },
                        child: Icon(Icons.remove_circle_outline),
                      ),
                    ),
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
