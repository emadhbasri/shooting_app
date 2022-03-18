import 'package:flutter/material.dart';
import 'package:shooting_app/classes/models.dart';
import 'package:shooting_app/classes/my_service.dart';
import 'package:shooting_app/pages/Search.dart';
import 'package:shooting_app/ui_items/bottom_sheet.dart';

import '../classes/data.dart';
import '../classes/functions.dart';
import '../dataTypes.dart';
import '../main.dart';
import '../ui_items/dialogs/dialog2.dart';
import '../ui_items/shots/post_from_shot.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  bool isFirstTab = true;

  List<DataPost> allPosts = [];
  MyService service = getIt<MyService>();
  getData() async {
    allPosts = await ShotsService.shotsAll(service);
    setState(() {});
    print('allPosts ${allPosts.length}');
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromRGBO(244, 244, 244, 1),
      child: Column(
        children: <Widget>[
          Container(
            color: white,
            width: max,
            height: doubleHeight(6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isFirstTab = true;
                    });
                  },
                  child: Container(
                    color: white,
                    width: doubleWidth(30),
                    child: Center(
                      child: Stack(
                        children: <Widget>[
                          Container(
                            width: doubleWidth(30),
                            height: max,
                            padding: EdgeInsets.all(doubleWidth(3)),
                            child: Center(
                              child: Text(
                                'Team Feeds',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: mainBlue,
                                    fontSize: doubleWidth(4)),
                              ),
                            ),
                          ),
                          isFirstTab
                              ? Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Container(
                                    width: doubleWidth(10),
                                    height: doubleHeight(0.4),
                                    decoration: BoxDecoration(
                                        color: mainBlue,
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(100),
                                          topLeft: Radius.circular(100),
                                        )),
                                  ),
                                )
                              : non
                        ],
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isFirstTab = false;
                    });
                  },
                  child: Container(
                    color: white,
                    width: doubleWidth(30),
                    child: Center(
                      child: Stack(
                        children: <Widget>[
                          Container(
                            width: doubleWidth(30),
                            height: max,
                            padding: EdgeInsets.all(doubleWidth(3)),
                            child: Center(
                              child: Text(
                                'Fan Feeds',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: mainBlue,
                                    fontSize: doubleWidth(4)),
                              ),
                            ),
                          ),
                          !isFirstTab
                              ? Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Container(
                                    width: doubleWidth(10),
                                    height: doubleHeight(0.4),
                                    decoration: BoxDecoration(
                                        color: mainBlue,
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(100),
                                          topLeft: Radius.circular(100),
                                        )),
                                  ),
                                )
                              : non
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            width: max,
            height: doubleHeight(9),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: doubleHeight(9),
                    height: doubleHeight(9),
                    padding: EdgeInsets.all(doubleWidth(2)),
                    child: Container(
                      decoration: BoxDecoration(
                          color: white,
                          borderRadius: BorderRadius.circular(100),
                          image: DecorationImage(
                            image: AssetImage('images/158023.png'),
                          )),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: mainBlue.withOpacity(0.6),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.add,
                            color: white,
                            size: doubleWidth(9),
                          ),
                        ),
                      ),
                    ),
                  ),
                  ...List.generate(15, (index) {
                    return index;
                  })
                      .map(
                        (e) => Container(
                          width: doubleHeight(9),
                          height: doubleHeight(9),
                          padding: EdgeInsets.all(doubleWidth(2)),
                          child: Container(
                            decoration: BoxDecoration(
                                color: white,
                                border: Border.all(color: mainGreen),
                                borderRadius: BorderRadius.circular(100),
                                image: DecorationImage(
                                    image: AssetImage('images/158023.png'))),
                          ),
                        ),
                      )
                      .toList()
                ],
              ),
            ),
          ),
          Expanded(
              child: RefreshIndicator(
                onRefresh: ()async{
                  await getData();
                },
                child: ListView.builder(
            itemCount: allPosts.length,
            itemBuilder: (context, index) => PostFromShot(
                post: allPosts[index],
                onTapTag: (f) {
                  Go.pushSlideAnim(
                      context,
                      Search(
                        search: f,
                      ));
                },
            ),
          ),
              ))

        ],
      ),
    );
  }
}

class PostItem extends StatefulWidget {
  const PostItem({Key? key, required this.post, required this.onTapTag})
      : super(key: key);
  final Post post;
  final Function(String) onTapTag;
  @override
  State<PostItem> createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  Widget _convertHashtag(String text) {
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
    return Wrap(
      alignment: WrapAlignment.start,
      crossAxisAlignment: WrapCrossAlignment.start,
      runAlignment: WrapAlignment.start,
      spacing: 3,
      children: split.map((e) {
        if (e[0] == '#') {
          return GestureDetector(
              onTap: () {
                widget.onTapTag(e);
              },
              child: Text(e, style: TextStyle(color: mainBlue)));
        } else if (e[0] == '@') {
          return GestureDetector(
              onTap: () {
                widget.onTapTag(e);
              },
              child: Text(e, style: TextStyle(color: mainBlue)));
        } else {
          return Text(e, style: TextStyle(color: black));
        }
      }).toList(),
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

  @override
  Widget build(BuildContext context) {
    return Container(
      width: max,
      height: doubleHeight(
          widget.post.videoImage != null || widget.post.image != null
              ? 35
              : 20),
      padding: EdgeInsets.symmetric(horizontal: doubleWidth(3)),
      child: Container(
        decoration:
            BoxDecoration(border: Border(bottom: BorderSide(color: grayCall))),
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
                      child: SizedBox(
                        width: doubleHeight(5),
                        height: doubleHeight(5),
                        child: Container(
                          decoration: BoxDecoration(
                              color: white,
                              borderRadius: BorderRadius.circular(100),
                              image: DecorationImage(
                                image: AssetImage(widget.post.imageProfile),
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
                              image: DecorationImage(
                                image: AssetImage(widget.post.imageTeam),
                              )),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              title: Text(
                widget.post.name,
                style: TextStyle(
                    color: black,
                    fontWeight: FontWeight.bold,
                    fontSize: doubleWidth(3.5)),
              ),
              subtitle: Text('@${widget.post.username}',
                  style: TextStyle(
                      color: grayCall,
                      fontWeight: FontWeight.bold,
                      fontSize: doubleWidth(2.5))),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text('${widget.post.sec}s',
                      style: TextStyle(
                          color: grayCall,
                          fontWeight: FontWeight.bold,
                          fontSize: doubleWidth(2.5))),
                  SizedBox(width: doubleWidth(4)),
                  GestureDetector(
                    onTap: () {
                      Go.pushSlideAnimSheet(context, MyBottomSheet());
                    },
                    child: Container(
                      width: doubleWidth(6),
                      height: doubleWidth(5),
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(226, 224, 235, 1),
                          borderRadius: BorderRadius.circular(5)),
                      padding:
                          EdgeInsets.symmetric(horizontal: doubleWidth(0.8)),
                      child: Image.asset('images/menu.png'),
                    ),
                  )
                ],
              ),
            ),
            _convertHashtag(widget.post.text),
            sizeh(doubleHeight(1)),
            if (widget.post.videoImage != null || widget.post.image != null)
              widget.post.videoImage != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: SizedBox(
                        width: max,
                        height: doubleHeight(15),
                        child: Row(
                          children: <Widget>[
                            Container(
                              color: mainGreen,
                              height: max,
                              width: doubleWidth(2),
                            ),
                            Expanded(
                              child: widget.post.videoImage != null
                                  ? Image.asset(
                                      widget.post.videoImage!,
                                      fit: BoxFit.fill,
                                    )
                                  : non,
                            )
                          ],
                        ),
                      ),
                    )
                  : Row(
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            color: red,
                            width: doubleHeight(15),
                            height: doubleHeight(15),
                            child: Row(
                              children: <Widget>[
                                Container(
                                  color: mainGreen,
                                  height: max,
                                  width: doubleWidth(2),
                                ),
                                Expanded(
                                  child: SizedBox(
                                      height: max,
                                      width: max,
                                      child: widget.post.image != null
                                          ? Image.asset(
                                              widget.post.image!,
                                              fit: BoxFit.fill,
                                            )
                                          : non),
                                )
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: doubleHeight(15),
                            padding: EdgeInsets.symmetric(
                                horizontal: doubleWidth(3)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Text(widget.post.topic ?? ''),
                                sizeh(doubleHeight(2)),
                                Text(
                                  widget.post.desc ?? '',
                                  style: TextStyle(
                                      color: grayCall,
                                      fontSize: doubleWidth(3)),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
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
                          width: doubleWidth(5),
                          height: doubleWidth(5),
                          child: Image.asset('images/chat(2).png')),
                      sizew(doubleWidth(1)),
                      Text('${widget.post.commentCount}k')
                    ],
                  ),
                  // Row(
                  //   mainAxisSize: MainAxisSize.min,
                  //   children: <Widget>[
                  //     SizedBox(
                  //         width: doubleWidth(5),
                  //         height: doubleWidth(5),
                  //         child: Image.asset('images/heart.png')),
                  //     sizew(doubleWidth(1)),
                  //     Text('${widget.post.likeCount}k')
                  //   ],
                  // ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            widget.post.isLiked = !widget.post.isLiked;
                          });
                        },
                        child: Icon(
                            widget.post.isLiked
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: widget.post.isLiked ? Colors.pink : null),
                      ),
                      sizew(doubleWidth(1)),
                      Text('${widget.post.likeCount}k')
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
          ],
        ),
      ),
    );
  }
}


