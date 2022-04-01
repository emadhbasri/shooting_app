import 'package:provider/provider.dart';
import '../../classes/services/my_service.dart';
import '../../classes/states/main_state.dart';
import '../../main.dart';
import 'fan_mates.dart';
import 'package:shooting_app/ui_items/shots/index.dart';

import 'edit_profile/edit_profile.dart';
import 'media.dart';
import 'shots.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({Key? key}) : super(key: key);
  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile>
    with SingleTickerProviderStateMixin {
  MyService service = getIt<MyService>();

  String selectedTab = 'Shots';
  List<String> tabs = ['Shots', 'Media', 'Fan Mates'];

  @override
  Widget build(BuildContext context) {
    return Consumer<MainState>(
        builder: (context, state, child){
          if (state.personalInformation == null) {
            return circle();
          } else {
            return Scaffold(
              backgroundColor: Colors.white,
              body: SafeArea(
                child: RefreshIndicator(
                  onRefresh: ()async{
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
                                              child: state.personalInformation!
                                                  .profilePhoto !=
                                                  null
                                                  ? imageNetwork(
                                                  state.personalInformation!
                                                      .profilePhoto ??
                                                      '',
                                                  fit: BoxFit.fill)
                                                  : null),
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
                                                        state.personalInformation!
                                                            .team!.team_badge !=
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
                                    '@${state.personalInformation!.userName ?? ''}',
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
                                    onPressed: () async{
                                      await Go.pushSlideAnimSheet(context,
                                          EditProfile(state.personalInformation!));
                                      // state.getProfile(force: true);
                                    },
                                    style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.all(
                                            Color.fromRGBO(235, 234, 241, 1)),
                                        elevation: MaterialStateProperty.all(0),
                                        maximumSize: MaterialStateProperty.all(
                                            Size(doubleWidth(16), doubleHeight(5))),
                                        minimumSize: MaterialStateProperty.all(
                                            Size(doubleWidth(15), doubleHeight(2))),

                                        // fixedSize: MaterialStateProperty.all(Size(
                                        //   doubleWidth(20),
                                        //   doubleHeight(3)
                                        // )),
                                        shape: MaterialStateProperty.all(
                                            RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(7),
                                            )),
                                        padding: MaterialStateProperty.all(
                                            EdgeInsets.symmetric(
                                                vertical: doubleHeight(1.5),
                                                horizontal: doubleWidth(1)))),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'Edit Profile',
                                          style:
                                          TextStyle(fontSize: 12, color: mainBlue),
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
                      Expanded(
                          child: Column(
                            children: [
                              SizedBox(
                                width: double.maxFinite,
                                height: doubleHeight(6),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: tabs
                                      .map((e) => GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedTab = e;
                                      });
                                    },
                                    child: Container(
                                      color: Colors.white,
                                      width: doubleWidth(30),
                                      child: Center(
                                        child: Stack(
                                          children: <Widget>[
                                            Container(
                                              width: doubleWidth(30),
                                              height: double.maxFinite,
                                              padding:
                                              EdgeInsets.all(doubleWidth(3)),
                                              child: Center(
                                                child: Text(
                                                  e,
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      color: mainBlue,
                                                      fontSize: doubleWidth(4)),
                                                ),
                                              ),
                                            ),
                                            selectedTab == e
                                                ? Align(
                                              alignment:
                                              Alignment.bottomCenter,
                                              child: Container(
                                                width: doubleWidth(10),
                                                height: doubleHeight(0.4),
                                                decoration: BoxDecoration(
                                                    color: mainBlue,
                                                    borderRadius:
                                                    BorderRadius.only(
                                                      topRight:
                                                      Radius.circular(
                                                          100),
                                                      topLeft:
                                                      Radius.circular(
                                                          100),
                                                    )),
                                              ),
                                            )
                                                : const SizedBox()
                                          ],
                                        ),
                                      ),
                                    ),
                                  ))
                                      .toList(),
                                ),
                              ),
                              Expanded(child: Builder(
                                builder: (context) {
                                  switch (selectedTab) {
                                    case 'Shots':
                                      return Shots();
                                    case 'Media':
                                      return Media();
                                    case 'Fan Mates':
                                      return FanMates();
                                    default:
                                      return SizedBox();
                                  }
                                },
                              ))
                            ],
                          ))
                    ],
                  ),
                ),
              ),
            );
          }
        }
    );

  }
}
