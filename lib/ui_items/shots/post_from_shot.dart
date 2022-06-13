import 'package:shooting_app/classes/services/my_service.dart';
import 'package:shooting_app/pages/group_chat/group_chat.dart';
import 'package:shooting_app/ui_items/dialogs/dialog1.dart';
import 'package:shooting_app/ui_items/gal.dart';
import 'package:shooting_app/ui_items/shots/video_item.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

import '../../classes/services/chat_service.dart';
import '../../classes/services/shots_service.dart';
import '../../classes/states/main_state.dart';
import '../../main.dart';
import '../../package/any_link_preview/src/helpers/link_preview.dart';
import '../../pages/profile/profile.dart';
import '../../pages/shot/shot.dart';
import 'comment_from_shot.dart';
import 'index.dart';

class PostFromShot extends StatefulWidget {
  const PostFromShot(
      {Key? key,
      this.canTouch = true,
      required this.post,
      required this.delete,
      required this.onTapTag})
      : super(key: key);
  final DataPost post;
  final VoidCallback delete;
  final Function(BuildContext, String, bool) onTapTag;
  final bool canTouch;
  @override
  State<PostFromShot> createState() => _PostFromShotState();
}

class _PostFromShotState extends State<PostFromShot> {
  // Widget _convertHashtag(context, String text) {
  //   List<String> split = text.split(' ');
  //   return Wrap(
  //     alignment: WrapAlignment.start,
  //     crossAxisAlignment: WrapCrossAlignment.start,
  //     runAlignment: WrapAlignment.start,
  //     spacing: 3,
  //     children: split.map((e) {
  //       if (e.length == 0) return Text('');
  //       // if (e[0] == '#') {
  //       //   return GestureDetector(
  //       //     onLongPress: (){
  //       //       copyText(text);
  //       //     },
  //       //       onTap: () {
  //       //         widget.onTapTag(context, e, false);
  //       //       },
  //       //       child: Text(e, style: TextStyle(color: mainBlue)));
  //       // } else
  //       if (e[0] == '@') {
  //         return GestureDetector(
  //             onLongPress: () {
  //               copyText(text);
  //             },
  //             onTap: () {
  //               widget.onTapTag(context, e, true);
  //             },
  //             child: Text(e, style: TextStyle(color: mainBlue)));
  //       } else if (e.startsWith('http')) {
  //         return GestureDetector(
  //             onLongPress: () {
  //               copyText(text);
  //             },
  //             onTap: () {
  //               openUrl(e);
  //             },
  //             child: Text(e, style: TextStyle(color: mainBlue)));
  //       } else {
  //         return GestureDetector(
  //             onLongPress: () {
  //               copyText(text);
  //             },
  //             child: Text(e, style: TextStyle(color: black)));
  //       }
  //     }).toList(),
  //   );
  // }
  Widget _convertHashtag(context, String text) {
    // List<String> split = text.split(' ');
    //
    // List<Widget> out = [];
    // split.forEach((e) {
    //   if (e.trim().contains('\n')) {
    //     List<String> split1 = e.split('\n');
    //     if (split1.isNotEmpty)
    //       split1.forEach((String f) {
    //         print('ff: $f ${f.length}');
    //         if (f.length == 0) {
    //           out.add(Text(''));
    //         } else {
    //           if (f[0] == '@') {
    //             out.add(GestureDetector(
    //                 onLongPress: () {
    //                   copyText(text);
    //                 },
    //                 onTap: () {
    //                   widget.onTapTag(context, f, true);
    //                 },
    //                 child: Text(f, style: TextStyle(color: mainBlue))));
    //           } else if (f.contains('http://') || f.contains('https://')) {
    //             out.add(SizedBox(
    //               width: double.maxFinite,
    //               // height: 100,
    //               child: AnyLinkPreview(
    //                 doIt: () {},
    //                 key: UniqueKey(),
    //                 link: f.trim(),
    //                 displayDirection: UIDirection.uiDirectionHorizontal,
    //                 cache: const Duration(seconds: 1),
    //                 backgroundColor: Colors.white,
    //                 boxShadow: [],
    //                 urlLaunchMode: LaunchMode.platformDefault,
    //                 errorWidget: Container(
    //                   color: Colors.grey[300],
    //                   child: const Text('Oops!'),
    //                 ),
    //                 // errorImage: _errorImage,
    //               ),
    //             ));
    //             //
    //             // return GestureDetector(
    //             //     onLongPress: () {
    //             //       copyText(text);
    //             //     },
    //             //     onTap: () {
    //             //       openUrl(e);
    //             //     },
    //             //     child: Text(e, style: TextStyle(color: mainBlue)));
    //           } else {
    //             out.add(GestureDetector(
    //                 onLongPress: () {
    //                   copyText(text);
    //                 },
    //                 child: Text(f, style: TextStyle(color: black))));
    //           }
    //         }
    //       });
    //   } else {
    //     if (e.length == 0) {
    //       out.add(Text(''));
    //     } else {
    //       if (e[0] == '@') {
    //         out.add(GestureDetector(
    //             onLongPress: () {
    //               copyText(text);
    //             },
    //             onTap: () {
    //               widget.onTapTag(context, e, true);
    //             },
    //             child: Text(e, style: TextStyle(color: mainBlue))));
    //       } else if (e.contains('http://') || e.contains('https://')) {
    //         out.add(SizedBox(
    //           width: double.maxFinite,
    //           // height: 100,
    //           child: AnyLinkPreview(
    //             doIt: () {},
    //             key: UniqueKey(),
    //             link: e.trim(),
    //             displayDirection: UIDirection.uiDirectionHorizontal,
    //             cache: const Duration(seconds: 1),
    //             backgroundColor: Colors.white,
    //             boxShadow: [],
    //             urlLaunchMode: LaunchMode.platformDefault,
    //             errorWidget: Container(
    //               color: Colors.grey[300],
    //               child: const Text('Oops!'),
    //             ),
    //             // errorImage: _errorImage,
    //           ),
    //         ));
    //         //
    //         // return GestureDetector(
    //         //     onLongPress: () {
    //         //       copyText(text);
    //         //     },
    //         //     onTap: () {
    //         //       openUrl(e);
    //         //     },
    //         //     child: Text(e, style: TextStyle(color: mainBlue)));
    //       } else {
    //         out.add(GestureDetector(
    //             onLongPress: () {
    //               copyText(text);
    //             },
    //             child: Text(e, style: TextStyle(color: black))));
    //       }
    //     }
    //   }
    // });
    //
    // return Wrap(
    //   alignment: WrapAlignment.start,
    //   crossAxisAlignment: WrapCrossAlignment.start,
    //   runAlignment: WrapAlignment.start,
    //   spacing: 3,
    //   runSpacing: 3,
    //   children: out,
    // );
    return Wrap(
      alignment: WrapAlignment.start,
      crossAxisAlignment: WrapCrossAlignment.start,
      runAlignment: WrapAlignment.start,
      spacing: 3,
      runSpacing: 3,
      children: makeText(text).map((e) {
        switch(e.type){
          case TextType.text:
            return GestureDetector(
                onLongPress: () {
                  copyText(e.text);
                },
                child: Text(e.text, style: TextStyle(color: black)));
          case TextType.link:
            return SizedBox(
              width: double.maxFinite,
              // height: 100,
              child: AnyLinkPreview(
                key: Key('${widget.post.id}fanfeed'),
                link: e.text.trim(),
                doIt: () {},
                displayDirection: UIDirection.uiDirectionHorizontal,
                cache: const Duration(seconds: 1),
                backgroundColor: Colors.white,
                boxShadow: [],
                urlLaunchMode: LaunchMode.externalApplication,
                errorWidget: Container(
                  color: Colors.grey[300],
                  child: const Text('Oops!'),
                ),
                // errorImage: _errorImage,
              ),
            );
          case TextType.groupLink:
            return GestureDetector(
                onTap: () async{
                  String chatRoomId = e.text.replaceAll('FootballBuzz_Group:', '');
                  DataChatRoom? back = await ChatService.joinGroupChat(getIt<MyService>(),
                      chatRoomId: chatRoomId, userId: getIt<MainState>().userId);
                  if(back!=null)
                    Go.pushSlideAnim(context, GroupChatBuilder(chatRoom: back));
                },
                child: Text(e.text, style: TextStyle(color: mainBlue)));
          case TextType.user:
            return GestureDetector(
                onLongPress: () {
                  copyText(e.text);
                },
                onTap: () {
                  widget.onTapTag(context, e.text, true);
                },
                child: Text(e.text, style: TextStyle(color: mainBlue)));
          default:return const SizedBox();
        }

      }).toList(),
    );
  }

  late VideoPlayerController controller;
  bool loadingVideo = true;
  @override
  void initState() {
    super.initState();
    person = widget.post.person;

    init();
  }

  init() async {
    if (widget.post.mediaTypes.isNotEmpty &&
        widget.post.mediaTypes.first.media.contains('video/upload')) {
      controller =
          VideoPlayerController.network(widget.post.mediaTypes.first.media);
      await controller.initialize();
      setState(() {
        loadingVideo = false;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (widget.post.mediaTypes.isNotEmpty &&
        widget.post.mediaTypes.first.media.contains('video/upload'))
      controller.dispose();
  }

  DataPersonalInformationViewModel? person;

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
                if (person != null)
                  Go.pushSlideAnim(
                      context, ProfileBuilder(username: person!.userName));
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
                              return profilePlaceHolder();
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
                      child: Image.asset('assets/images/menu.png'),
                    ),
                  )
                ],
              ),
            ),
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
              dense: true,
              minVerticalPadding: 0,
              contentPadding: EdgeInsets.zero,
              title: _convertHashtag(context, widget.post.details ?? ''),
            ),
            sizeh(doubleHeight(1)),
            if (widget.post.mediaTypes.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SizedBox(
                  width: max,
                  height: doubleWidth(70),
                  child: Builder(builder: (context) {
                    if (widget.post.mediaTypes.isNotEmpty &&
                        widget.post.mediaTypes.first.media
                            .contains('video/upload')) {
                      if (loadingVideo) {
                        return Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const CircularProgressIndicator(),
                              SizedBox(height: doubleHeight(1)),
                              const Text(
                                'loading ...',
                                textDirection: TextDirection.ltr,
                                style: TextStyle(
                                    color: mainBlue,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        );
                      }
                      return Center(
                          child: VideoItem(
                              controller: controller,
                              url: widget.post.mediaTypes.first.media,
                              aspectRatio: 2));
                    } else
                      return PageView.builder(
                        controller: PageController(
                            initialPage: 0, viewportFraction: 0.85),
                        physics: BouncingScrollPhysics(),
                        itemCount: widget.post.mediaTypes.length,
                        itemBuilder: (_, index) => Padding(
                          padding: EdgeInsets.only(
                              right: widget.post.mediaTypes.length - 1 != index
                                  ? doubleHeight(2)
                                  : 0),
                          child: GestureDetector(
                            onTap: () {
                              Go.push(
                                  context,
                                  Gal(
                                      images: widget.post.mediaTypes
                                          .map((e) => e.media)
                                          .toList()));
                            },
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: imageNetwork(
                                  widget.post.mediaTypes[index].media,
                                  fit: BoxFit.fill,
                                )),
                          ),
                        ),
                      );
                  }),
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
                      GestureDetector(
                        onTap: widget.canTouch
                            ? () {
                                Go.pushSlideAnim(
                                    context,
                                    Shot(
                                      post: widget.post,
                                    ));
                              }
                            : null,
                        child: SizedBox(
                            width: doubleWidth(5),
                            height: doubleWidth(5),
                            child: Image.asset('assets/images/chat(2).png',
                                color: greenCall)),
                      ),
                      sizew(doubleWidth(1)),
                      Text(makeCount(widget.post.postComments.length))
                    ],
                  ),
                  // Row(
                  //   mainAxisSize: MainAxisSize.min,
                  //   children: <Widget>[
                  //     SizedBox(
                  //         width: doubleWidth(5),
                  //         height: doubleWidth(5),
                  //         child: Image.asset('assets/images/heart.png')),
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
                            String? back = await ShotsService.shotLike(service,
                                postId: widget.post.id);
                            if (back != null)
                              setState(() {
                                widget.post.postLikes
                                    .add(DataPostLike(back, ''));
                                widget.post.postLikedBythisUser = true;
                                widget.post.postLikeCount++;
                              });
                          } else {
                            if (widget.post.postLikes.isNotEmpty) {
                              bool back = await ShotsService.deleteShotLike(
                                  service,
                                  shotId: widget.post.postLikes.first.id);
                              if (back)
                                setState(() {
                                  widget.post.postLikes.clear();
                                  widget.post.postLikedBythisUser = false;
                                  widget.post.postLikeCount--;
                                });
                            }
                          }
                        },
                        // child: Icon(
                        //     widget.post.postLikedBythisUser
                        //         ? Icons.favorite
                        //         : Icons.favorite_border,
                        //     color: widget.post.postLikedBythisUser
                        //         ? greenCall
                        //         : null),
                        child: Icon(
                            widget.post.postLikes.isNotEmpty
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: widget.post.postLikes.isNotEmpty
                                ? greenCall
                                : null),
                      ),
                      sizew(doubleWidth(1)),
                      Text(makeCount(widget.post.postLikeCount))
                    ],
                  ),
                  if (widget.canTouch &&
                      widget.post.person!.personalInformationId ==
                          getIt<MainState>().userId)
                    GestureDetector(
                      onTap: () async {
                        bool? alert = await MyAlertDialog(context,
                            content: 'Do you want to delete the shot?');
                        // showDialog(
                        //   context: context,
                        //   barrierDismissible: true,
                        //   builder: (BuildContext dialogContext) {
                        //     return ;
                        //   },
                        // );
                        if (alert != null && alert) {
                          MyService service = getIt<MyService>();
                          bool back = await ShotsService.deleteShot(service,
                              shotId: widget.post.id);
                          if (back) {
                            widget.delete();
                          }
                        }
                      },
                      child: SizedBox(
                        width: doubleWidth(5),
                        height: doubleWidth(5),
                        child: Icon(Icons.remove_circle_outline),
                        // child: Image.asset('assets/images/share.png')
                      ),
                    )
                  else
                    SizedBox(
                      width: doubleWidth(5),
                      height: doubleWidth(5),
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
    // List<String> split = text.split(' ');
    //
    // List<Widget> out = [];
    // split.forEach((e) {
    //   if (e.trim().contains('\n')) {
    //     List<String> split1 = e.split('\n');
    //     if (split1.isNotEmpty)
    //       split1.forEach((String f) {
    //         print('ff: $f ${f.length}');
    //         if (f.length == 0) {
    //           out.add(Text(''));
    //         } else {
    //           if (f[0] == '@') {
    //             out.add(GestureDetector(
    //                 onLongPress: () {
    //                   copyText(text);
    //                 },
    //                 onTap: () {
    //                   widget.onTapTag(context, f, true);
    //                 },
    //                 child: Text(f, style: TextStyle(color: mainBlue))));
    //           } else if (f.contains('http://') || f.contains('https://')) {
    //             out.add(SizedBox(
    //               width: double.maxFinite,
    //               // height: 100,
    //               child: AnyLinkPreview(
    //                 key: UniqueKey(), doIt: () {},
    //                 link: f.trim(),
    //                 displayDirection: UIDirection.uiDirectionHorizontal,
    //                 cache: const Duration(seconds: 1),
    //                 backgroundColor: Colors.white,
    //                 boxShadow: [],
    //                 urlLaunchMode: LaunchMode.platformDefault,
    //                 errorWidget: Container(
    //                   color: Colors.grey[300],
    //                   child: const Text('Oops!'),
    //                 ),
    //                 // errorImage: _errorImage,
    //               ),
    //             ));
    //             //
    //             // return GestureDetector(
    //             //     onLongPress: () {
    //             //       copyText(text);
    //             //     },
    //             //     onTap: () {
    //             //       openUrl(e);
    //             //     },
    //             //     child: Text(e, style: TextStyle(color: mainBlue)));
    //           } else {
    //             out.add(GestureDetector(
    //                 onLongPress: () {
    //                   copyText(text);
    //                 },
    //                 child: Text(f, style: TextStyle(color: black))));
    //           }
    //         }
    //       });
    //   } else {
    //     if (e.length == 0) {
    //       out.add(Text(''));
    //     } else {
    //       if (e[0] == '@') {
    //         out.add();
    //       } else if (e.contains('http://') || e.contains('https://')) {
    //         out.add();
    //         //
    //         // return GestureDetector(
    //         //     onLongPress: () {
    //         //       copyText(text);
    //         //     },
    //         //     onTap: () {
    //         //       openUrl(e);
    //         //     },
    //         //     child: Text(e, style: TextStyle(color: mainBlue)));
    //       } else {
    //         out.add(GestureDetector(
    //             onLongPress: () {
    //               copyText(text);
    //             },
    //             child: Text(e, style: TextStyle(color: black))));
    //       }
    //     }
    //   }
    // });

    return Wrap(
      alignment: WrapAlignment.start,
      crossAxisAlignment: WrapCrossAlignment.start,
      runAlignment: WrapAlignment.start,
      spacing: 3,
      runSpacing: 3,
      children: makeText(text).map((e) {
        switch(e.type){
          case TextType.text:
            return GestureDetector(
                onLongPress: () {
                  copyText(e.text);
                },
                child: Text(e.text, style: TextStyle(color: black)));
          case TextType.link:
            return SizedBox(
              width: double.maxFinite,
              // height: 100,
              child: AnyLinkPreview(
                key: Key('${widget.post.id}profile'),
                link: e.text.trim(),
                doIt: () {},
                displayDirection: UIDirection.uiDirectionHorizontal,
                cache: const Duration(seconds: 1),
                backgroundColor: Colors.white,
                boxShadow: [],
                urlLaunchMode: LaunchMode.externalApplication,
                errorWidget: Container(
                  color: Colors.grey[300],
                  child: const Text('Oops!'),
                ),
                // errorImage: _errorImage,
              ),
            );
          case TextType.groupLink:
            return GestureDetector(
                onTap: () async{
                  String chatRoomId = e.text.replaceAll('FootballBuzz_Group:', '');
                  DataChatRoom? back = await ChatService.joinGroupChat(getIt<MyService>(),
                      chatRoomId: chatRoomId, userId: getIt<MainState>().userId);
                  if(back!=null) {
                    await Go.pushSlideAnim(
                        context,
                        GroupChatBuilder(
                          chatRoom: back,
                        ));
                  }
                },
                child: Text(e.text, style: TextStyle(color: mainBlue)));
          case TextType.user:
            return GestureDetector(
                onLongPress: () {
                  copyText(text);
                },
                onTap: () {
                  widget.onTapTag(context, e.text, true);
                },
                child: Text(e.text, style: TextStyle(color: mainBlue)));
          default:return const SizedBox();
        }

      }).toList(),
    );
  }

  late VideoPlayerController controller;
  bool loadingVideo = true;
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    if (widget.post.mediaTypes.isNotEmpty &&
        widget.post.mediaTypes.first.media.contains('video/upload')) {
      controller =
          VideoPlayerController.network(widget.post.mediaTypes.first.media);
      await controller.initialize();
      setState(() {
        loadingVideo = false;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (widget.post.mediaTypes.isNotEmpty &&
        widget.post.mediaTypes.first.media.contains('video/upload'))
      controller.dispose();
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
                        child: GestureDetector(
                          onTap: () {
                            Go.pushSlideAnim(
                                context,
                                ProfileBuilder(
                                    username: widget.person.userName));
                          },
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
                                return profilePlaceHolder();
                              },
                            ),
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
                return Text('@${widget.person.userName}',
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
                      child: Image.asset('assets/images/menu.png'),
                    ),
                  )
                ],
              ),
            ),
            ListTile(
              onTap: () {
                Go.pushSlideAnim(
                    context,
                    Shot(
                      post: widget.post,
                    ));
              },
              dense: true,
              minVerticalPadding: 0,
              contentPadding: EdgeInsets.zero,
              title: _convertHashtag(context, widget.post.details ?? ''),
            ),
            sizeh(doubleHeight(1)),
            if (widget.post.mediaTypes.isNotEmpty)
              Container(
                color: Colors.transparent,
                width: max,
                height: doubleWidth(70),
                child: Builder(builder: (context) {
                  if (widget.post.mediaTypes.isNotEmpty &&
                      widget.post.mediaTypes.first.media
                          .contains('video/upload')) {
                    if (loadingVideo) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const CircularProgressIndicator(),
                            SizedBox(height: doubleHeight(1)),
                            const Text(
                              'loading ...',
                              textDirection: TextDirection.ltr,
                              style: TextStyle(
                                  color: mainBlue, fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      );
                    }
                    return Center(
                      child: VideoItem(
                          controller: controller,
                          url: widget.post.mediaTypes.first.media,
                          aspectRatio: 2),
                    );
                  } else
                    return PageView.builder(
                      controller: PageController(
                          initialPage: 0, viewportFraction: 0.85),
                      physics: BouncingScrollPhysics(),
                      itemCount: widget.post.mediaTypes.length,
                      itemBuilder: (_, index) => Padding(
                        padding: EdgeInsets.only(
                            right: widget.post.mediaTypes.length - 1 != index
                                ? doubleHeight(2)
                                : 0),
                        child: GestureDetector(
                          onTap: () {
                            Go.push(
                                context,
                                Gal(
                                    images: widget.post.mediaTypes
                                        .map((e) => e.media)
                                        .toList()));
                          },
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: imageNetwork(
                                widget.post.mediaTypes[index].media,
                                fit: BoxFit.fill,
                              )),
                        ),
                      ),
                    );
                }),
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
                      GestureDetector(
                        onTap: () {
                          Go.pushSlideAnim(
                              context,
                              Shot(
                                postId: widget.post.id,
                              ));
                        },
                        child: SizedBox(
                            width: doubleWidth(5),
                            height: doubleWidth(5),
                            child: Image.asset('assets/images/chat(2).png',
                                color: greenCall)),
                      ),
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
                  //         child: Image.asset('assets/images/heart.png')),
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
                            String? back = await ShotsService.shotLike(service,
                                postId: widget.post.id);
                            if (back != null)
                              setState(() {
                                widget.post.postLikes
                                    .add(DataPostLike(back, ''));
                                widget.post.postLikedBythisUser = true;
                                widget.post.postLikeCount++;
                              });
                          } else {
                            if (widget.post.postLikes.isNotEmpty) {
                              bool back = await ShotsService.deleteShotLike(
                                  service,
                                  shotId: widget.post.postLikes.first.id);
                              if (back)
                                setState(() {
                                  widget.post.postLikes.clear();
                                  widget.post.postLikedBythisUser = false;
                                  widget.post.postLikeCount--;
                                });
                            }
                          }
                        },
                        child: Icon(
                            widget.post.postLikedBythisUser
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: widget.post.postLikedBythisUser
                                ? greenCall
                                : null),
                      ),
                      sizew(doubleWidth(1)),
                      Text(makeCount(widget.post.postLikeCount))
                    ],
                  ),
                  if (widget.canDelete)
                    GestureDetector(
                      onTap: () async {
                        print('canDelete ${widget.canDelete}');
                        // DataPost? backDialog = await showDialog(
                        //     context: context,
                        //     builder: (_) => ShareDialog(
                        //       canDelete: widget.canDelete,
                        //       post: widget.post,
                        //     ));
                        // if(backDialog!=null){
                        bool? alert = await MyAlertDialog(context,
                            content: 'Do you want to delete the shot?');
                        // showDialog(
                        //   context: context,
                        //   barrierDismissible: true,
                        //   builder: (BuildContext dialogContext) {
                        //     return ;
                        //   },
                        // );
                        if (alert != null && alert) {
                          MyService service = getIt<MyService>();
                          bool back = await ShotsService.deleteShot(service,
                              shotId: widget.post.id);
                          if (back) {
                            widget.delete();
                          }
                        }
                        // }
                      },
                      child: SizedBox(
                        width: doubleWidth(5),
                        height: doubleWidth(5),
                        child: Icon(Icons.remove_circle_outline),
                        // child: Image.asset('assets/images/share.png')
                      ),
                    )
                  else
                    SizedBox(
                      width: doubleWidth(5),
                      height: doubleWidth(5),
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
      required this.delete,
      required this.post,
      required this.onTapTag})
      : super(key: key);
  final DataPost post;
  final VoidCallback delete;
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
        if (e.length == 0) return Text('');
        // if (e[0] == '#') {
        //   return GestureDetector(onLongPress: (){
        //     copyText(text);
        //   },
        //       onTap: () {
        //         widget.onTapTag(context, e, false);
        //       },
        //       child: Text(e, style: TextStyle(color: mainBlue)));
        // } else
        if (e[0] == '@') {
          return GestureDetector(
              onLongPress: () {
                copyText(text);
              },
              onTap: () {
                widget.onTapTag(context, e, true);
              },
              child: Text(e, style: TextStyle(color: mainBlue)));
        } else if (e.startsWith('http')) {
          return GestureDetector(
              onLongPress: () {
                copyText(text);
              },
              onTap: () {
                openUrl(e);
              },
              child: Text(e, style: TextStyle(color: mainBlue)));
        } else {
          return GestureDetector(
              onLongPress: () {
                copyText(text);
              },
              child: Text(e, style: TextStyle(color: black)));
        }
      }).toList(),
    );
  }

  late DataPost post;
  DataPersonalInformationViewModel? person;
  late VideoPlayerController controller;
  bool loadingVideo = true;
  @override
  void initState() {
    super.initState();
    person = widget.post.person;
    post = widget.post;
    init();
  }

  init() async {
    if (widget.post.mediaTypes.isNotEmpty &&
        widget.post.mediaTypes.first.media.contains('video/upload')) {
      controller =
          VideoPlayerController.network(widget.post.mediaTypes.first.media);
      await controller.initialize();
      setState(() {
        loadingVideo = false;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (widget.post.mediaTypes.isNotEmpty &&
        widget.post.mediaTypes.first.media.contains('video/upload'))
      controller.dispose();
  }

  TextEditingController controllerT = TextEditingController();

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
                        child: GestureDetector(
                          onTap: () {
                            if (person != null)
                              Go.pushSlideAnim(context,
                                  ProfileBuilder(username: person!.userName));
                          },
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
                                return profilePlaceHolder();
                              },
                            ),
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
                      child: Image.asset('assets/images/menu.png'),
                    ),
                  )
                ],
              ),
            ),
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
              dense: true,
              minVerticalPadding: 0,
              contentPadding: EdgeInsets.zero,
              title: _convertHashtag(context, widget.post.details ?? ''),
            ),
            sizeh(doubleHeight(1)),
            if (widget.post.mediaTypes.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SizedBox(
                  width: max,
                  height: doubleWidth(70),
                  child: Builder(builder: (context) {
                    if (widget.post.mediaTypes.isNotEmpty &&
                        widget.post.mediaTypes.first.media
                            .contains('video/upload')) {
                      if (loadingVideo) {
                        return Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const CircularProgressIndicator(),
                              SizedBox(height: doubleHeight(1)),
                              const Text(
                                'loading ...',
                                textDirection: TextDirection.ltr,
                                style: TextStyle(
                                    color: mainBlue,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        );
                      }
                      return Center(
                        child: VideoItem(
                            controller: controller,
                            url: widget.post.mediaTypes.first.media,
                            aspectRatio: 2),
                      );
                    } else
                      return PageView.builder(
                        controller: PageController(
                            initialPage: 0, viewportFraction: 0.85),
                        physics: BouncingScrollPhysics(),
                        itemCount: widget.post.mediaTypes.length,
                        itemBuilder: (_, index) => Padding(
                          padding: EdgeInsets.only(
                              right: widget.post.mediaTypes.length - 1 != index
                                  ? doubleHeight(2)
                                  : 0),
                          child: GestureDetector(
                            onTap: () {
                              Go.push(
                                  context,
                                  Gal(
                                      images: widget.post.mediaTypes
                                          .map((e) => e.media)
                                          .toList()));
                            },
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: imageNetwork(
                                  widget.post.mediaTypes[index].media,
                                  fit: BoxFit.fill,
                                )),
                          ),
                        ),
                      );
                  }),
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
                          child: Image.asset('assets/images/chat(2).png',
                              color: greenCall)),
                      sizew(doubleWidth(1)),
                      Text(makeCount(widget.post.postComments.length))
                    ],
                  ),
                  // Row(
                  //   mainAxisSize: MainAxisSize.min,
                  //   children: <Widget>[
                  //     SizedBox(
                  //         width: doubleWidth(5),
                  //         height: doubleWidth(5),
                  //         child: Image.asset('assets/images/heart.png')),
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
                            String? back = await ShotsService.shotLike(service,
                                postId: widget.post.id);
                            if (back != null)
                              setState(() {
                                widget.post.postLikes
                                    .add(DataPostLike(back, ''));
                                widget.post.postLikedBythisUser = true;
                                widget.post.postLikeCount++;
                              });
                          } else {
                            if (widget.post.postLikes.isNotEmpty) {
                              bool back = await ShotsService.deleteShotLike(
                                  service,
                                  shotId: widget.post.postLikes.first.id);
                              if (back)
                                setState(() {
                                  widget.post.postLikes.clear();
                                  widget.post.postLikedBythisUser = false;
                                  widget.post.postLikeCount--;
                                });
                            }
                          }
                        },
                        child: Icon(
                            widget.post.postLikedBythisUser
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: widget.post.postLikedBythisUser
                                ? greenCall
                                : null),
                      ),
                      sizew(doubleWidth(1)),
                      Text(makeCount(widget.post.postLikeCount))
                    ],
                  ),
                  if (widget.post.person!.personalInformationId ==
                      getIt<MainState>().userId)
                    GestureDetector(
                      onTap: () async {
                        // DataPost? backDialog = await showDialog(
                        //     context: context,
                        //     builder: (_) => ShareDialog(
                        //       canDelete: widget.canDelete,
                        //       post: widget.post,
                        //     ));
                        // if(backDialog!=null){
                        bool? alert = await MyAlertDialog(context,
                            content: 'Do you want to delete the shot?');
                        // showDialog(
                        //   context: context,
                        //   barrierDismissible: true,
                        //   builder: (BuildContext dialogContext) {
                        //     return ;
                        //   },
                        // );
                        if (alert != null && alert) {
                          MyService service = getIt<MyService>();
                          bool back = await ShotsService.deleteShot(service,
                              shotId: widget.post.id);
                          if (back) {
                            widget.delete();
                          }
                        }
                        // }
                      },
                      child: SizedBox(
                        width: doubleWidth(5),
                        height: doubleWidth(5),
                        child: Icon(Icons.remove_circle_outline),
                        // child: Image.asset('assets/images/share.png')
                      ),
                    )
                  else
                    SizedBox(
                      width: doubleWidth(5),
                      height: doubleWidth(5),
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
                          comment: e,
                          delete: () {
                            int index = post.postComments.indexOf(e);
                            List<DataPostComment> temp =
                                post.postComments.toList();
                            temp.removeAt(index);
                            setState(() {
                              post.postComments = temp.toList();
                            });
                          }),
                    ))
                .toList()
              ..add(Padding(
                padding: EdgeInsets.only(left: doubleWidth(8)),
                child: TextField(
                  controller: controllerT,
                  decoration: InputDecoration(
                      hintStyle:
                          TextStyle(color: Color.fromRGBO(214, 216, 217, 1)),
                      suffixIcon: GestureDetector(
                          onTap: () async {
                            print(
                                'controllerT.value.text ${controllerT.value.text}');
                            DataPostComment? back =
                                await ShotsService.shotsComment(
                                    getIt<MyService>(),
                                    postId: post.id,
                                    comment: controllerT.value.text);
                            if (back != null) {
                              setState(() {
                                post.postComments.add(back);
                              });
                            }
                            controllerT.clear();
                          },
                          child: Icon(
                            Icons.send,
                            color: mainBlue,
                          )),
                      hintText: 'Write your comment...',
                      border: InputBorder.none),
                ),
              )),
          ],
        ),
      ),
    );
  }
}
