import 'package:flutter/material.dart';
import 'package:shooting_app/classes/functions.dart';
import 'package:shooting_app/classes/models.dart';
import 'package:shooting_app/classes/services/my_service.dart';
import 'package:shooting_app/main.dart';
import 'package:shooting_app/ui_items/shots/post_from_shot.dart';

import '../../classes/dataTypes.dart';
import '../../classes/services/shots_service.dart';
import '../../ui_items/shots/comment_from_shot.dart';
import '../shoot/shoot_comment.dart';

class Shot extends StatefulWidget {
  const Shot({Key? key, this.post, this.postId}) : super(key: key);
  final DataPost? post;
  final String? postId;
  @override
  _ShotState createState() => _ShotState();
}

class _ShotState extends State<Shot> {

  MyService service = getIt<MyService>();
  DataPost? post;
  getData() async {
    print('getData()');
    if (post != null)
      post = await ShotsService.getShotById(service, post!.id);
    else
      post = await ShotsService.getShotById(service, widget.postId!);
    setState(() {});
  }


  @override
  void initState() {
    super.initState();
    print('widget.post $widget.post');
    if (widget.post != null) {
      post = widget.post;
    }
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.shot),
        ),
        floatingActionButton: FloatingActionButton(
          heroTag: 'makeComment',
          onPressed: () async{
            if(post!=null){
              DataPostComment? back = await
              Go.pushSlideAnimSheet(context, ShootComment(postId: post!.id,
              stadia: post!.stadiaId!=null,));
              if (back!=null) {
                setState(() {
                  post!.postComments.add(back);
                });
              }
            }
          },
          elevation: 5,
          backgroundColor: mainGreen,
          child: Container(
              width: doubleWidth(9),
              height: doubleWidth(9),
              child: Image.asset('assets/images/soccer.png')),
        ),
        body: post == null
            ? circle()
            : ListView(
          padding: EdgeInsets.only(bottom: doubleHeight(10),top: doubleHeight(1)),
              children: [
                PostFromShot(
                    post: post!,
                    canTouch: false,
                    onTapTag: gogo,
                    delete: () {}),
                SizedBox(height: doubleHeight(1)),
                ...List.generate(
                    post!.postComments.length,
                    (index) => CommentFromShot(
                        key: UniqueKey(),
                        comment: post!.postComments[index],
                        delete: () {
                          print('delete comment $index');
                          List<DataPostComment> temp =
                              post!.postComments.toList();
                          temp.removeAt(index);
                          setState(() {
                            post!.postComments = temp.toList();
                          });
                        })),
              ],
            ));
  }
}
