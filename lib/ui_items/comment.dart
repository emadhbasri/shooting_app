import 'package:flutter/material.dart';
import 'package:shooting_app/ui_items/dialogs/dialog1.dart';

import '../classes/functions.dart';
import '../classes/models.dart';
import '../dataTypes.dart';
import 'bottom_sheet.dart';
import 'dialogs/dialog2.dart';
class Comment extends StatefulWidget {
  const Comment({Key? key,required this.comment}) : super(key: key);
  final DataComment comment;
  @override
  _CommentState createState() => _CommentState();
}

class _CommentState extends State<Comment> {
  late DataComment comment;
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

                                image: AssetImage(
                                    comment.profileImage),
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
                              image: DecorationImage(
                                image: AssetImage(
                                    comment.teamImage),
                              )),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              title: Text(
                comment.profilename,
                style: TextStyle(
                    color: black,
                    fontWeight: FontWeight.bold,
                    fontSize: doubleWidth(3.5)),
              ),
              subtitle: Text('@${comment.userName}',
                  style: TextStyle(
                      color: grayCall,
                      fontWeight: FontWeight.bold,
                      fontSize: doubleWidth(2.5))),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text('${comment.time}',
                      style: TextStyle(
                          color: grayCall,
                          fontWeight: FontWeight.bold,
                          fontSize: doubleWidth(2.5))),
                  SizedBox(width: doubleWidth(4)),
                  GestureDetector(
                    onTap: (){
                      Go.pushSlideAnimSheet(context, MyBottomSheet());
                    },
                    child: Container(
                      width: doubleWidth(6),
                      height: doubleWidth(5),
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(226, 224, 235, 1),
                          borderRadius: BorderRadius.circular(5)),
                      padding: EdgeInsets.symmetric(
                          horizontal: doubleWidth(0.8)),
                      child: Image.asset('images/menu.png'),
                    ),
                  )
                ],
              ),
            ),

            // _convertHashtag(post.text),
            sizeh(doubleHeight(1)),
            convertHashtag(comment.comment,(e){}),
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
                          child:
                          Image.asset('images/chat(2).png')),
                      sizew(doubleWidth(1)),
                      Text('${comment.commentCount}')
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      GestureDetector(
                        onTap:(){
                          setState(() {
                            comment.isLiked=!comment.isLiked;
                          });
                        },
                        child: Icon(comment.isLiked?Icons.favorite:Icons.favorite_border,
                          color: comment.isLiked?Colors.pink:null),
                      ),
                      sizew(doubleWidth(1)),
                      Text('${comment.likeCount}')
                      // SizedBox(
                      //     width: doubleWidth(5),
                      //     height: doubleWidth(5),
                      //     child: Image.asset('images/heart.png'))
                    ],
                  ),
                  GestureDetector(
                    onTap: (){
                      showDialog(context: context, builder: (_)=>Dialog2());
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
            Divider(
              color: grayCall,
            ),
            ...comment.comments.map((e) => 
              Padding(
                padding: EdgeInsets.only(left: doubleWidth(4)),
                child: Comment(comment: e),
              )  
            ).toList()
          ],
        ),
      ),
    );
  }

}


Widget convertHashtag(String text,Function(String) onTapTag) {
  List<String> split = text.split(' ');
  // List<String> split = text.split('#');
  // List<String> hashtags = split.getRange(1, split.length).fold([], (t, e) {
  //   var texts = e.split(" ");
  //   if (texts.length > 1) {
  //     return List.from(t)
  //       ..addAll(["#${texts.first}", "${e.substring(texts.first.length)}"]);
  //   }
  //   return List.from(t)..add("#${texts.first}");
  // });
  return SizedBox(
    width: double.maxFinite,
    child: Wrap(
      alignment: WrapAlignment.start,
      crossAxisAlignment: WrapCrossAlignment.start,
      runAlignment: WrapAlignment.start,
      spacing: 3,
      children: split.map((e) {
        if(e.length>0){
          if (e[0] == '#') {
            return GestureDetector(
                onTap: () {
                  onTapTag(e);
                },
                child: Text(e, style: TextStyle(color: mainBlue)));
          } else if (e[0] == '@') {
            return GestureDetector(
                onTap: () {
                  onTapTag(e);
                },
                child: Text(e, style: TextStyle(color: mainBlue)));
          } else {
            return Text(e, style: TextStyle(color: black));
          }
        } else {
          return Text(e, style: TextStyle(color: black));
        }
      }).toList(),
    ),
  );
  // return RichText(
  //   text: TextSpan(
  //     children: [TextSpan(text: split.first, style: TextStyle(color: black))]
  //       ..addAll(hashtags
  //           .map((text) => text.contains("#")
  //           ? TextSpan(text: text, style: TextStyle(color: mainBlue),
  //
  //         onEnter: (PointerEnterEvent e){
  //             print('asdasd');
  //         }
  //       )
  //           : TextSpan(text: text, style: TextStyle(color: black)))
  //           .toList()),
  //   ),
  // );
}
// RichText convertHashtag(String text) {
//   List<String> split = text.split('#');
//   List<String> hashtags = split.getRange(1, split.length).fold([], (t, e) {
//     var texts = e.split(" ");
//     if (texts.length > 1) {
//       return List.from(t)
//         ..addAll(["#${texts.first}", "${e.substring(texts.first.length)}"]);
//     }
//     return List.from(t)..add("#${texts.first}");
//   });
//   return RichText(
//     text: TextSpan(
//       children: [TextSpan(text: split.first, style: TextStyle(color: black))]
//         ..addAll(hashtags
//             .map((text) => text.contains("#")
//             ? TextSpan(text: text, style: TextStyle(color: mainBlue))
//             : TextSpan(text: text, style: TextStyle(color: black)))
//             .toList()),
//     ),
//   );
// }

class DataComment{
  late String time;
  late String profileImage;
  late String profilename;
  late String teamImage;
  late String comment;
  late String userName;
  late String commentCount;
  late String likeCount;
  late bool isLiked;
  List<DataComment> comments=[];
  DataComment(
      {
        required this.comments,
        required this.isLiked, required this.time,
      required this.profileImage,
      required this.profilename,
      required this.teamImage,
      required this.comment,
      required this.userName,
      required this.commentCount,
      required this.likeCount});
}
