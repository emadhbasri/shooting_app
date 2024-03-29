import 'package:provider/provider.dart';
import 'package:shooting_app/classes/services/chat_service.dart';
import 'package:shooting_app/classes/states/chat_state.dart';
import 'package:shooting_app/pages/chat/chat.dart';
import '../../classes/services/my_service.dart';
import '../../classes/services/user_service.dart';
import '../../classes/states/main_state.dart';
import '../../classes/states/profile_state.dart';
import '../../classes/states/theme_state.dart';
import '../../main.dart';
import '../../package/rflutter_alert/rflutter_alert.dart';
import '../../ui_items/gal.dart';
import 'fan_mates.dart';
import 'package:shooting_app/ui_items/shots/index.dart';
import 'shots.dart';

class ProfileBuilder extends StatelessWidget {
  const ProfileBuilder({Key? key, required this.username}) : super(key: key);
  final String username;
  @override
  Widget build(BuildContext context) {
    return ProfileStateProvider(
      username: username,
        context:context,
      child: Profile(),
    );
  }
}

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with SingleTickerProviderStateMixin {
  late TabController _controller;

  @override
  void initState() {
    super.initState();
    ProfileState state = Provider.of(context, listen: false);
    _controller = TabController(length: 2, vsync: this, initialIndex: 0)
      ..addListener(() {
        state.selectedTab = state.tabs[_controller.index];
        state.notify();
      });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileState>(
      builder: (context, state, child) {
        if (state.personalInformation == null) {
          return circle();
        } else {
          return Scaffold(
            appBar: AppBar(
              title: Text(AppLocalizations.of(context)!.profile),
              elevation: 0,
              actions: [
                if (state.personalInformation!.id != getIt<MainState>().userId)
                  if (state.personalInformation!.blockedByMe)
                    PopupMenuButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      itemBuilder: (context) => [
                        PopupMenuItem(
                            onTap: () async {
                              DataChatRoom? back =
                                  await ChatService.createPrivateChat(
                                      state.service,
                                      friendId: state.personalInformation!.id);
                              if (back != null) {
                                Go.replaceSlideAnim(
                                    context,
                                    ChatBuilder(
                                      state: ChatState()..selectedChat = back,
                                    ));
                              }
                            },
                            child: Text(AppLocalizations.of(context)!.messages)),
                        PopupMenuItem(
                            onTap: () async {
                              bool? back = await UsersService.blockUser(
                                  state.service, state.personalInformation!.id);
                              print('block $back');
                              if (back) {
                                state.personalInformation!.blockedByMe=false;
                                state.notify();
                                Alert(
                                  context: context,
                                  style: AlertStyle(
                                    animationType: AnimationType.shrink
                                  ),
                                  type: AlertType.success,
                                  title: AppLocalizations.of(context)!.user_unblocked_successfully,
                                ).show();
                              }
                            },
                            child: Text(AppLocalizations.of(context)!.unblock))
                      ],
                    )
                  else
                    PopupMenuButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      itemBuilder: (context) => [
                        PopupMenuItem(
                            onTap: () async {
                              DataChatRoom? back =
                                  await ChatService.createPrivateChat(
                                      state.service,
                                      friendId: state.personalInformation!.id);
                              if (back != null) {
                                Go.replaceSlideAnim(
                                    context,
                                    ChatBuilder(
                                      state: ChatState()..selectedChat = back,
                                    ));
                              }
                            },
                            child: Text(AppLocalizations.of(context)!.message)),
                        PopupMenuItem(
                            onTap: () async {
                              bool? back = await UsersService.blockUser(
                                  state.service, state.personalInformation!.id);
                              print('block $back');
                              if (back) {
                                state.personalInformation!.blockedByMe=true;
                                state.notify();
                                Alert(
                                  context: context,
                                  buttons: [
                                    DialogButton(
                                      child: Text(
                                        AppLocalizations.of(context)!.close,
                                        style: TextStyle(color: Colors.white, fontSize: 20),
                                      ),
                                      onPressed: () => Navigator.pop(context),
                                    )
                                  ],
                                  style: AlertStyle(
                                    isCloseButton: false,
                                      animationType: AnimationType.shrink
                                  ),
                                  type: AlertType.success,
                                  title: AppLocalizations.of(context)!.user_blocked_successfully,
                                ).show();
                              }
                            },
                            child: Text(AppLocalizations.of(context)!.block)),
                      ],
                    ),

              ],
            ),
            // backgroundColor: Colors.white,
            body: SafeArea(
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
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          child: state.personalInformation!
                                                      .profilePhoto !=
                                                  null
                                              ? GestureDetector(
                                                  onTap: () {
                                                    Go.push(
                                                        context,
                                                        Gal(images: [
                                                          state
                                                              .personalInformation!
                                                              .profilePhoto!
                                                        ]));
                                                  },
                                                  child: CircleAvatar(
                                                    radius: doubleWidth(30),
                                                    backgroundImage:
                                                        networkImage(state
                                                            .personalInformation!
                                                            .profilePhoto!),
                                                  ),
                                                )
                                              : CircleAvatar(
                                            backgroundColor: context.watch<ThemeState>().isDarkMode?Colors.black:Colors.white,

                                            // backgroundColor: Colors.white,
                                                  radius: doubleWidth(30),
                                                  backgroundImage: AssetImage(
                                                      'assets/images/playerbig.png',
                                                    // color: getIt<ThemeState>().isDarkMode?Colors.white:Colors.black,
                                                  ),
                                                )),
                                      Align(
                                        alignment: Alignment(0.9, -0.9),
                                        child: SizedBox(
                                          width: doubleHeight(4),
                                          height: doubleHeight(4),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: white,
                                                border: Border.all(
                                                    color: white, width: 3),
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                image: state.personalInformation!
                                                                .team !=
                                                            null &&
                                                        state
                                                                .personalInformation!
                                                                .team!
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
                      ],
                    ),
                  ),

                  SizedBox(height: doubleHeight(2)),
                  if (state.personalInformation!.id !=
                      getIt<MainState>().userId)
                    Consumer<ProfileState>(
                      builder: (context, value, child) => ElevatedButton(
                        onPressed: () async {
                          print('click');
                          print(value.personalInformation!.followedByMe);
                          MyService service = getIt<MyService>();
                          bool backUser;
                          if (value.personalInformation!.followedByMe) {
                            //unfollow
                            backUser = await UsersService.unFollowUser(
                                service, value.personalInformation!.id);
                            print('unfollow $backUser');
                          } else {
                            backUser = await UsersService.followUser(
                                service, value.personalInformation!.id);
                            print('follow $backUser');
                          }
                          if (backUser) {
                            // state.init(state.userName);
                            value.personalInformation!.followedByMe =
                                !value.personalInformation!.followedByMe;
                            value.notify();
                          }
                        },
                        child: Text(
                          !value.personalInformation!.followedByMe
                              ? AppLocalizations.of(context)!.add_as_fan_mates
                              : AppLocalizations.of(context)!.remove_as_fan_mates,
                          style: TextStyle(color: Colors.black),
                        ),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              value.personalInformation!.followedByMe
                                  ? Color.fromRGBO(216, 216, 216, 1)
                                  : Color.fromRGBO(78, 255, 187, 1)),
                          elevation: MaterialStateProperty.all(0),
                          shape:
                              MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7),
                          )),
                          padding: MaterialStateProperty.all(
                              EdgeInsets.symmetric(
                                  vertical: doubleHeight(1.7),
                                  horizontal: doubleWidth(4))),
                        ),
                      ),
                    ),
                  SizedBox(height: doubleHeight(2)),
                  Expanded(
                      child: Column(
                    children: [
                      TabBar(
                        labelStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: doubleWidth(4)),
                        indicatorColor: context.watch<ThemeState>().isDarkMode?greenCall:mainBlue,
                        indicatorPadding:
                            EdgeInsets.symmetric(horizontal: doubleWidth(20)),
                        indicatorSize: TabBarIndicatorSize.tab,
                        indicatorWeight: doubleHeight(0.4),
                        labelColor: context.watch<ThemeState>().isDarkMode?greenCall:mainBlue,
                        unselectedLabelColor: context.watch<ThemeState>().isDarkMode?greenCall:mainBlue,
                        tabs: state.tabs
                            .map((e) => Tab(
                                  // text: e,
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
          );
        }
      },
    );
  }
}
