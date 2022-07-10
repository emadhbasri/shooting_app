import 'dart:async';

import 'package:provider/provider.dart';
import 'package:shooting_app/classes/services/authentication_service.dart';
import 'package:shooting_app/main.dart';
import 'package:shooting_app/pages/chat/chat_list.dart';
import 'package:shooting_app/ui_items/shots/index.dart';
import 'package:uni_links/uni_links.dart';
import '../classes/services/chat_service.dart';
import '../classes/services/my_service.dart';
import '../classes/states/main_state.dart';
import 'package:shooting_app/ui_items/drawer.dart';
import 'chat/search_chat.dart';
import 'group_chat/group_chat.dart';
import 'home/Home.dart';
import 'home/search_user.dart';
import 'my_profile/edit_profile/settings.dart';
import 'my_profile/my_profile.dart';
import 'notification.dart';
import 'profile/profile.dart';
import 'shoot/shoot.dart';
import 'shot/shot.dart';

class AppPageBuilder extends StatelessWidget {
  const AppPageBuilder({Key? key,this.update=false}) : super(key: key);
  final bool update;
  @override
  Widget build(BuildContext context) {
    return MainStateProvider(
      child: AppPage(update:update),
    );
  }
}

class AppPage extends StatefulWidget {
  final bool update;

  const AppPage({Key? key, required this.update}) : super(key: key);
  @override
  _AppPageState createState() => _AppPageState();
}

class _AppPageState extends State<AppPage> {

  @override
  void initState() {
    super.initState();
    statusSet(mainBlue);
    MainState state = Provider.of(context, listen: false);
    // state.receiveShare(update: widget.update);
    state.getProfile();
    _handleIncomingLinks(context);
    // deviceData();
  }
  void _handleIncomingLinks(context) async{
    print('_handleIncomingLinks');
    if(mainUri!=null){
    await Future.delayed(Duration(milliseconds: 500));
      Map<String, String> query=mainUri!.queryParameters;
      String key = query.keys.first;
      String value = query.values.first;

      if(key.toLowerCase()=='shot'){
        Go.pushSlideAnim(
            context,
            Shot(
              postId: value,
            ));
      }else if(key.toLowerCase()=='user'){
        Go.pushSlideAnim(context,
            ProfileBuilder(username: value));
      }else if(key.toLowerCase()=='joinchat'){
        DataChatRoom? back = await ChatService.joinGroupChat(getIt<MyService>(),
            chatRoomId: value, userId: getIt<MainState>().userId);
        print('back $back');
        if(back!=null) {
          await Go.pushSlideAnim(
              context,
              GroupChatBuilder(
                chatRoom: back,
              ));
        }
      }
    }

  }
  int currentIndex = 0;
  int subIndex = 1;

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
              Go.pushSlideAnim(context, SearchUser());
              // Go.pushSlideAnim(context, Search());
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
          'Messages'.toUpperCase(),
          style: TextStyle(color: white),
        ),
        actions: [
          IconButton(onPressed: (){
            Go.pushSlideAnim(context, SearchChat());
          }, icon: Icon(Icons.message))
        ],
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
          'notification'.toUpperCase(),
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
          'Profile'.toUpperCase(),
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
              if (currentIndex == 0) {
                if (state.isOnMatchPage) {
                  return true;
                } else {
                  if (state.tab == MyTab.fanFeed) {
                    return true;
                  }
                  state.tab = MyTab.fanFeed;
                  state.notify();
                  print('testaaa');
                  setState(() {
                    subIndex = 0;
                  });
                  Future.delayed(Duration(milliseconds: 50), () {
                    setState(() {
                      subIndex = 1;
                    });
                  });
                  return false;
                }
              } else {
                setState(() {
                  currentIndex = 0;
                });
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
              return subIndex == 1 ? Home() : const SizedBox();
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
                    Provider.of<MainState>(context, listen: false)
                        .listController
                        .animateTo(0,
                            duration: Duration(seconds: 1),
                            curve: Curves.linear);
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
                              ? Image.asset('assets/images/homebuttom2.png')
                              : Image.asset('assets/images/homebuttom.png'),
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
                                      ? Image.asset('assets/images/chat.png')
                                      : Image.asset(
                                          'assets/images/chat(1).png'),
                                ),
                                // Align(
                                //     alignment: Alignment(1.4, -1.1),
                                //     child: Container(
                                //       decoration: BoxDecoration(
                                //           color: mainGreen,
                                //           borderRadius:
                                //               BorderRadius.circular(100)),
                                //       width: doubleWidth(3.5),
                                //       height: doubleWidth(3.5),
                                //     )),
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
                      onPressed: () {
                        if (currentIndex == 0) {
                          MainState state = Provider.of(context, listen: false);
                          if (state.tab == MyTab.stadia) {
                            Go.pushSlideAnimSheet(context, ShootBuilder(stadia: true));
                          }else if (state.tab == MyTab.fanFeed) {
                            Go.pushSlideAnimSheet(context, ShootBuilder());
                          } else if (state.tab == MyTab.games) {
                            if (state.isOnMatchPage) {
                              if (state.match!.home.id.toString() ==
                                      state.personalInformation!.team!
                                          .team_key ||
                                  state.match!.away.id.toString() ==
                                      state.personalInformation!.team!
                                          .team_key) {
                                if (state.match!.isLive == 0) {
                                  toast('Match Is Not Started');
                                } else if (state.match!.isLive == 2) {
                                  toast('The Match In Finished.');
                                } else {
                                  Go.pushSlideAnimSheet(
                                      context,
                                      ShootBuilder(
                                        matchId: state.match!.fixture.id,
                                      ));
                                }
                              } else {
                                toast(
                                    'You Are Not Allowed To Shoot For This Match.');
                              }
                            } else {
                              toast('Please Select A Match.');
                            }
                          } else {
                            state.tab = MyTab.fanFeed;
                            state.notify();
                          }
                        } else {
                          setState(() {
                            currentIndex = 0;
                          });
                        }
                      },
                      elevation: 0,
                      backgroundColor: mainGreen,
                      child: Container(
                          width: doubleWidth(9),
                          height: doubleWidth(9),
                          child: Ball()),
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
                                ? Icon(
                                    Icons.notifications_active_rounded,
                                    color: Colors.deepPurple,
                                    size: 34,
                                  )
                                // Image.asset('assets/images/flashlight.png')
                                : Icon(
                                    Icons.notifications_none,
                                    size: 34,
                                    color: Colors.grey,
                                  )
                            // Image.asset('assets/images/flashlight(1).png'),
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
                                          image: DecorationImage(
                                            image: AssetImage(
                                                'assets/images/player.png'),
                                            fit: BoxFit.fill,
                                          ),
                                          // color: grayCall,
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


  @override
  void didChangeDependencies() async{
    super.didChangeDependencies();
    print('didChangeDependencies');
    MainState state = getIt<MainState>();
    state.appPageContext=context;
  }

}

class Ball extends StatefulWidget {
  const Ball({Key? key}) : super(key: key);

  @override
  State<Ball> createState() => _BallState();
}

class _BallState extends State<Ball> {
  int centerButton = 1;
  loopChange() async {
    if (centerButton == 1) {
      setState(() {
        centerButton = 2;
      });
    } else if (centerButton == 2) {
      setState(() {
        centerButton = 3;
      });
    } else {
      setState(() {
        centerButton = 1;
      });
    }
    await Future.delayed(Duration(seconds: 2));
    loopChange();
  }

  @override
  Widget build(BuildContext context) {
    if (centerButton == 1)
      return Image.asset('assets/images/soccer.png');
    else if (centerButton == 2) {
      return Image.asset('assets/images/football (1).png');
    } else
      return Image.asset('assets/images/soccer(1).png');
  }

  @override
  void initState() {
    super.initState();
    loopChange();
  }
}
