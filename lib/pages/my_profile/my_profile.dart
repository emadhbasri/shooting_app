import 'package:provider/provider.dart';
import 'package:shooting_app/ui_items/gal.dart';
import '../../classes/services/my_service.dart';
import '../../classes/states/main_state.dart';
import '../../classes/states/theme_state.dart';
import '../../main.dart';
import 'fan_mates.dart';
import 'package:shooting_app/ui_items/shots/index.dart';

import 'edit_profile/edit_profile.dart';
import 'shots.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({Key? key}) : super(key: key);
  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> with SingleTickerProviderStateMixin {
  MyService service = getIt<MyService>();
  late TabController _controller;
  late String selectedTab;
  List<String> tabs = []; //'Media',

  @override
  void initState() {
    super.initState();

    MainState state = Provider.of(context, listen: false);
    state.getProfile(force: true);
    _controller = TabController(length: 2, vsync: this, initialIndex: 0);
    // ..addListener(() {
    //   print('_controller.index ${_controller.index}');
    //   print('_controller ${_controller}');
    //   setState(() {
    //     selectedTab = tabs[_controller.index];
    //   });
    // });
    Future.delayed(Duration(milliseconds: 200),(){
      init(context);
    });
  }

  init(context) {
    selectedTab = AppLocalizations.of(context)!.shots;
    tabs = [AppLocalizations.of(context)!.shots, AppLocalizations.of(context)!.fan_mates];
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MainState>(builder: (context, state, child) {
      if (
tabs.isEmpty ||
        state.personalInformation == null) {
        return circle();
      } else {
        return Scaffold(
          // backgroundColor: Colors.white,
          body: SafeArea(
            child: RefreshIndicator(
              onRefresh: () async {
                await state.getProfile(force: true);
              },
              child: Column(
                children: [
                  SizedBox(height: doubleHeight(2)),
                  SizedBox(
                    width: double.maxFinite,
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                  width: doubleWidth(30),
                                  height: doubleWidth(30),
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      ClipRRect(
                                          borderRadius: BorderRadius.circular(100),
                                          child: state.personalInformation!.profilePhoto != null
                                              ? GestureDetector(
                                                  onTap: () {
                                                    Go.push(
                                                        context,
                                                        Gal(images: [
                                                          state.personalInformation!.profilePhoto!
                                                        ]));
                                                  },
                                                  child: CircleAvatar(
                                                    radius: doubleWidth(30),
                                                    backgroundImage: networkImage(
                                                        state.personalInformation!.profilePhoto!),
                                                  ),
                                                )
                                              : CircleAvatar(
                                                  backgroundColor:
                                                      context.watch<ThemeState>().isDarkMode
                                                          ? Colors.black
                                                          : Colors.white,
                                                  radius: doubleWidth(30),
                                                  backgroundImage: AssetImage(
                                                    'assets/images/playerbig.png',
                                                  ))),
                                      Align(
                                        alignment: Alignment(0.9, -0.9),
                                        child: SizedBox(
                                          width: doubleHeight(4),
                                          height: doubleHeight(4),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: white,
                                                border: Border.all(color: white, width: 3),
                                                borderRadius: BorderRadius.circular(100),
                                                image: state.personalInformation!.team != null &&
                                                        state.personalInformation!.team!
                                                                .team_badge !=
                                                            null
                                                    ? DecorationImage(
                                                        image: networkImage(state
                                                            .personalInformation!
                                                            .team!
                                                            .team_badge!),
                                                      )
                                                    : null),
                                          ),
                                        ),
                                      )
                                    ],
                                  )),
                              SizedBox(height: doubleHeight(1)),
                              Text(state.personalInformation!.fullName ?? ''),
                              Text(
                                '@${state.personalInformation!.userName}',
                                style: TextStyle(color: grayCall, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment(0.9, -1),
                          child: SizedBox(
                            width: doubleWidth(25),
                            child: ElevatedButton(
                                onPressed: () async {
                                  await Go.pushSlideAnimSheet(
                                      context, EditProfile(state.personalInformation!));
                                  // state.getProfile(force: true);
                                },
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all(Color.fromRGBO(235, 234, 241, 1)),
                                    elevation: MaterialStateProperty.all(0),
                                    maximumSize: MaterialStateProperty.all(
                                        Size(doubleWidth(16), doubleHeight(5))),
                                    minimumSize: MaterialStateProperty.all(
                                        Size(doubleWidth(15), doubleHeight(2))),

                                    // fixedSize: MaterialStateProperty.all(Size(
                                    //   doubleWidth(20),
                                    //   doubleHeight(3)
                                    // )),
                                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(7),
                                    )),
                                    padding: MaterialStateProperty.all(EdgeInsets.symmetric(
                                        vertical: doubleHeight(1.5), horizontal: doubleWidth(1)))),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!.edit_profile,
                                      style: TextStyle(fontSize: 12, color: mainBlue),
                                    ),
                                    SizedBox(width: doubleWidth(1)),
                                    Icon(Icons.edit, size: 15, color: mainBlue)
                                  ],
                                )),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: doubleHeight(2)),
                  Expanded(
                      child: Column(
                    children: [
                      TabBar(
                        labelStyle:
                            TextStyle(fontWeight: FontWeight.bold, fontSize: doubleWidth(4)),
                        indicatorColor:
                            context.watch<ThemeState>().isDarkMode ? greenCall : mainBlue,
                        indicatorPadding: EdgeInsets.symmetric(horizontal: doubleWidth(20)),
                        indicatorSize: TabBarIndicatorSize.tab,
                        indicatorWeight: doubleHeight(0.4),
                        labelColor: context.watch<ThemeState>().isDarkMode ? greenCall : mainBlue,
                        tabs: tabs
                            .map((e) => Tab(
                                  child: Text(e),
                                ))
                            .toList(),
                        controller: _controller,
                      ),
                      Expanded(
                          child: TabBarView(
                        controller: _controller,
                        children: [Shots(), FanMates()],
                      ))
                    ],
                  ))
                ],
              ),
            ),
          ),
        );
      }
    });
  }
}
