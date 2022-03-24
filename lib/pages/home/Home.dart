import 'package:flutter/material.dart';
import 'package:shooting_app/classes/services/my_service.dart';
import 'package:shooting_app/pages/home/mach/match_list.dart';

import '../../classes/functions.dart';
import '../../dataTypes.dart';
import '../../main.dart';
import 'fan_feeds.dart';
import 'story/story_list.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}
enum MyTab{
  games,fanFeed,stories
}
class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  MyTab tab = MyTab.fanFeed;

  // List<DataPost> allPosts = [];
  MyService service = getIt<MyService>();
  getData() async {
    // allPosts = await ShotsService.shotsAll(service);
    // setState(() {});
    // print('allPosts ${allPosts.length}');
  }

  @override
  void initState() {
    super.initState();
    // getData();
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
              children: MyTab.values.map((e) =>
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        tab = e;
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
                                child: Builder(
                                  builder: (context) {
                                    switch(e){
                                      case MyTab.games:
                                        return Text(
                                      'Games',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: mainBlue,
                                          fontSize: doubleWidth(4)),
                                    );
                                      case MyTab.fanFeed:
                                        return Text(
                                      'Fan Feeds',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: mainBlue,
                                          fontSize: doubleWidth(4)),
                                    );
                                      case MyTab.stories:
                                        return Text(
                                          'Stories',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: mainBlue,
                                              fontSize: doubleWidth(4)),
                                        );
                                      default:return const SizedBox();
                                    }

                                  }
                                ),
                              ),
                            ),
                            if(tab==e)
                              Align(
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

                          ],
                        ),
                      ),
                    ),
                  )
              ).toList()


            ),
          ),
          Expanded(
              child: Builder(
                builder: (context) {
                  switch(tab){
                    case MyTab.games:
                      return MatchList();
                    case MyTab.fanFeed:
                      return FanFeeds();
                    case MyTab.stories:
                      return const StoryList();
                    default:return const SizedBox();
                  }
                },
              )
          )

        ],
      ),
    );
  }
}


