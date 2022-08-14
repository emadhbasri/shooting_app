import 'package:flutter/material.dart';
import 'package:shooting_app/classes/services/my_service.dart';
import 'package:shooting_app/main.dart';
import 'package:shooting_app/pages/shoot/search_user_mention.dart';
import '../../classes/functions.dart';
import '../../classes/models.dart';
import '../../classes/dataTypes.dart';
import '../../classes/services/shots_service.dart';
import '../../classes/states/theme_state.dart';
import 'package:provider/provider.dart';
class EditReply extends StatefulWidget {
  final DataCommentReply reply;
  const EditReply({
    Key? key,
    required this.reply,
  }) : super(key: key);
  @override
  _EditReplyState createState() => _EditReplyState();
}

class _EditReplyState extends State<EditReply> {
  double? position;
  double? positionStart;
  double pos = 0;
  MyService service = getIt<MyService>();
  TextEditingController controller = TextEditingController();
  bool sending = false;
  editData(context) async {
    if (sending) return;
    setState(() {
      sending = true;
    });

    if (controller.value.text.trim() == '') {
      toast('You Can Upload Images Or Video');
      await Future.delayed(Duration(seconds: 1));
      setState(() {
        sending = false;
      });
    } else {
      DataCommentReply? back = await ShotsService.editReply(service,
          replyId: widget.reply.id, reply: controller.value.text);
      setState(() {
        sending = false;
      });
      print('back sendData $back');
      if (back != null) {
        Go.pop(context, back);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.reply.replyDetail ?? '');
  }

  bool isInOtherPage = false;
  @override
  Widget build(BuildContext context) {
    // bool isDarkMode = getIt<ThemeState>().isDarkMode;

    return SizedBox.expand(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: SizedBox(
          width: double.maxFinite,
          height: doubleHeight(90),
          child: Material(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(20), topLeft: Radius.circular(20)),
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
                              color: context.watch<ThemeState>().isDarkMode ? Colors.white : Colors.black,
                              size: 35,
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              'Take a shot',
                              style: TextStyle(
                                  color:
                                      context.watch<ThemeState>().isDarkMode ? Colors.white : Colors.black,
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
                                        await Go.pushSlideAnim(
                                            context, SearchUserMention());
                                    print(
                                        'controller.value.text ${controller.value.text}');
                                    controller.text = controller.value.text
                                        .substring(0,
                                            controller.value.text.length - 1);
                                    print(
                                        'controller.value.subText ${controller.value.text}');
                                    print('user ${user}');
                                    if (user != null) {
                                      String pp = '';
                                      if (!controller.value.text.endsWith(' '))
                                        pp = ' ';
                                      controller.text = controller.value.text +
                                          pp +
                                          '@' +
                                          user.userName +
                                          ' ';
                                    }
                                    isInOtherPage = false;
                                  }
                                },
                                decoration: InputDecoration(
                                    hintText: 'Take a shot...',
                                    hintStyle: TextStyle(color: grayCall),
                                    border: InputBorder.none
                                    // border: OutlineInputBorder()
                                    ),
                              ),
                            ),
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
                                      onVerticalDragStart:
                                          (DragStartDetails e) {
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
                                      onVerticalDragUpdate:
                                          (DragUpdateDetails e) {
                                        setState(() {
                                          position = e.globalPosition.dy;
                                          if (positionStart != null &&
                                              position != null) {
                                            pos = positionStart! - position!;
                                          }
                                        });
                                        if (doubleHeight(25) < pos &&
                                            sending == false) {
                                          editData(context);
                                        }
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: greenCall,
                                            borderRadius:
                                                BorderRadius.circular(100),
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
                                            : Image.asset(
                                                'assets/images/soccer.png'),
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
                      Text(
                        'Swipe up to take the shot',
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
