import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shooting_app/classes/services/my_service.dart';
import 'package:shooting_app/main.dart';
import 'package:shooting_app/pages/chat/chat_list.dart';
import 'package:image_picker/image_picker.dart';
import '../../classes/functions.dart';
import '../../classes/models.dart';
import '../../classes/services/shots_service.dart';
import '../../classes/dataTypes.dart';
import '../../classes/states/main_state.dart';

class ShootBuilder extends StatelessWidget {
  const ShootBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MainStateProvider(
      child: Shoot(),
    );
  }
}

class Shoot extends StatefulWidget {
  const Shoot({Key? key}) : super(key: key);

  @override
  _ShootState createState() => _ShootState();
}

class _ShootState extends State<Shoot> {
  double? position;
  double? positionStart;
  double pos = 0;
  List<XFile> images = [];
  MyService service = getIt<MyService>();
  TextEditingController controller = TextEditingController();
  bool sending = false;
  sendData(context) async {
    print('sendData()');
    setState(() {
      sending = true;
    });
    DataPost? back = await ShotsService.createShot(service,
        images: images, details: controller.value.text);
    setState(() {
      sending = false;
    });
    print('back $back');
    if (back != null) {
      MainState state = Provider.of(context,listen: false);
      state.allPosts.insert(0, back);
      state.notify();
      Go.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: SizedBox(
          width: double.maxFinite,
          height: doubleHeight(90),
          child: Material(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(20), topLeft: Radius.circular(20)),
            color: Colors.white,
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
                              color: Colors.black,
                              size: 35,
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              'Take a shot',
                              style: TextStyle(
                                  color: Colors.black,
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
                              child: TextField(
                                controller: controller,
                                minLines: 10,
                                maxLines: 15,
                                textAlign: TextAlign.left,
                                decoration: InputDecoration(
                                    hintText: 'Take a shot...',
                                    hintStyle: TextStyle(color: grayCall),
                                    border: InputBorder.none
                                    // border: OutlineInputBorder()
                                    ),
                              ),
                            ),
                            if (images.isNotEmpty)
                              SizedBox(
                                width: double.maxFinite,
                                height: doubleWidth(22),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: images
                                        .map((e) => Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                SizedBox(
                                                  width: doubleWidth(22),
                                                  height: doubleWidth(22),
                                                  child: Stack(
                                                    children: [
                                                      Align(
                                                        alignment: Alignment
                                                            .bottomLeft,
                                                        child: SizedBox(
                                                          width:
                                                              doubleWidth(20),
                                                          height:
                                                              doubleWidth(20),
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                            child: SizedBox(
                                                              width:
                                                                  doubleWidth(
                                                                      20),
                                                              height:
                                                                  doubleWidth(
                                                                      20),
                                                              child: Image.file(
                                                                File(e.path),
                                                                fit:
                                                                    BoxFit.fill,
                                                              ),
                                                              // Image.asset(
                                                              //   'images/1668011.jpg',
                                                              //   fit: BoxFit.fill,
                                                              // ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Align(
                                                        alignment:
                                                            Alignment.topRight,
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            setState(() {
                                                              images.remove(e);
                                                            });
                                                          },
                                                          child: CircleAvatar(
                                                            radius: doubleWidth(
                                                                2.5),
                                                            backgroundColor:
                                                                Color.fromRGBO(
                                                                    107,
                                                                    79,
                                                                    187,
                                                                    1),
                                                            child: Icon(
                                                              Icons.close,
                                                              color:
                                                                  Colors.white,
                                                              size: 15,
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                if (e != images.last)
                                                  SizedBox(
                                                      width: doubleWidth(3)),
                                              ],
                                            ))
                                        .toList(),
                                  ),
                                ),
                              )
                          ],
                        )),
                        ClipRRect(
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
                                        sendData(context);
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
                                      child: Image.asset('images/soccer.png'),
                                    ),
                                  ),
                                  left: doubleWidth(1),
                                  bottom: doubleWidth(1) + pos,
                                )
                              ],
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
                      FloatingActionButton(
                        onPressed: () async {
                          XFile? file = await ImagePicker()
                              .pickImage(source: ImageSource.camera);
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
