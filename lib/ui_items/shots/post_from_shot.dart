import 'package:shooting_app/classes/my_service.dart';

import '../../main.dart';
import '../../pages/shot/shot.dart';
import 'index.dart';

class PostFromShot extends StatefulWidget {
  const PostFromShot({Key? key, required this.post, required this.onTapTag})
      : super(key: key);
  final DataPost post;
  final Function(String) onTapTag;
  @override
  State<PostFromShot> createState() => _PostFromShotState();
}

class _PostFromShotState extends State<PostFromShot> {
  Widget _convertHashtag(String text) {
    List<String> split = text.split(' ');
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
              onTap: () {
                Go.pushSlideAnim(
                    context,
                    Shot(
                      post: widget.post,
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
            _convertHashtag(widget.post.details ?? ''),
            sizeh(doubleHeight(1)),
            if(widget.post.mediaTypes.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SizedBox(
                  width: max,
                  height: doubleHeight(15),
                  child: PageView.builder(
                    physics: BouncingScrollPhysics(),

                    itemCount: widget.post.mediaTypes.length,
                    itemBuilder: (_,index)=>imageNetwork(widget.post.mediaTypes[index].media!,fit: BoxFit.fill,),
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
                      Text('${widget.post.postCommentCount}k')
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
                          bool back = await ShotsService.shotLike(service,
                              postId: widget.post.id);
                          if (back)
                            setState(() {
                              widget.post.postLikedBythisUser = true;
                            });
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
                      Text('${widget.post.postLikeCount}k')
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

class PostFromShotProfile extends StatefulWidget {
  const PostFromShotProfile(
      {Key? key,
      required this.person,
      required this.post,
      required this.onTapTag})
      : super(key: key);
  final DataPost post;
  final DataPersonalInformation person;
  final Function(String) onTapTag;
  @override
  State<PostFromShotProfile> createState() => _PostFromShotProfileState();
}

class _PostFromShotProfileState extends State<PostFromShotProfile> {
  Widget _convertHashtag(String text) {
    List<String> split = text.split(' ');
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
            _convertHashtag(widget.post.details ?? ''),
            sizeh(doubleHeight(1)),
            if(widget.post.mediaTypes.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SizedBox(
                  width: max,
                  height: doubleHeight(15),
                  child: PageView.builder(
                    physics: BouncingScrollPhysics(),

                    itemCount: widget.post.mediaTypes.length,
                      itemBuilder: (_,index)=>imageNetwork(widget.post.mediaTypes[index].media!,fit: BoxFit.fill,),
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
                      // sizew(doubleWidth(1)),
                      // Text('${widget.post.postCommentCount}k')
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
                          bool back = await ShotsService.shotLike(service,
                              postId: widget.post.id);
                          if (back)
                            setState(() {
                              widget.post.postLikedBythisUser = true;
                            });
                        },
                        child: Icon(
                            widget.post.postLikedBythisUser
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: widget.post.postLikedBythisUser
                                ? Colors.pink
                                : null),
                      ),
                      // sizew(doubleWidth(1)),
                      // Text('${widget.post.postLikeCount}k')
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
