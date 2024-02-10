import 'package:flutter/material.dart';
import 'package:shooting_app/classes/services/chat_service.dart';
import 'package:shooting_app/classes/services/my_service.dart';

import '../../classes/dataTypes.dart';
import '../../classes/functions.dart';
import '../../classes/models.dart';
import '../../classes/services/user_service.dart';
import '../../classes/states/chat_state.dart';
import '../../main.dart';
import 'chat.dart';

class SearchChat extends StatefulWidget {
  const SearchChat({Key? key}) : super(key: key);
  @override
  _SearchChatState createState() => _SearchChatState();
}

class _SearchChatState extends State<SearchChat> {
  // List<String> hashtags = ['YNWA', 'Salah', 'Watfold', 'Anfield', 'EPL'];
  late final TextEditingController controller;
  List<DataPersonalInformation>? users;
  String search='';
  getData() async {
    setState(() {
      users = null;
    });
    MyService service = getIt<MyService>();
    // users = await UsersService.search(service, search: controller.value.text);
    users = await ChatService.search(service, search: controller.value.text);
    print('users ${users!.length}');
    setState(() {});
  }

  @override
  void initState() {
    statusSet(mainBlue);
    controller = TextEditingController()
      ..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            IconButton(
              padding: EdgeInsets.zero,
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () {
                Go.pop(context);
              },
            ),
            Expanded(
              child: Container(
                height: doubleHeight(7),
                padding: EdgeInsets.symmetric(vertical: doubleHeight(1)),
                child: ClipRRect(
                  child: Container(
                    width: double.maxFinite,
                    height: doubleHeight(7),
                    color: Colors.white,
                    child: Center(
                      child: TextField(
                        style: TextStyle(
                            color: Colors.black
                        ),
                        enableSuggestions: true,
                        controller: controller,
                        onChanged: (e) {
                          print('$search!= $e');
                          if(search.trim()!=e) {
                            print('searchhhhhhhhhh');
                            search = e;
                            getData();
                          }
                        },
                        autofocus: true,
                        cursorColor: mainBlue,
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.search),
                            border: InputBorder.none,
                            hintText: AppLocalizations.of(context)!.searchChat),
                      ),
                    ),
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
      body: SizedBox.expand(
        child: Builder(builder: (context) {

          if (controller.value.text == '')
            return Center(child: Text(AppLocalizations.of(context)!.please_search_in_users));
          if (users == null) {
              return circle();
            } else if (users!.isEmpty) {
              return Center(child: Text(AppLocalizations.of(context)!.no_user_found));
            } else {
              return ListView(
                  padding: EdgeInsets.symmetric(
                      horizontal: doubleWidth(5), vertical: doubleHeight(2)),
                  children: users!
                      .map((e) => UserItem(
                      user: e,
                         ))
                      .toList()
              );
            }
          // }
        }),
      ),
    );
  }
}
class UserItem extends StatefulWidget {
  const UserItem({Key? key, required this.user}) : super(key: key);
  final DataPersonalInformation user;

  @override
  State<UserItem> createState() => _UserItemState();
}

class _UserItemState extends State<UserItem> {
  late DataPersonalInformation user;
  @override
  void initState() {
    super.initState();
    user = widget.user;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        DataChatRoom? back =
        await ChatService.createPrivateChat(
            getIt<MyService>(),
            friendId: user.id);
        if (back != null) {
          Go.replaceSlideAnim(
              context,
              ChatBuilder(
                state: ChatState()..selectedChat = back,
              ));
        }
      },
      // onTap: () {
        // Go.pushSlideAnim(
        //     context,
        //     ProfileBuilder(
        //         username: user.userName));
      // },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: doubleWidth(4)),
        width: double.maxFinite,
        // height: doubleHeight(15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: doubleHeight(1)),
                Text(user.fullName ?? ''),
                SizedBox(height: doubleHeight(0.5)),
                Text(
                  '@${user.userName}',
                  style: TextStyle(color: grayCall, fontSize: 12),
                ),
                SizedBox(height: doubleHeight(0.5)),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Consumer<MainState>(builder: (context, value, child) {
                      // int index = value.users.indexOf(user);
                      // return
                    ElevatedButton(
                        onPressed: () async {
                          print('click');
                          print(user.followedByMe);
                          MyService service = getIt<MyService>();
                          if (user.followedByMe) {
                            //unfollow
                            bool backUser = await UsersService.unFollowUser(
                                service, user.id);
                            print('unfollow $backUser');
                          } else {
                            bool backUser = await UsersService.followUser(
                                service, user.id);
                            print('follow $backUser');
                          }
                          setState(() {
                            user.followedByMe = !user.followedByMe;
                          });
                          // value.notify();
                        },
                        child: Text(
                          !user.followedByMe
                              ? AppLocalizations.of(context)!.add_as_fan_mates
                              : AppLocalizations.of(context)!.remove_as_fan_mates,
                          style: TextStyle(color: Colors.black),
                        ),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              user.followedByMe
                                  ? Color.fromRGBO(216, 216, 216, 1)
                                  : Color.fromRGBO(78, 255, 187, 1)),
                          elevation: MaterialStateProperty.all(0),
                          shape:
                          MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7),
                          )),
                          padding: MaterialStateProperty.all(
                              EdgeInsets.symmetric(horizontal: doubleWidth(2))),
                        ),
                      )
                    // }),
                  ],
                ),
              ],
            ),
            SizedBox(
                width: doubleWidth(20),
                height: doubleWidth(20),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: user.profilePhoto !=
                            null
                            ? SizedBox(
                          width: doubleWidth(20),
                          height: doubleWidth(20),
                          child: imageNetwork(
                              user.profilePhoto ??
                                  '',
                              fit: BoxFit.fill),
                        )
                            : SizedBox(
                            width: doubleWidth(20),
                            height: doubleWidth(20),
                            child:profilePlaceHolder(context))),
                    Align(
                      alignment: Alignment(0.9, -0.9),
                      child: SizedBox(
                        width: doubleHeight(3),
                        height: doubleHeight(3),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.white, width: 3),
                            borderRadius: BorderRadius.circular(100),
                            image:
                            user.team != null &&
                                user.team!
                                    .team_badge !=
                                    null
                                ? DecorationImage(
                              image: networkImage(user
                                  .team!
                                  .team_badge!),
                            )
                                : null,
                          ),
                        ),
                      ),
                    )
                  ],
                )),
          ],
        ),
      ),
    );
  }
}