import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:shooting_app/classes/services/my_service.dart';
import 'package:shooting_app/main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shooting_app/pages/shoot/search_user_mention.dart';
import 'package:video_player/video_player.dart';
import '../../classes/functions.dart';
import '../../classes/models.dart';
import '../../classes/services/shots_service.dart';
import '../../classes/dataTypes.dart';
import '../../classes/states/main_state.dart';
import '../../classes/states/theme_state.dart';

class ShootBuilder extends StatelessWidget {
  const ShootBuilder({Key? key, this.matchId, this.stadia = false}) : super(key: key);
  final int? matchId;
  final bool stadia;
  @override
  Widget build(BuildContext context) {
    return MainStateProvider(
      child: Shoot(
        matchId: matchId,
        stadia: stadia,
      ),
    );
  }
}

class Shoot extends StatefulWidget {
  const Shoot({Key? key, this.matchId, this.sharedFiles, this.sharedText, required this.stadia})
      : super(key: key);
  final List<SharedMediaFile>? sharedFiles;
  final String? sharedText;
  final bool stadia;
  final int? matchId;
  @override
  _ShootState createState() => _ShootState();
}

class _ShootState extends State<Shoot> {
  double? position;
  double? positionStart;
  double pos = 0;
  List<XFile> images = [];
  XFile? video;
  MyService service = getIt<MyService>();
  TextEditingController controller = TextEditingController();
  bool sending = false;
  List<String> mediaIds = [];
  editData(context) async {}

  sendData(context) async {
    if (sending) return;
    print('sendData()');
    setState(() {
      sending = true;
    });
    if (controller.value.text.trim() == '' && images.isEmpty && video == null) {
      toast(AppLocalizations.of(context)!.please_enter_text_or_image_or_video);
      await Future.delayed(Duration(seconds: 1));
      setState(() {
        sending = false;
      });
    } else if (images.isNotEmpty && video != null) {
      toast(AppLocalizations.of(context)!.you_can_upload_images_or_video);
      await Future.delayed(Duration(seconds: 1));
      setState(() {
        sending = false;
      });
    } else {
      DataPost? back = await ShotsService.createShot(service,
          matchId: widget.matchId,
          stadia: widget.stadia,
          images: images,
          video: video,
          details: controller.value.text);
      setState(() {
        sending = false;
      });
      print('back sendData $back');
      if (back != null) {
        MainState state = getIt<MainState>();
        if (widget.matchId == null) {
          if (widget.stadia) {
            state.stadiaShots.insert(0, back);
            state.personalInformation!.posts.insert(0, back);
            state.notify();
          } else {
            state.allPosts.insert(0, back);
            state.personalInformation!.posts.insert(0, back);
            state.notify();
          }
        }
        getIt<MainState>().play();
        Go.pop(context);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.sharedText != null) {
      controller = TextEditingController(text: widget.sharedText);
    }
    if (widget.sharedFiles != null) {
      for (int j = 0; j < widget.sharedFiles!.length; j++) {
        if (widget.sharedFiles![j].type == SharedMediaType.IMAGE) {
          images.add(XFile(widget.sharedFiles![j].path, name: widget.sharedFiles![j].path));
        } else if (widget.sharedFiles![j].type == SharedMediaType.VIDEO) {
          video = XFile(widget.sharedFiles![j].path, name: widget.sharedFiles![j].path);
        }
      }
    }
  }

  bool isInOtherPage = false;
  @override
  Widget build(BuildContext context) {
    // bool isDarkMode=getIt<ThemeState>().isDarkMode;
    return SizedBox.expand(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: SizedBox(
          width: double.maxFinite,
          height: doubleHeight(90),
          child: Material(
            borderRadius:
                BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
            color: context.watch<ThemeState>().isDarkMode
                ? MyThemes.darkTheme.scaffoldBackgroundColor
                : MyThemes.lightTheme.scaffoldBackgroundColor,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: doubleWidth(4)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: doubleHeight(2)),
                  SizedBox(
                      width: double.maxFinite,
                      height: doubleHeight(5),
                      child: Stack(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Go.pop(context);
                            },
                            child: Icon(
                              Icons.close,
                              color: context.watch<ThemeState>().isDarkMode
                                  ? Colors.white
                                  : Colors.black,
                              size: 35,
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              AppLocalizations.of(context)!.take_a_shot,
                              style: TextStyle(
                                  color: context.watch<ThemeState>().isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      )),
                  SizedBox(height: doubleHeight(1)),
                  SizedBox(
                    width: double.maxFinite,
                    height: doubleHeight(30),
                    child: Row(
                      children: [
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 2,
                              child: TextFormField(
                                controller: controller,
                                minLines: 10,
                                maxLines: 15,
                                textAlign: TextAlign.left,
                                onChanged: (e) async {
                                  // print('isInOtherPage $')
                                  if (isInOtherPage) return;
                                  if (e.endsWith('@')) {
                                    isInOtherPage = true;
                                    DataPersonalInformation? user =
                                        await Go.pushSlideAnim(context, SearchUserMention());
                                    print('controller.value.text ${controller.value.text}');
                                    controller.text = controller.value.text
                                        .substring(0, controller.value.text.length - 1);
                                    print('controller.value.subText ${controller.value.text}');
                                    print('user ${user}');
                                    if (user != null) {
                                      String pp = '';
                                      if (!controller.value.text.endsWith(' ')) pp = ' ';
                                      controller.text =
                                          controller.value.text + pp + '@' + user.userName + ' ';
                                    }
                                    isInOtherPage = false;
                                  }
                                },
                                decoration: InputDecoration(
                                    hintText: AppLocalizations.of(context)!.take_a_shot_,
                                    hintStyle: TextStyle(color: grayCall),
                                    border: InputBorder.none
                                    // border: OutlineInputBorder()
                                    ),
                              ),
                            ),
                            if (images.isNotEmpty || video != null)
                              SizedBox(
                                width: double.maxFinite,
                                height: doubleWidth(22),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    //
                                    children: [
                                      if (video != null)
                                        SizedBox(
                                          width: doubleWidth(22),
                                          height: doubleWidth(22),
                                          child: Stack(
                                            children: [
                                              Align(
                                                alignment: Alignment.bottomLeft,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(5),
                                                      border:
                                                          Border.all(width: 1, color: mainColor)),
                                                  width: doubleWidth(20),
                                                  height: doubleWidth(20),
                                                  child: ClipRRect(
                                                    borderRadius: BorderRadius.circular(5),
                                                    child: Container(
                                                      width: doubleWidth(20),
                                                      height: doubleWidth(20),
                                                      child: Icon(Icons.video_library),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Align(
                                                alignment: Alignment.topRight,
                                                child: GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      video = null;
                                                    });
                                                  },
                                                  child: CircleAvatar(
                                                    radius: doubleWidth(2.5),
                                                    backgroundColor:
                                                        Color.fromRGBO(107, 79, 187, 1),
                                                    child: Icon(
                                                      Icons.close,
                                                      color: Colors.white,
                                                      size: 15,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ...images
                                          .map((e) => Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  SizedBox(
                                                    width: doubleWidth(22),
                                                    height: doubleWidth(22),
                                                    child: Stack(
                                                      children: [
                                                        Align(
                                                          alignment: Alignment.bottomLeft,
                                                          child: SizedBox(
                                                            width: doubleWidth(20),
                                                            height: doubleWidth(20),
                                                            child: ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius.circular(5),
                                                              child: SizedBox(
                                                                width: doubleWidth(20),
                                                                height: doubleWidth(20),
                                                                child: Image.file(
                                                                  File(e.path),
                                                                  fit: BoxFit.fill,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Align(
                                                          alignment: Alignment.topRight,
                                                          child: GestureDetector(
                                                            onTap: () {
                                                              setState(() {
                                                                images.remove(e);
                                                              });
                                                            },
                                                            child: CircleAvatar(
                                                              radius: doubleWidth(2.5),
                                                              backgroundColor:
                                                                  Color.fromRGBO(107, 79, 187, 1),
                                                              child: Icon(
                                                                Icons.close,
                                                                color: Colors.white,
                                                                size: 15,
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  if (e != images.last)
                                                    SizedBox(width: doubleWidth(3)),
                                                ],
                                              ))
                                          .toList()
                                    ],
                                  ),
                                ),
                              )
                          ],
                        )),
                        AbsorbPointer(
                          absorbing: sending,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Container(
                              width: doubleWidth(20),
                              height: doubleHeight(30),
                              child: Stack(
                                children: [
                                  Positioned(
                                    child: GestureDetector(
                                      onVerticalDragStart: (DragStartDetails e) {
                                        if (positionStart == null)
                                          positionStart = e.globalPosition.dy;
                                      },
                                      onVerticalDragEnd: (DragEndDetails e) {
                                        setState(() {
                                          pos = 0;
                                          positionStart = null;
                                          position = null;
                                        });
                                      },
                                      onVerticalDragUpdate: (DragUpdateDetails e) {
                                        setState(() {
                                          position = e.globalPosition.dy;
                                          if (positionStart != null && position != null) {
                                            pos = positionStart! - position!;
                                          }
                                        });
                                        if (doubleHeight(25) < pos && sending == false) {
                                          sendData(context);
                                        }
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: greenCall,
                                            borderRadius: BorderRadius.circular(100),
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Colors.black45,
                                                  offset: Offset(0, 0),
                                                  blurRadius: 50)
                                            ]),
                                        width: doubleWidth(18),
                                        height: doubleWidth(18),
                                        padding: EdgeInsets.all(doubleWidth(3)),
                                        child: sending
                                            ? simpleCircle()
                                            : Image.asset('assets/images/soccer.png'),
                                      ),
                                    ),
                                    left: doubleWidth(1),
                                    bottom: doubleWidth(1) + pos,
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Divider(color: grayCall, height: doubleHeight(3)),
                  // SizedBox(height: doubleHeight(1)),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FloatingActionButton(
                            heroTag: UniqueKey(),
                            onPressed: () async {
                              XFile? file =
                                  await ImagePicker().pickImage(source: ImageSource.camera);
                              if (file != null) {
                                setState(() {
                                  images.add(file);
                                });
                              }
                            },
                            elevation: 3,
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.camera_alt,
                              color: Color.fromRGBO(107, 79, 187, 1),
                            ),
                          ),
                          SizedBox(width: doubleWidth(2)),
                          FloatingActionButton(
                            heroTag: UniqueKey(),
                            onPressed: () async {
                              List<XFile>? files = await ImagePicker().pickMultiImage();
                              if (files != null) {
                                setState(() {
                                  images.addAll(files);
                                });
                              }
                            },
                            elevation: 3,
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.image,
                              color: Color.fromRGBO(107, 79, 187, 1),
                            ),
                          ),
                          SizedBox(width: doubleWidth(2)),
                          FloatingActionButton(
                            heroTag: UniqueKey(),
                            onPressed: () async {
                              final XFile? video =
                                  await ImagePicker().pickVideo(source: ImageSource.gallery);

                              if (video != null) {
                                print('video.mimeType ${video.name}');

                                if (!video.name.endsWith('.mp4')) {
                                  toast(AppLocalizations.of(context)!.video_mp4);
                                  return;
                                }

                                if (await video.length() > 50000000) {
                                  print('await video.length() ${await video.length()}');
                                  toast(AppLocalizations.of(context)!.video_less_50, isLong: true);
                                  return;
                                }
                                VideoPlayerController _controller =
                                    VideoPlayerController.file(File(video.path));
                                await _controller.initialize();
                                Duration duration = _controller.value.duration;
                                if (duration.inSeconds <= 121) {
                                  setState(() {
                                    this.video = video;
                                  });
                                  //todo
                                } else {
                                  toast(AppLocalizations.of(context)!.video_less_than_60, isLong: true);
                                }
                              }
                            },
                            elevation: 3,
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.video_library_outlined,
                              color: Color.fromRGBO(107, 79, 187, 1),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        AppLocalizations.of(context)!.swipe_up_to_take_the_shot,
                        style: TextStyle(color: grayCall),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
