import 'package:provider/provider.dart';
import 'package:shooting_app/pages/chat/chat_list.dart';
import 'package:shooting_app/ui_items/shots/index.dart';
import '../classes/states/main_state.dart';
import '../main.dart';
import 'package:shooting_app/ui_items/drawer.dart';
import 'home/Home.dart';
import 'Search.dart';
import 'my_profile/edit_profile/settings.dart';
import 'my_profile/my_profile.dart';
import 'notification.dart';
import 'shoot/shoot.dart';

class AppPageBuilder extends StatelessWidget {
  const AppPageBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MainStateProvider(
      child: AppPage(),
    );
  }
}

class AppPage extends StatefulWidget {
  @override
  _AppPageState createState() => _AppPageState();
}

class _AppPageState extends State<AppPage> {
  @override
  void initState() {
    statusSet(mainBlue);
    super.initState();
    MainState state = Provider.of(context, listen: false);
    state.getProfile();
  }

  int currentIndex = 0;
  // loopChange() async {
  //   if (centerButton == 1) {
  //     setState(() {
  //       centerButton = 2;
  //     });
  //   } else if (centerButton == 2) {
  //     setState(() {
  //       centerButton = 3;
  //     });
  //   } else if (centerButton == 3) {
  //     setState(() {
  //       centerButton = 4;
  //     });
  //   } else {
  //     setState(() {
  //       centerButton = 1;
  //     });
  //   }
  //   await Future.delayed(Duration(seconds: 2));
  //   loopChange();
  // }

  // outButtonClick(Widget widget) {
  //   if (buttonClick) {
  //     return Stack(
  //       children: [
  //         widget,
  //         GestureDetector(
  //           onTap: () {
  //             setState(() {
  //               buttonClick = false;
  //             });
  //           },
  //           child: Container(
  //             width: double.maxFinite,
  //             color: Colors.black.withOpacity(0.5),
  //             alignment: Alignment.bottomCenter,
  //             child: Row(
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 Column(
  //                   mainAxisSize: MainAxisSize.min,
  //                   children: [
  //                     Container(
  //                       decoration: BoxDecoration(
  //                         color: greenCall,
  //                         boxShadow: [
  //                           BoxShadow(
  //                               color: Colors.white,
  //                               blurRadius: 44,
  //                               spreadRadius: 0,
  //                               offset: Offset(0, 4))
  //                         ],
  //                         borderRadius: BorderRadius.circular(100),
  //                       ),
  //                       width: doubleWidth(12),
  //                       height: doubleWidth(12),
  //                       padding: EdgeInsets.all(doubleWidth(2.5)),
  //                       child: Image.asset('images/live-stream.png'),
  //                     ),
  //                     SizedBox(height: doubleHeight(1)),
  //                     Text(
  //                       'Go live',
  //                       style: TextStyle(
  //                           color: Colors.white, fontWeight: FontWeight.bold),
  //                     ),
  //                     SizedBox(height: doubleHeight(1)),
  //                   ],
  //                 ),
  //                 SizedBox(width: doubleWidth(15)),
  //                 Column(
  //                   mainAxisSize: MainAxisSize.min,
  //                   children: [
  //                     GestureDetector(
  //                       onTap: () {
  //                         MainState mainS = getIt<MainState>();
  //                         print(
  //                             'shoot Go ${mainS.match} ${mainS.isOnMatchPage}');
  //                         // if(mainS.match!=null && mainS.isOnMatchPage)
  //                         Go.pushSlideAnimSheet(context, Shoot());
  //                       },
  //                       child: Container(
  //                         decoration: BoxDecoration(
  //                           color: greenCall,
  //                           boxShadow: [
  //                             BoxShadow(
  //                                 color: Colors.white,
  //                                 blurRadius: 44,
  //                                 spreadRadius: 0,
  //                                 offset: Offset(0, 4))
  //                           ],
  //                           borderRadius: BorderRadius.circular(100),
  //                         ),
  //                         width: doubleWidth(12),
  //                         height: doubleWidth(12),
  //                         padding: EdgeInsets.all(doubleWidth(2)),
  //                         child: Image.asset('images/football.png'),
  //                       ),
  //                     ),
  //                     SizedBox(height: doubleHeight(1)),
  //                     Text('Shoot',
  //                         style: TextStyle(
  //                             color: Colors.white,
  //                             fontWeight: FontWeight.bold)),
  //                     SizedBox(height: doubleHeight(1)),
  //                   ],
  //                 ),
  //               ],
  //             ),
  //           ),
  //         )
  //       ],
  //     );
  //   } else {
  //     return widget;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    late AppBar appBar;
    if (currentIndex == 0) {
      appBar = AppBar(
        elevation: 0,
        backgroundColor: mainBlue,
        leading: IconButton(
          icon: Icon(
            Icons.menu,
            color: white,
          ),
          onPressed: () {
            Go.pushSlideAnimDrawer(
                context,
                MyDrawer(
                  page: 'home',
                ));
          },
        ),
        centerTitle: true,
        title: Text(
          'HOME',
          style: TextStyle(color: white),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.search,
              color: white,
            ),
            onPressed: () {
              Go.pushSlideAnim(context, Search());
            },
          ),
        ],
      );
    } else if (currentIndex == 1) {
      appBar = AppBar(
        elevation: 0,
        backgroundColor: mainBlue,
        leading: IconButton(
          icon: Icon(
            Icons.menu,
            color: white,
          ),
          onPressed: () {
            Go.pushSlideAnimDrawer(
                context,
                MyDrawer(
                  page: 'home',
                ));
          },
        ),
        centerTitle: true,
        title: Text(
          'Messages',
          style: TextStyle(color: white),
        ),
      );
    } else if (currentIndex == 3) {
      appBar = AppBar(
        elevation: 0,
        backgroundColor: mainBlue,
        leading: IconButton(
          icon: Icon(
            Icons.menu,
            color: white,
          ),
          onPressed: () {
            Go.pushSlideAnimDrawer(
                context,
                MyDrawer(
                  page: 'home',
                ));
          },
        ),
        centerTitle: true,
        title: Text(
          'Live Scores',
          style: TextStyle(color: white),
        ),
      );
    } else if (currentIndex == 4) {
      appBar = AppBar(
        elevation: 0,
        backgroundColor: mainBlue,
        leading: IconButton(
          icon: Icon(
            Icons.menu,
            color: white,
          ),
          onPressed: () {
            Go.pushSlideAnimDrawer(
                context,
                MyDrawer(
                  page: 'home',
                ));
          },
        ),
        centerTitle: true,
        title: Text(
          'Profile',
          style: TextStyle(color: white),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Go.pushSlideAnim(context, Settings());
              },
              icon: Icon(Icons.settings))
        ],
      );
    }

    return Consumer<MainState>(
      builder: (context, state, child) {
        return WillPopScope(
            onWillPop: () async {
              // statusSet(trans);
              if (state.isOnMatchPage && currentIndex == 0) {
                return true;
              } else {
                return false;
              }
            },
            child: child!);
      },
      child: Scaffold(
        appBar: appBar,
        body: Builder(
          builder: (context) {
            // if (currentIndex == 0) {
            //   return outButtonClick(Home());
            // } else if (currentIndex == 1) {
            //   return outButtonClick(ChatListBuilder());
            // } else if (currentIndex == 3) {
            //   return outButtonClick(MyNotification());
            // } else {
            //   return outButtonClick(MyProfileBuilder());
            // }
            if (currentIndex == 0) {
              return Home();
            } else if (currentIndex == 1) {
              return ChatList();
            } else if (currentIndex == 3) {
              return MyNotification();
            } else if (currentIndex == 4) {
              return MyProfile();
            } else
              return const SizedBox();
          },
        ),
        bottomNavigationBar: Container(
          width: max,
          height: doubleHeight(10),
          padding: EdgeInsets.only(bottom: doubleHeight(2)),
          color: white,
          child: Row(
            children: <Widget>[
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      currentIndex = 0;
                    });
                  },
                  child: Stack(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          width: doubleWidth(14),
                          height: max,
                          padding: EdgeInsets.all(doubleWidth(3)),
                          child: currentIndex == 0
                              ? Image.asset('images/homebuttom2.png')
                              : Image.asset('images/homebuttom.png'),
                        ),
                      ),
                      currentIndex == 0
                          ? Align(
                              alignment: Alignment.topCenter,
                              child: Container(
                                width: doubleWidth(12),
                                height: doubleHeight(0.4),
                                decoration: BoxDecoration(
                                    color: Colors.deepPurple,
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(100),
                                      bottomRight: Radius.circular(100),
                                    )),
                              ),
                            )
                          : non
                    ],
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      currentIndex = 1;
                    });
                  },
                  child: Stack(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                            width: doubleWidth(14),
                            height: max,
                            padding: EdgeInsets.all(doubleWidth(3)),
                            child: Stack(
                              children: <Widget>[
                                Align(
                                  alignment: Alignment.center,
                                  child: currentIndex == 1
                                      ? Image.asset('images/chat.png')
                                      : Image.asset('images/chat(1).png'),
                                ),
                                Align(
                                    alignment: Alignment(1.4, -1.1),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: mainGreen,
                                          borderRadius:
                                              BorderRadius.circular(100)),
                                      width: doubleWidth(3.5),
                                      height: doubleWidth(3.5),
                                    )),
                              ],
                            )),
                      ),
                      currentIndex == 1
                          ? Align(
                              alignment: Alignment.topCenter,
                              child: Container(
                                width: doubleWidth(12),
                                height: doubleHeight(0.4),
                                decoration: BoxDecoration(
                                    color: mainBlue,
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(100),
                                      bottomRight: Radius.circular(100),
                                    )),
                              ),
                            )
                          : non
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Container(
                    width: doubleWidth(14),
                    height: doubleWidth(14),
                    decoration: BoxDecoration(boxShadow: [
                      BoxShadow(
                          color: Colors.black38,
                          blurRadius: 10,
                          spreadRadius: -5,
                          offset: Offset(0, 3))
                    ], borderRadius: BorderRadius.circular(100)),
                    child: FloatingActionButton(
                      // padding: EdgeInsets.zero,
                      onPressed: () {
                        Go.pushSlideAnimSheet(context, ShootBuilder());
                        // setState(() {
                        //   buttonClick = !buttonClick;
                        // });
                      },
                      elevation: 0,
                      backgroundColor: mainGreen,
                      child: Builder(
                        builder: (context) {
                          return Container(
                              width: doubleWidth(9),
                              height: doubleWidth(9),
                              child: Image.asset('images/soccer.png'));
                          // if (centerButton == 1) {
                          //   return Icon(
                          //     Icons.add,
                          //     color: white,
                          //     size: doubleWidth(10),
                          //   );
                          // } else if (centerButton == 2) {
                          //   return Icon(
                          //     Icons.add,
                          //     color: mainBlue,
                          //     size: doubleWidth(10),
                          //   );
                          // } else if (centerButton == 3) {
                          //   return Container(
                          //       width: doubleWidth(9),
                          //       height: doubleWidth(9),
                          //       child: Image.asset('images/soccer.png'));
                          // } else {
                          //   return Container(
                          //       width: doubleWidth(9),
                          //       height: doubleWidth(9),
                          //       child: Image.asset('images/soccerBall.png'));
                          // }
                        },
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      currentIndex = 3;
                    });
                  },
                  child: Stack(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          width: doubleWidth(14),
                          height: max,
                          padding: EdgeInsets.all(doubleWidth(3)),
                          child: currentIndex == 3
                              ? Image.asset('images/flashlight.png')
                              : Image.asset('images/flashlight(1).png'),
                        ),
                      ),
                      currentIndex == 3
                          ? Align(
                              alignment: Alignment.topCenter,
                              child: Container(
                                width: doubleWidth(12),
                                height: doubleHeight(0.4),
                                decoration: BoxDecoration(
                                    color: Colors.deepPurple,
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(100),
                                      bottomRight: Radius.circular(100),
                                    )),
                              ),
                            )
                          : non
                    ],
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      currentIndex = 4;
                    });
                  },
                  child: Stack(
                    children: <Widget>[
                      Align(
                          alignment: Alignment.center,
                          child: Container(
                              width: doubleWidth(14),
                              height: doubleWidth(14),
                              padding: EdgeInsets.all(doubleWidth(3)),
                              child: Consumer<MainState>(
                                builder: (context, state, child) {
                                  if (state.personalInformation == null)
                                    return CircularProgressIndicator();
                                  else if (state
                                          .personalInformation!.profilePhoto ==
                                      null)
                                    return Container(
                                      width: doubleWidth(12),
                                      decoration: BoxDecoration(
                                          color: grayCall,
                                          borderRadius:
                                              BorderRadius.circular(100)),
                                    );
                                  else
                                    return Container(
                                      width: doubleWidth(12),
                                      decoration: BoxDecoration(
                                          border: Border.all(color: mainBlue),
                                          image: DecorationImage(
                                              fit: BoxFit.fill,
                                              image: networkImage(state
                                                  .personalInformation!
                                                  .profilePhoto!)),
                                          borderRadius:
                                              BorderRadius.circular(100)),
                                    );
                                },
                              ))),
                      currentIndex == 4
                          ? Align(
                              alignment: Alignment.topCenter,
                              child: Container(
                                width: doubleWidth(12),
                                height: doubleHeight(0.4),
                                decoration: BoxDecoration(
                                    color: Colors.deepPurple,
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(100),
                                      bottomRight: Radius.circular(100),
                                    )),
                              ),
                            )
                          : non
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
