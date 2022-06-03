import 'package:provider/provider.dart';
import 'package:shooting_app/classes/services/my_service.dart';
import 'package:shooting_app/classes/states/main_state.dart';
import 'package:shooting_app/pages/home/mach/match_list.dart';
import 'package:shooting_app/ui_items/shots/index.dart';

import '../../main.dart';
import 'fan_feeds.dart';
import 'story/story_list.dart';

class Home extends StatefulWidget {
  final int? index;
  const Home({Key? key, this.index}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

enum MyTab { games, fanFeed, stories }

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  MyTab tab = MyTab.fanFeed;
  late TabController controller;
  // List<DataPost> allPosts = [];
  MyService service = getIt<MyService>();
  late MainState state;

  @override
  void initState() {
    super.initState();
    state = Provider.of(context,listen: false);
    controller=TabController(length: 3, vsync: this,initialIndex: 1)..addListener(() {
      switch(controller.index){
        case 0:setState(() {
          tab=MyTab.games;
          state.tab=tab;
        });break;
        case 1:setState(() {
          tab=MyTab.fanFeed;
          state.tab=tab;
        });break;
        case 2:setState(() {
          tab=MyTab.stories;
          state.tab=tab;
        });break;
        default:break;
      }
    });
    tab=state.tab;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromRGBO(244, 244, 244, 1),
      child: Column(
        children: <Widget>[
          Container(
            color: Colors.white,
            child: TabBar(
              labelStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: doubleWidth(4)
              ),
              indicatorColor: mainBlue,
              indicatorPadding: EdgeInsets.symmetric(
                  horizontal: doubleWidth(10)),
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorWeight: doubleHeight(0.4),
              labelColor: mainBlue,
              unselectedLabelColor: mainBlue,
              tabs: [Tab(
                // text: e,
                child: Text(
                  'Games'.toUpperCase(),
                )),
                  Tab(
                    child: Text(
                      'Fan Feeds'.toUpperCase(),
                    ),
                  ),
                  Tab(
                    child: Text(
                      'Stories'.toUpperCase(),
                    ),
                  )
              ],
              controller: controller,
            ),
          ),
          // Container(
          //   color: white,
          //   width: max,
          //   height: doubleHeight(6),
          //   child: Row(
          //       mainAxisAlignment: MainAxisAlignment.spaceAround,
          //       children: MyTab.values
          //           .map((e) => GestureDetector(
          //                 onTap: () {
          //                   setState(() {
          //                     controller.animateTo(e.index);
          //                     tab = e;
          //                     state.tab=e;
          //                   });
          //                 },
          //                 child: Container(
          //                   color: white,
          //                   width: doubleWidth(30),
          //                   child: Center(
          //                     child: Stack(
          //                       children: <Widget>[
          //                         Container(
          //                           width: doubleWidth(30),
          //                           height: max,
          //                           padding: EdgeInsets.all(doubleWidth(3)),
          //                           child: Center(
          //                             child: Builder(builder: (context) {
          //                               switch (e) {
          //                                 case MyTab.games:
          //                                   return Text(
          //                                     'Games'.toUpperCase(),
          //                                     style: TextStyle(
          //                                         fontWeight: FontWeight.bold,
          //                                         color: mainBlue,
          //                                         fontSize: doubleWidth(4)),
          //                                   );
          //                                 case MyTab.fanFeed:
          //                                   return Text(
          //                                     'Fan Feeds'.toUpperCase(),
          //                                     style: TextStyle(
          //                                         fontWeight: FontWeight.bold,
          //                                         color: mainBlue,
          //                                         fontSize: doubleWidth(4)),
          //                                   );
          //                                 case MyTab.stories:
          //                                   return Text(
          //                                     'Stories'.toUpperCase(),
          //                                     style: TextStyle(
          //                                         fontWeight: FontWeight.bold,
          //                                         color: mainBlue,
          //                                         fontSize: doubleWidth(4)),
          //                                   );
          //                                 default:
          //                                   return const SizedBox();
          //                               }
          //                             }),
          //                           ),
          //                         ),
          //                         if (tab == e)
          //                           Align(
          //                             alignment: Alignment.bottomCenter,
          //                             child: Container(
          //                               width: doubleWidth(10),
          //                               height: doubleHeight(0.4),
          //                               decoration: BoxDecoration(
          //                                   color: mainBlue,
          //                                   borderRadius: BorderRadius.only(
          //                                     topRight: Radius.circular(100),
          //                                     topLeft: Radius.circular(100),
          //                                   )),
          //                             ),
          //                           )
          //                       ],
          //                     ),
          //                   ),
          //                 ),
          //               ))
          //           .toList()),
          // ),
          Expanded(
            child: TabBarView(
              controller: controller,
              children: [
                MatchList(),
                FanFeeds(),
                const StoryList()
              ],
            ),
          ),
          // Expanded(child: Builder(
          //   builder: (context) {
          //     switch (tab) {
          //       case MyTab.games:
          //         return MatchList();
          //       case MyTab.fanFeed:
          //         return FanFeeds();
          //       case MyTab.stories:
          //         return const StoryList();
          //       default:
          //         return const SizedBox();
          //     }
          //   },
          // ))
        ],
      ),
    );
  }
}
