import 'package:shooting_app/classes/services/my_service.dart';

import '../../classes/services/shots_service.dart';
import '../../main.dart';
import '../../pages/shot/shot.dart';
import 'comment_from_shot.dart';
import 'index.dart';

class PostFromShot extends StatefulWidget {
  const PostFromShot(
      {Key? key,
      this.canTouch = true,
      required this.post,
      required this.onTapTag})
      : super(key: key);
  final DataPost post;
  final Function(BuildContext, String, bool) onTapTag;
  final bool canTouch;
  @override
  State<PostFromShot> createState() => _PostFromShotState();
}

class _PostFromShotState extends State<PostFromShot> {
  Widget _convertHashtag(context, String text) {
    List<String> split = text.split(' ');
    print('split $split');
    return Wrap(
      alignment: WrapAlignment.start,
      crossAxisAlignment: WrapCrossAlignment.start,
      runAlignment: WrapAlignment.start,
      spacing: 3,
      children: split.map((e) {
        if(e.length==0)return Text('');
        if (e[0] == '#') {
          return GestureDetector(
              onTap: () {
                widget.onTapTag(context, e, false);
              },
              child: Text(e, style: TextStyle(color: mainBlue)));
        } else if (e[0] == '@') {
          return GestureDetector(
              onTap: () {
                widget.onTapTag(context, e, true);
              },
              child: Text(e, style: TextStyle(color: mainBlue)));
        } else {
          return Text(e, style: TextStyle(color: black));
        }
      }).toList(),
    );
  }

  DataPersonalInformationViewModel? person;
  @override
  void initState() {
    super.initState();
    person = widget.post.person;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: max,
      // height: doubleHeight(20),
      // height: doubleHeight(widget.post.videoImage!=null || widget.post.image!=null ?35:20),
      padding: EdgeInsets.symmetric(horizontal: doubleWidth(3)),
      child: Container(
        decoration:
            BoxDecoration(border: Border(bottom: BorderSide(color: grayCall))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ListTile(
              onTap: widget.canTouch
                  ? () {
                      Go.pushSlideAnim(
                          context,
                          Shot(
                            post: widget.post,
                          ));
                    }
                  : null,
              contentPadding: EdgeInsets.zero,
              dense: true,
              leading: SizedBox(
                width: doubleWidth(13),
                child: Stack(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: SizedBox(
                          width: doubleHeight(5),
                          height: doubleHeight(5),
                          child: Builder(
                            builder: (context) {
                              if (person != null &&
                                  person!.profilePhoto != null) {
                                return imageNetwork(
                                  person!.profilePhoto!,
                                  fit: BoxFit.fill,
                                );
                              }
                              return const SizedBox();
                            },
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment(1, -1),
                      child: SizedBox(
                        width: doubleHeight(3),
                        height: doubleHeight(3),
                        child: Builder(
                          builder: (context) {
                            if (person != null &&
                                person!.team != null &&
                                person!.team!.team_badge != null) {
                              return Container(
                                decoration: BoxDecoration(
                                    color: white,
                                    border: Border.all(color: white, width: 2),
                                    borderRadius: BorderRadius.circular(100),
                                    image: DecorationImage(
                                      image: networkImage(
                                          person!.team!.team_badge!),
                                    )),
                              );
                            }
                            return const SizedBox();
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
              title: Builder(builder: (context) {
                if (person != null && person!.fullName != null)
                  return Text(
                    person!.fullName!,
                    style: TextStyle(
                        color: black,
                        fontWeight: FontWeight.bold,
                        fontSize: doubleWidth(3.5)),
                  );
                return Text(
                  '',
                  style: TextStyle(
                      color: black,
                      fontWeight: FontWeight.bold,
                      fontSize: doubleWidth(3.5)),
                );
              }),
              subtitle: Builder(builder: (context) {
                if (person != null && person!.fullName != null)
                  return Text('@${person!.fullName!}',
                      style: TextStyle(
                          color: grayCall,
                          fontWeight: FontWeight.bold,
                          fontSize: doubleWidth(2.5)));
                return Text('',
                    style: TextStyle(
                        color: grayCall,
                        fontWeight: FontWeight.bold,
                        fontSize: doubleWidth(2.5)));
              }),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(makeDurationToString(widget.post.createdAt),
                      style: TextStyle(
                          color: grayCall,
                          fontWeight: FontWeight.bold,
                          fontSize: doubleWidth(2.5))),
                  SizedBox(width: doubleWidth(4)),
                  GestureDetector(
                    onTap: () {
                      Go.pushSlideAnimSheet(
                          context, MyBottomSheet(widget.post));
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
            _convertHashtag(context, widget.post.details ?? ''),
            sizeh(doubleHeight(1)),
            if (widget.post.mediaTypes.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SizedBox(
                  width: max,
                  height: doubleHeight(15),
                  child: PageView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: widget.post.mediaTypes.length,
                    itemBuilder: (_, index) => imageNetwork(
                      widget.post.mediaTypes[index].media,
                      fit: BoxFit.fill,
                    ),
                  ),
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
                          width: doubleWidth(5),
                          height: doubleWidth(5),
                          child: Image.asset('images/chat(2).png')),
                      sizew(doubleWidth(1)),
                      Text(makeCount(widget.post.postCommentCount))
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
                        onTap: () async {
                          MyService service = await getIt<MyService>();

                          if (!widget.post.postLikedBythisUser) {
                            bool back = await ShotsService.shotLike(service,
                                postId: widget.post.id);
                            if (back)
                              setState(() {
                                widget.post.postLikedBythisUser = true;
                              });
                          } else {
                            bool back = await ShotsService.deleteShotLike(
                                service,
                                shotId: widget.post.id);
                            if (back)
                              setState(() {
                                widget.post.postLikedBythisUser = false;
                              });
                          }
                        },
                        child: Icon(
                            widget.post.postLikedBythisUser
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: widget.post.postLikedBythisUser
                                ? Colors.pink
                                : null),
                      ),
                      sizew(doubleWidth(1)),
                      Text(makeCount(widget.post.postLikeCount))
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (_) => ShareDialog(
                                post: widget.post,
                              ));
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

class PostFromShotProfile extends StatefulWidget {
  const PostFromShotProfile(
      {Key? key,
        required this.canDelete,
        required this.delete,
      required this.person,
      required this.post,
      required this.onTapTag})
      : super(key: key);
  final DataPost post;
  final VoidCallback delete;
  final bool canDelete;
  final DataPersonalInformation person;
  final Function(BuildContext, String, bool) onTapTag;
  @override
  State<PostFromShotProfile> createState() => _PostFromShotProfileState();
}

class _PostFromShotProfileState extends State<PostFromShotProfile> {
  Widget _convertHashtag(context, String text) {
    List<String> split = text.split(' ');
    return Wrap(
      alignment: WrapAlignment.start,
      crossAxisAlignment: WrapCrossAlignment.start,
      runAlignment: WrapAlignment.start,
      spacing: 3,
      children: split.map((e) {
        if(e.length==0)return Text('');
        if (e[0] == '#') {
          return GestureDetector(
              onTap: () {
                widget.onTapTag(context, e, false);
              },
              child: Text(e, style: TextStyle(color: mainBlue)));
        } else if (e[0] == '@') {
          return GestureDetector(
              onTap: () {
                widget.onTapTag(context, e, true);
              },
              child: Text(e, style: TextStyle(color: mainBlue)));
        } else {
          return Text(e, style: TextStyle(color: black));
        }
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: max,
      // height: doubleHeight(20),
      // height: doubleHeight(widget.post.videoImage!=null || widget.post.image!=null ?35:20),
      padding: EdgeInsets.symmetric(horizontal: doubleWidth(3)),
      child: Container(
        decoration:
            BoxDecoration(border: Border(bottom: BorderSide(color: grayCall))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ListTile(
              onTap: () {
                Go.pushSlideAnim(
                    context,
                    Shot(
                      postId: widget.post.id,
                    ));
              },
              contentPadding: EdgeInsets.zero,
              dense: true,
              leading: SizedBox(
                width: doubleWidth(13),
                child: Stack(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: SizedBox(
                          width: doubleHeight(5),
                          height: doubleHeight(5),
                          child: Builder(
                            builder: (context) {
                              if (widget.person.profilePhoto != null &&
                                  widget.person.profilePhoto != null) {
                                return imageNetwork(
                                  widget.person.profilePhoto!,
                                  fit: BoxFit.fill,
                                );
                              }
                              return const SizedBox();
                            },
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment(1, -1),
                      child: SizedBox(
                        width: doubleHeight(3),
                        height: doubleHeight(3),
                        child: Builder(
                          builder: (context) {
                            if (widget.person.team != null &&
                                widget.person.team!.team_badge != null) {
                              return Container(
                                decoration: BoxDecoration(
                                    color: white,
                                    border: Border.all(color: white, width: 2),
                                    borderRadius: BorderRadius.circular(100),
                                    image: DecorationImage(
                                      image: networkImage(
                                          widget.person.team!.team_badge!),
                                    )),
                              );
                            }
                            return const SizedBox();
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
              title: Builder(builder: (context) {
                if (widget.person.fullName != null)
                  return Text(
                    widget.person.fullName!,
                    style: TextStyle(
                        color: black,
                        fontWeight: FontWeight.bold,
                        fontSize: doubleWidth(3.5)),
                  );
                return Text(
                  '',
                  style: TextStyle(
                      color: black,
                      fontWeight: FontWeight.bold,
                      fontSize: doubleWidth(3.5)),
                );
              }),
              subtitle: Builder(builder: (context) {
                if (widget.person.fullName != null)
                  return Text('@${widget.person.fullName!}',
                      style: TextStyle(
                          color: grayCall,
                          fontWeight: FontWeight.bold,
                          fontSize: doubleWidth(2.5)));
                return Text('',
                    style: TextStyle(
                        color: grayCall,
                        fontWeight: FontWeight.bold,
                        fontSize: doubleWidth(2.5)));
              }),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(makeDurationToString(widget.post.createdAt),
                      style: TextStyle(
                          color: grayCall,
                          fontWeight: FontWeight.bold,
                          fontSize: doubleWidth(2.5))),
                  SizedBox(width: doubleWidth(4)),
                  GestureDetector(
                    onTap: () {
                      Go.pushSlideAnimSheet(
                          context, MyBottomSheet(widget.post));
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
            _convertHashtag(context, widget.post.details ?? ''),
            sizeh(doubleHeight(1)),
            if (widget.post.mediaTypes.isNotEmpty)
              SizedBox(
                width: max,
                height: doubleHeight(20),
                child: PageView.builder(
                  controller:
                      PageController(initialPage: 0, viewportFraction: 0.85),
                  physics: BouncingScrollPhysics(),
                  itemCount: widget.post.mediaTypes.length,
                  itemBuilder: (_, index) => Padding(
                    padding: EdgeInsets.only(
                        right: widget.post.mediaTypes.length - 1 != index
                            ? doubleHeight(2)
                            : 0),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: imageNetwork(
                          widget.post.mediaTypes[index].media,
                          fit: BoxFit.fill,
                        )),
                  ),
                ),
              ),
            // sizeh(doubleHeight(1)),
            // if(widget.post.mediaTypes.isNotEmpty)
            //   SizedBox(
            //     width: max,
            //     height: doubleHeight(20),
            //     child: SingleChildScrollView(
            //       scrollDirection: Axis.horizontal,
            //       child: Row(
            //         mainAxisAlignment: MainAxisAlignment.center,
            //         children: [
            //           ...widget.post.mediaTypes.map((e) =>
            //               Padding(
            //                 padding: EdgeInsets.only(
            //                     right: widget.post.mediaTypes.last!=e?doubleHeight(2):0
            //                 ),
            //                 child: ClipRRect(
            //                     borderRadius: BorderRadius.circular(10),
            //                     child: imageNetwork(e.media,
            //                       fit: BoxFit.fill,)),
            //               )
            //           ).toList(),
            //           ...widget.post.mediaTypes.map((e) =>
            //               Padding(
            //                 padding: EdgeInsets.only(
            //                     right: widget.post.mediaTypes.last!=e?doubleHeight(2):0
            //                 ),
            //                 child: ClipRRect(
            //                     borderRadius: BorderRadius.circular(10),
            //                     child: imageNetwork(e.media,
            //                       fit: BoxFit.fill,)),
            //               )
            //           ).toList(),
            //         ]
            //       ),
            //     )
            //   ),
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
                      Text(makeCount(widget.post.postCommentCount))
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
                        onTap: () async {
                          MyService service = await getIt<MyService>();

                          if (!widget.post.postLikedBythisUser) {
                            bool back = await ShotsService.shotLike(service,
                                postId: widget.post.id);
                            if (back)
                              setState(() {
                                widget.post.postLikedBythisUser = true;
                              });
                          } else {
                            bool back = await ShotsService.deleteShotLike(
                                service,
                                shotId: widget.post.id);
                            if (back)
                              setState(() {
                                widget.post.postLikedBythisUser = false;
                              });
                          }
                        },
                        child: Icon(
                            widget.post.postLikedBythisUser
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: widget.post.postLikedBythisUser
                                ? Colors.pink
                                : null),
                      ),
                      sizew(doubleWidth(1)),
                      Text(makeCount(widget.post.postLikeCount))
                    ],
                  ),
                  GestureDetector(
                    onTap: () async{
                      print('canDelete ${widget.canDelete}');
                      DataPost? backDialog = await showDialog(
                          context: context,
                          builder: (_) => ShareDialog(
                            canDelete: widget.canDelete,
                            post: widget.post,
                          ));
                      if(backDialog!=null){
                        MyService service = getIt<MyService>();
                        bool back = await ShotsService.deleteShot(service, shotId: widget.post.id);
                        if(back){
                          widget.delete();
                        }
                      }
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

class PostFromMatch extends StatefulWidget {
  const PostFromMatch(
      {Key? key,
        this.canTouch = true,
        required this.post,
        required this.onTapTag})
      : super(key: key);
  final DataPost post;
  final Function(BuildContext, String, bool) onTapTag;
  final bool canTouch;
  @override
  State<PostFromMatch> createState() => _PostFromMatchState();
}

class _PostFromMatchState extends State<PostFromMatch> {
  Widget _convertHashtag(context, String text) {
    List<String> split = text.split(' ');
    return Wrap(
      alignment: WrapAlignment.start,
      crossAxisAlignment: WrapCrossAlignment.start,
      runAlignment: WrapAlignment.start,
      spacing: 3,
      children: split.map((e) {
        if(e.length==0)return Text('');
        if (e[0] == '#') {
          return GestureDetector(
              onTap: () {
                widget.onTapTag(context, e, false);
              },
              child: Text(e, style: TextStyle(color: mainBlue)));
        } else if (e[0] == '@') {
          return GestureDetector(
              onTap: () {
                widget.onTapTag(context, e, true);
              },
              child: Text(e, style: TextStyle(color: mainBlue)));
        } else {
          return Text(e, style: TextStyle(color: black));
        }
      }).toList(),
    );
  }
  late DataPost post;
  DataPersonalInformationViewModel? person;
  @override
  void initState() {
    super.initState();
    person = widget.post.person;
    post = widget.post;
  }
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: max,
      padding: EdgeInsets.symmetric(horizontal: doubleWidth(3)),
      child: Container(
        decoration:
        BoxDecoration(border: Border(bottom: BorderSide(color: grayCall))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ListTile(
              onTap: widget.canTouch
                  ? () {
                Go.pushSlideAnim(
                    context,
                    Shot(
                      post: widget.post,
                    ));
              }
                  : null,
              contentPadding: EdgeInsets.zero,
              dense: true,
              leading: SizedBox(
                width: doubleWidth(13),
                child: Stack(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: SizedBox(
                          width: doubleHeight(5),
                          height: doubleHeight(5),
                          child: Builder(
                            builder: (context) {
                              if (person != null &&
                                  person!.profilePhoto != null) {
                                return imageNetwork(
                                  person!.profilePhoto!,
                                  fit: BoxFit.fill,
                                );
                              }
                              return const SizedBox();
                            },
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment(1, -1),
                      child: SizedBox(
                        width: doubleHeight(3),
                        height: doubleHeight(3),
                        child: Builder(
                          builder: (context) {
                            if (person != null &&
                                person!.team != null &&
                                person!.team!.team_badge != null) {
                              return Container(
                                decoration: BoxDecoration(
                                    color: white,
                                    border: Border.all(color: white, width: 2),
                                    borderRadius: BorderRadius.circular(100),
                                    image: DecorationImage(
                                      image: networkImage(
                                          person!.team!.team_badge!),
                                    )),
                              );
                            }
                            return const SizedBox();
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
              title: Builder(builder: (context) {
                if (person != null && person!.fullName != null)
                  return Text(
                    person!.fullName!,
                    style: TextStyle(
                        color: black,
                        fontWeight: FontWeight.bold,
                        fontSize: doubleWidth(3.5)),
                  );
                return Text(
                  '',
                  style: TextStyle(
                      color: black,
                      fontWeight: FontWeight.bold,
                      fontSize: doubleWidth(3.5)),
                );
              }),
              subtitle: Builder(builder: (context) {
                if (person != null && person!.fullName != null)
                  return Text('@${person!.fullName!}',
                      style: TextStyle(
                          color: grayCall,
                          fontWeight: FontWeight.bold,
                          fontSize: doubleWidth(2.5)));
                return Text('',
                    style: TextStyle(
                        color: grayCall,
                        fontWeight: FontWeight.bold,
                        fontSize: doubleWidth(2.5)));
              }),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(makeDurationToString(widget.post.createdAt),
                      style: TextStyle(
                          color: grayCall,
                          fontWeight: FontWeight.bold,
                          fontSize: doubleWidth(2.5))),
                  SizedBox(width: doubleWidth(4)),
                  GestureDetector(
                    onTap: () {
                      Go.pushSlideAnimSheet(
                          context, MyBottomSheet(widget.post));
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
            _convertHashtag(context, widget.post.details ?? ''),
            sizeh(doubleHeight(1)),
            if (widget.post.mediaTypes.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SizedBox(
                  width: max,
                  height: doubleHeight(15),
                  child: PageView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: widget.post.mediaTypes.length,
                    itemBuilder: (_, index) => imageNetwork(
                      widget.post.mediaTypes[index].media,
                      fit: BoxFit.fill,
                    ),
                  ),
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
                          width: doubleWidth(5),
                          height: doubleWidth(5),
                          child: Image.asset('images/chat(2).png')),
                      sizew(doubleWidth(1)),
                      Text(makeCount(widget.post.postCommentCount))
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
                        onTap: () async {
                          MyService service = await getIt<MyService>();

                          if (!widget.post.postLikedBythisUser) {
                            bool back = await ShotsService.shotLike(service,
                                postId: widget.post.id);
                            if (back)
                              setState(() {
                                widget.post.postLikedBythisUser = true;
                              });
                          } else {
                            bool back = await ShotsService.deleteShotLike(
                                service,
                                shotId: widget.post.id);
                            if (back)
                              setState(() {
                                widget.post.postLikedBythisUser = false;
                              });
                          }
                        },
                        child: Icon(
                            widget.post.postLikedBythisUser
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: widget.post.postLikedBythisUser
                                ? Colors.pink
                                : null),
                      ),
                      sizew(doubleWidth(1)),
                      Text(makeCount(widget.post.postLikeCount))
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (_) => ShareDialog(
                            post: widget.post,
                          ));

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
            ...post.postComments
                .map((e) => Padding(
              padding: EdgeInsets.only(left: doubleWidth(4)),
              child: CommentFromMatch(
                  key: UniqueKey(),
                  comment: e,delete: (){
                int index = post.postComments.indexOf(e);
                List<DataPostComment> temp  =post.postComments.toList();
                temp.removeAt(index);
                setState(() {
                  post.postComments=temp.toList();
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
                            print(
                                'controller.value.text ${controller.value.text}');
                            DataPostComment? back =
                            await ShotsService.shotsComment(
                                getIt<MyService>(),
                                postId: post.id,
                                comment: controller.value.text);
                            if(back!=null){
                              setState(() {
                                post.postComments.add(back);
                              });
                            }
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