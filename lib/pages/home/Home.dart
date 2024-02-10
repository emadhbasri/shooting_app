import 'package:provider/provider.dart';
import 'package:shooting_app/classes/services/my_service.dart';
import 'package:shooting_app/classes/states/main_state.dart';
import 'package:shooting_app/pages/home/stadia/stadia.dart';
import 'package:shooting_app/ui_items/shots/index.dart';

import '../../classes/states/theme_state.dart';
import '../../main.dart';
import 'fan_feeds.dart';
import 'mach/match_list.dart';

class Home extends StatefulWidget {
  final int? index;
  const Home({Key? key, this.index}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

enum MyTab { games, fanFeed, stadia, }//stories

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
          tab=MyTab.stadia;
          state.tab=tab;
        });break;
        default:break;
      }
    });
    tab=state.tab;
  }

  @override
  Widget build(BuildContext context) {
    // bool isDarkMode = Provider.of<ThemeState>(context,listen: false).isDarkMode;
    return Container(
      // color: Color.fromRGBO(244, 244, 244, 1),
      child: Column(
        children: <Widget>[
          Consumer<ThemeState>(
            builder: (context, state, child) {
            return Container(
            color: state.isDarkMode?headerColor:Colors.white,
            child: child,
          );
          },
          child: TabBar(
              labelStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: doubleWidth(4)
              ),
              indicatorColor: context.watch<ThemeState>().isDarkMode?greenCall:mainBlue,
              indicatorPadding: EdgeInsets.symmetric(
                  horizontal: doubleWidth(10)),
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorWeight: doubleHeight(0.4),
              labelColor: context.watch<ThemeState>().isDarkMode?greenCall:mainBlue,
              unselectedLabelColor: context.watch<ThemeState>().isDarkMode?greenCall:mainBlue,
              tabs: [Tab(
                // text: e,
                child: Text(
                  AppLocalizations.of(context)!.games,
                )),
                  Tab(
                    child: Text(
                      AppLocalizations.of(context)!.fan_feeds,
                    ),
                  ),
                  Tab(
                    child: Text(
                      AppLocalizations.of(context)!.stadia,
                    ),
                  )
              ],
              controller: controller,
            ),
          ),

          Expanded(
            child: TabBarView(
              controller: controller,
              children: [
                MatchList(
                  state:state,
                ),
                FanFeeds(),
                Stadia(
                )
                // const StoryList()
              ],
            ),
          ),

        ],
      ),
    );
  }
}
