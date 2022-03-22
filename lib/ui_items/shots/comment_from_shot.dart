import '../../classes/my_service.dart';
import '../../main.dart';
import 'index.dart';

class CommentFromShot extends StatefulWidget {
  const CommentFromShot({Key? key, required this.comment}) : super(key: key);
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

  TextEditingController controller = TextEditingController();
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
                                image: networkImage(comment
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
                  '@${comment.personalInformationViewModel.userName ?? ''}',
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
                          child: Image.asset('images/chat(2).png')),
                      sizew(doubleWidth(1)),
                      Text('${comment.commentReplies.length}')
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () async {
                          MyService service = await getIt<MyService>();
                          String? userId = await getString('userid');
                          bool back = await ShotsService.commentLike(service,
                               postCommentId: comment.id);
                          if (back)
                            setState(() {
                              comment.commentLikedBythisUser = true;
                            });
                        },
                        // setState(() {
                        //   comment.commentLikedBythisUser=!comment.commentLikedBythisUser;
                        // });
                        child: Icon(
                            comment.commentLikedBythisUser
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: comment.commentLikedBythisUser
                                ? Colors.pink
                                : null),
                      ),
                      sizew(doubleWidth(1)),
                      Text('${comment.commentLikeCount}')
                      // SizedBox(
                      //     width: doubleWidth(5),
                      //     height: doubleWidth(5),
                      //     child: Image.asset('images/heart.png'))
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      showDialog(context: context, builder: (_) => Dialog2());
                    },
                    child: SizedBox(
                        width: doubleWidth(5),
                        height: doubleWidth(5),
                        child: Image.asset('images/share.png')),
                  )
                ],
              ),
            ),
            sizeh(doubleHeight(1)),
            ...comment.commentReplies
                .map((e) => Padding(
                      padding: EdgeInsets.only(left: doubleWidth(4)),
                      child: CommentReply(comment: e),
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
                          onTap: () async{
                            print('controller.value.text ${controller.value.text}');
                            DataCommentReply? back = await ShotsService.commentReply(getIt<MyService>(),
                                commentId:  comment.id,
                                reply: controller.value.text);
                            setState(() {
                              comment.commentReplies.add(back!);
                            });
                            controller.clear();
                          },
                          child: Icon(
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
