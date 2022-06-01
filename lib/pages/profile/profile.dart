import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shooting_app/classes/services/chat_service.dart';
import 'package:shooting_app/classes/states/chat_state.dart';
import 'package:shooting_app/pages/chat/chat.dart';
import '../../classes/services/my_service.dart';
import '../../classes/services/user_service.dart';
import '../../classes/states/main_state.dart';
import '../../classes/states/profile_state.dart';
import '../../main.dart';
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
              title: Text('Profile'),
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
                            child: Text('Message')),
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
                                  title: "User Unblocked Successfully",
                                ).show();
                              }
                            },
                            child: Text('Unblock'))
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
                            child: Text('Message')),
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
                                        "CLOSE",
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
                                  title: "User Blocked Successfully",
                                ).show();
                              }
                            },
                            child: Text('Block')),
                      ],
                    ),
              ],
            ),
            backgroundColor: Colors.white,
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
                                                  backgroundColor: Colors.white,
                                                  radius: doubleWidth(30),
                                                  backgroundImage: AssetImage(
                                                      'assets/images/playerbig.png'),
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
                  // SizedBox(height: doubleHeight(1)),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                  //   children: [
                  //     Expanded(
                  //       child: Column(
                  //         mainAxisSize: MainAxisSize.min,
                  //         children: [
                  //           Text(state.personalInformation!.postCount.toString()),
                  //           SizedBox(height: doubleHeight(1)),
                  //           Text('Shots')
                  //         ],
                  //       ),
                  //     ),
                  //     Expanded(
                  //       child: Column(
                  //         mainAxisSize: MainAxisSize.min,
                  //         children: [
                  //           Text(state.personalInformation!.followersCount.toString()),
                  //           SizedBox(height: doubleHeight(1)),
                  //           Text('Followers')
                  //         ],
                  //       ),
                  //     ),
                  //     Expanded(
                  //       child: Column(
                  //         mainAxisSize: MainAxisSize.min,
                  //         children: [
                  //           Text(state.personalInformation!.followingCount.toString()),
                  //           SizedBox(height: doubleHeight(1)),
                  //           Text('Following')
                  //         ],
                  //       ),
                  //     ),
                  //   ],
                  // ),
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
                              ? 'Add As Fan Mates'
                              : 'Remove As Fan Mates',
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
                        indicatorColor: mainBlue,
                        indicatorPadding:
                            EdgeInsets.symmetric(horizontal: doubleWidth(20)),
                        indicatorSize: TabBarIndicatorSize.tab,
                        indicatorWeight: doubleHeight(0.4),
                        labelColor: mainBlue,
                        unselectedLabelColor: mainBlue,
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
