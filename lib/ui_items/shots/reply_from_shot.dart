
import '../../classes/my_service.dart';
import '../../main.dart';
import 'index.dart';
class CommentReply extends StatefulWidget {
  const CommentReply({Key? key,required this.comment}) : super(key: key);
  final DataCommentReply comment;
  @override
  _CommentReplyState createState() => _CommentReplyState();
}

class _CommentReplyState extends State<CommentReply> {
  late DataCommentReply comment;
  @override
  void initState() {
    super.initState();
    comment=widget.comment;
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
                              borderRadius:
                              BorderRadius.circular(100),
                              image: DecorationImage(
                                image: networkImage(
                                    comment.personalInformationViewModel.profilePhoto??''
                                ),
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
                              border: Border.all(
                                  color: white, width: 2),
                              borderRadius:
                              BorderRadius.circular(100),
                              image: comment.personalInformationViewModel.team!=null?DecorationImage(
                                image: networkImage(
                                    comment.personalInformationViewModel.team!.team_badge??''),
                              ):null),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              title: Text(
                comment.personalInformationViewModel.fullName??'',
                style: TextStyle(
                    color: black,
                    fontWeight: FontWeight.bold,
                    fontSize: doubleWidth(3.5)),
              ),
              subtitle: Text('@${comment.personalInformationViewModel.userName??''}',
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
            // _convertHashtag(post.text),
            sizeh(doubleHeight(1)),
            convertHashtag(comment.replyDetail??'',(e){}),
            sizeh(doubleHeight(1)),
            SizedBox(
              width: max,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTap: () async {
                      MyService service = await getIt<MyService>();
                      String? userId = await getString('userid');
                      bool back = await ShotsService.replyLike(service,
                          userId: userId!, commentReplyId: comment.id);
                      if (back)
                        setState(() {
                          comment.replyLikedBythisUser = true;
                        });
                    },
                    child: Icon(comment.replyLikedBythisUser?Icons.favorite:Icons.favorite_border,
                        color: comment.replyLikedBythisUser?Colors.pink:null),
                  ),
                  sizew(doubleWidth(1)),
                  Text('${comment.replyLikeCount}')
                  // SizedBox(
                  //     width: doubleWidth(5),
                  //     height: doubleWidth(5),
                  //     child: Image.asset('images/heart.png'))
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