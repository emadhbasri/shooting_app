import 'package:flutter/material.dart';
import 'package:shooting_app/classes/functions.dart';
import 'package:shooting_app/classes/models.dart';
import 'package:shooting_app/classes/my_service.dart';
import 'package:shooting_app/main.dart';
import 'package:shooting_app/ui_items/comment.dart';

import '../../ui_items/shots/comment_from_shot.dart';
import '../chat/chat_list.dart';

class Shot extends StatefulWidget {
  const Shot({Key? key,this.post,this.postId}) : super(key: key);
  final DataPost? post;
  final String? postId;
  @override
  _ShotState createState() => _ShotState();
}

class _ShotState extends State<Shot> {
  TextEditingController controller = TextEditingController();

  MyService service = getIt<MyService>();
  DataPost? post;
  getData() async {
    // post = await service.shotsAll();
    // setState(() {});
    // print('allPosts ${allPosts.length}');
  }

  addComment()async{
    String? userId = await getString('userid');
    print('controller.value.text ${controller.value.text}');
    DataPostComment? back = await ShotsService.shotsComment(service,
        userId: userId!,
        postId: post!.id,
        comment: controller.value.text);
    setState(() {
      post!.postComments.add(back!);
    });
    controller.clear();
  }

  @override
  void initState() {
    super.initState();

    if(widget.post!=null){
      post=widget.post;
    }else{
      getData();
    }
  }
  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(title: Text('Comments'),),
        body: post==null?circle():Column(
          children: [
            Flexible(
              child: ListView.builder(
                itemCount: post!.postComments.length,
                itemBuilder: (context, index) =>
                    CommentFromShot(comment: post!.postComments[index]),),
            ),
            Container(
              color: Colors.white,
              width: double.maxFinite,
              padding: EdgeInsets.symmetric(vertical: doubleHeight(0.5)),
              child: Row(
                children: [
                  SizedBox(width: doubleWidth(4)),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(244, 244, 244, 1),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: doubleWidth(8), vertical: doubleHeight(0.5)),
                      child: TextField(
                        controller: controller,
                        decoration: InputDecoration(
                            hintStyle: TextStyle(color: Color.fromRGBO(214, 216, 217, 1)),
                            hintText: 'Write your comment...',
                            border: InputBorder.none),
                      ),
                    ),
                  ),
                  SizedBox(width: doubleWidth(4)),
                  GestureDetector(
                    onTap: (){
                      setState(() {

                      });
                      addComment();
                      // state.selectedChat.messages.add(
                      //     DataMessage(
                      //         message: controller.value.text,
                      //         date: DateTime.now(),
                      //         isMine: true,
                      //         read: false
                      //     )
                      // );
                      // state.notify();
                    },
                    child: Container(
                      padding: EdgeInsets.all(doubleWidth(4)),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: greenCall,
                      ),
                      child: Icon(Icons.arrow_upward,color: Colors.black,),
                    ),
                  ),
                  SizedBox(width: doubleWidth(4)),
                ],
              ),
            ),

          ],
        )


      );
  }
}
