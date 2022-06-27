import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shooting_app/classes/services/chat_service.dart';
import 'package:shooting_app/classes/services/my_service.dart';
import 'package:shooting_app/main.dart';
import 'package:shooting_app/pages/group_chat/create_group.dart';
import 'package:shooting_app/pages/shoot/search_user_mention.dart';
import 'package:shooting_app/ui_items/shots/index.dart';
import '../../classes/states/chat_state.dart';
import '../../classes/states/group_chat_state.dart';
import '../../ui_items/dialogs/dialog1.dart';
import '../home/search_user.dart';

class GroupChatMemberBuilder extends StatelessWidget {
  const GroupChatMemberBuilder({Key? key, this.state}) : super(key: key);
  final ChatState? state;
  @override
  Widget build(BuildContext context) {
    return ChatStateProvider(
      child: GroupChatMember(),
      state: state,
    );
  }
}

class GroupChatMember extends StatefulWidget {
  const GroupChatMember({Key? key}) : super(key: key);

  @override
  _GroupChatMemberState createState() => _GroupChatMemberState();
}

class _GroupChatMemberState extends State<GroupChatMember> {
  TextEditingController controller = TextEditingController();
  late ChatState state;
  @override
  void initState() {
    super.initState();
    state = Provider.of<ChatState>(context, listen: false);
    startTimer();
    state.getChats();
  }

  bool stopTimer = false;
  int i = 0;
  startTimer() async {
    if (stopTimer) return;
    await state.getChats();
    await Future.delayed(Duration(seconds: 2));
    return startTimer();
  }

  bool loadingImageSend = false;
  @override
  Widget build(BuildContext context) {
    return Consumer<ChatState>(builder: (context, state, child) {
      // print('myRole ${state.myRole}');
      // if (state.myRole != null) {
      //   print('myRole ${state.myRole!.isRoomOwner}');
      //   print('myRole ${state.myRole!.userRole}');
      // }
      state.selectedChat.chatroomUsers.forEach((element) {
        print('element.isRoomOwner ${element.isRoomOwner}');
        print('element.userRole ${element.userRole}');
      });
      return WillPopScope(
        onWillPop: () async {
          stopTimer = true;
          Go.pop(context, state.chats.isNotEmpty ? state.chats.first : null);
          return false;
        },
        child: Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              DataPersonalInformation? user =
                  await Go.pushSlideAnim(context, SearchUserMention());
              if (user != null) {
                bool found = false;
                for (int j = 0;
                    j < state.selectedChat.personalInformations.length;
                    j++) {
                  if (user.userName ==
                      state.selectedChat.personalInformations[j]!.userName) {
                    found = true;
                    break;
                  }
                }
                if (!found) {
                  DataChatRoom? back = await ChatService.joinGroupChat(
                      getIt<MyService>(),
                      chatRoomId: state.selectedChat.id,
                      userId: user.id);
                  if (back != null) {
                    state.selectedChat.personalInformations.add(user);
                  }
                }
              }
            },
            child: Icon(Icons.add),
            heroTag: '',
          ),
          appBar: AppBar(
            title: Text('Group Info'.toUpperCase()),
            actions: [
              PopupMenuButton<String?>(
                onSelected: (String? value) async{
                  if(value=='Edit'){
                    DataChatRoom? back = await Go.pushSlideAnim(
                        context,
                        CreateGroup(
                            isEdit: true, group: state.selectedChat));
                    if(back!=null){
                      state.selectedChat.roomPhoto=back.roomPhoto;
                      state.selectedChat.name=back.name;
                      state.notify();
                    }
                  }
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                itemBuilder: (_) => [
                  PopupMenuItem(
                    value: null,
                      onTap: () async {
                        copyText(
                            'footballbuzz://JoinChat/${state.selectedChat.id}');
                      },
                      child: Text('Copy The Group Link')),
                  if (state.myRole != null &&
                      (state.myRole!.isRoomOwner ||
                          state.myRole!.userRole == 1))
                    PopupMenuItem(
                      value: 'Edit',
                        child: Text('Edit Group')),
                ],
              )
            ],
          ),
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
                                child: AspectRatio(
                                  aspectRatio: 1,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 2, color: black),
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        image: DecorationImage(
                                            fit: BoxFit.fill,
                                            image: networkImage(state
                                                    .selectedChat.roomPhoto ??
                                                ''))),
                                    // width: doubleWidth(10),
                                    child: state.selectedChat.roomPhoto !=
                                            null
                                        ? null
                                        : Center(
                                            child: Text(
                                            state.selectedChat.name == null
                                                ? ''
                                                : state.selectedChat.name![0],
                                            style: TextStyle(
                                                color: black,
                                                fontSize: 45,
                                                fontWeight: FontWeight.bold),
                                          )),
                                  ),
                                )),
                            SizedBox(height: doubleHeight(1)),
                            Text(state.selectedChat.name ?? ''),
                            Text(
                              '${state.selectedChat.personalInformations.length} members',
                              style: TextStyle(color: grayCall, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: doubleHeight(2)),
                Expanded(child: Builder(
                  builder: (context) {
                    return ListView.separated(
                      padding: EdgeInsets.symmetric(
                          horizontal: doubleWidth(5),
                          vertical: doubleHeight(2)),
                      itemCount: state.selectedChat.personalInformations.length,
                      separatorBuilder: (_, __) =>
                          SizedBox(height: doubleHeight(1)),
                      itemBuilder: (_, index) => state
                                  .selectedChat.personalInformations[index] ==
                              null
                          ? const SizedBox()
                          : UserItem(
                              onLongPress: state.myRole != null &&
                                      state.myRole!.isRoomOwner &&
                                      state.selectedChat.chatroomUsers[index]
                                              .isRoomOwner ==
                                          false &&
                                      state.selectedChat.chatroomUsers[index]
                                              .userRole ==
                                          0
                                  ? () async {
                                      bool? alert = await MyAlertDialog(context,
                                          content:
                                              'Do You Want To Admin This User?');
                                      if (alert == true) {
                                        bool back = await ChatService.addAdmin(
                                            getIt<MyService>(),
                                            chatRoomId: state.selectedChat.id,
                                            userId: state
                                                .selectedChat
                                                .chatroomUsers[index]
                                                .personalInformation!
                                                .id);
                                        if (back) {
                                          state.selectedChat.chatroomUsers[index].userRole=1;
                                          state.notify();
                                          Alert(
                                            context: context,
                                            style: AlertStyle(
                                                animationType:
                                                    AnimationType.shrink),
                                            type: AlertType.success,
                                            title:
                                                "User Become Admin Successfully",
                                          ).show();
                                        }
                                      }
                                    }
                                  : null,
                              key: UniqueKey(),
                              roomUser: state.selectedChat.chatroomUsers[index],
                              user: state
                                  .selectedChat.personalInformations[index]!,
                              hasFollowBtn: false,
                              hasStartChatBtn: true,
                            ),
                    );
                  },
                ))
              ],
            ),
          ),
        ),
      );
    });
  }
}
