import 'package:flutter/material.dart';
import 'package:shooting_app/classes/states/main_state.dart';
import 'package:shooting_app/dataTypes.dart';
// import '../pages/home/mach/match_list.dart';

import '../classes/functions.dart';
import '../main.dart';
import '../pages/AppPage.dart';
import '../pages/my_profile/edit_profile/settings.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({Key? key, required this.page}) : super(key: key);
  final String page;
  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: 500), value: 0);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: trans,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            _controller.reverse().then((value) => Go.pop(context, null));
          },
        ),
        title: Text('Menu'),
      ),
      body: SizedBox.expand(
          child: Stack(
        children: [
          GestureDetector(
            onTap: () {
              _controller.reverse().then((value) => Go.pop(context, null));
            },
          ),
          AlignTransition(
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: doubleWidth(8), vertical: doubleHeight(2)),
              width: double.maxFinite,
              // height: doubleHeight(30),
              color: Color.fromRGBO(244, 244, 244, 1),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if(getIt<MainState>().personalInformation!=null)
                  ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 0),
                    leading: Container(
                        width: doubleWidth(15),
                        height: doubleWidth(15),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: getIt<MainState>().personalInformation!.profilePhoto
                                    !=null?
                                imageNetwork(getIt<MainState>().personalInformation!.profilePhoto??'',fit: BoxFit.fill):null),
                            Align(
                              alignment: Alignment(1, -0.9),
                              child: SizedBox(
                                width: doubleHeight(3),
                                height: doubleHeight(3),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: white,
                                      border:
                                          Border.all(color: white, width: 3),
                                      borderRadius: BorderRadius.circular(100),
                                      image: getIt<MainState>().personalInformation!.team!=null
                                          && getIt<MainState>().personalInformation!.team!.team_badge!=null?DecorationImage(
                                        image: networkImage(getIt<MainState>().personalInformation!.team!.team_badge!),
                                      ):null),
                                ),
                              ),
                            )
                          ],
                        )),
                    title: Text(getIt<MainState>().personalInformation!.fullName??''),
                    subtitle: Text('@${getIt<MainState>().personalInformation!.userName??''}'),
                  ),
                  ListTile(
                    onTap: () {
                      if (widget.page == 'home') {
                        _controller
                            .reverse()
                            .then((value) => Go.pop(context, null));
                      } else {
                        _controller.reverse().then((value) {
                          Go.pop(context, null);
                          Go.pushAndRemoveSlideAnim(context, AppPageBuilder());
                        });
                      }
                    },
                    contentPadding: EdgeInsets.symmetric(horizontal: 0),
                    title: Text(
                      'Home',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.black,
                      size: 20,
                    ),
                  ),
                  // ListTile(
                  //   onTap: (){
                  //     if(widget.page=='live scores'){
                  //       _controller.reverse().then((value) => Go.pop(context, null));
                  //     }else{
                  //       _controller.reverse().then((value) {
                  //         Go.pop(context, null);
                  //         Go.pushSlideAnim(context, MatchListBuilder());
                  //       });
                  //     }
                  //   },
                  //   contentPadding: EdgeInsets.symmetric(horizontal: 0),
                  //   title: Text(
                  //     'Live Scores',
                  //     style: TextStyle(fontWeight: FontWeight.bold),
                  //   ),
                  //   trailing: Icon(
                  //     Icons.arrow_forward_ios,
                  //     color: Colors.black,
                  //     size: 20,
                  //   ),
                  // ),
                  ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 0),
                    title: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'SQUADS ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '*coming soon*',
                          style: TextStyle(color: mainBlue, fontSize: 12),
                        ),
                      ],
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.black,
                      size: 20,
                    ),
                  ),
                  Divider(color: Colors.black),
                  ListTile(
                    onTap: () {
                      _controller.reverse().then((value) {
                        Go.pop(context, null);
                        Go.pushSlideAnim(context, Settings());
                      });
                    },
                    contentPadding: EdgeInsets.symmetric(horizontal: 0),
                    title: Text(
                      'Settings',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.black,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
            alignment:
                Tween<Alignment>(begin: Alignment(0, -3), end: Alignment(0, -1))
                    .animate(_controller),
          ),
        ],
      )),
    );
  }
}
