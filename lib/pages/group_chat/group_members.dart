
import 'package:provider/provider.dart';
import 'package:shooting_app/classes/services/chat_service.dart';
import 'package:shooting_app/classes/services/my_service.dart';
import 'package:shooting_app/main.dart';
import 'package:shooting_app/pages/shoot/search_user_mention.dart';
import 'package:shooting_app/ui_items/shots/index.dart';
import '../../classes/states/group_chat_state.dart';
import '../home/search_user.dart';

class GroupChatMemberBuilder extends StatelessWidget {
  const GroupChatMemberBuilder({Key? key, this.state}) : super(key: key);
  final GroupChatState? state;
  @override
  Widget build(BuildContext context) {
    return GroupChatStateProvider(
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
  late GroupChatState state;
  @override
  void initState() {
    super.initState();
    state = Provider.of<GroupChatState>(context, listen: false);
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
bool loadingImageSend=false;
  @override
  Widget build(BuildContext context) {
    return Consumer<GroupChatState>(builder: (context, state, child) {
      return WillPopScope(
        onWillPop: () async {
          stopTimer = true;
          Go.pop(context, state.chats.isNotEmpty ? state.chats.first : null);
          return false;
        },
        child: Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: ()async{
              DataPersonalInformation? user= await Go.pushSlideAnim(context, SearchUserMention());
              if(user!=null){
                bool found=false;
                for(int j=0;j<state.selectedChat.personalInformations.length;j++){
                  if(user.userName==state.selectedChat.personalInformations[j]!.userName){
                    found=true;
                    break;
                  }
                }
                if(!found){
                  bool back = await ChatService.joinGroupChat(getIt<MyService>(),
                      chatRoomId: state.selectedChat.id,
                      userId: user.id);
                  if(back){
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
              PopupMenuButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                itemBuilder: (context) => [
                  PopupMenuItem(
                      onTap: () async {

                      },
                      child: Text('Copy The Group Link')),
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
                                      border: Border.all(width: 2,color: black),
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    // width: doubleWidth(10),
                                    child: Center(child: Text(state.selectedChat.name==null?'':state.selectedChat.name![0],style: TextStyle(
                                        color: black,
                                        fontSize: 45,
                                        fontWeight: FontWeight.bold
                                    ),)),
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
                Expanded(
                    child: Builder(
                      builder: (context) {
                          return ListView.separated(
                              padding: EdgeInsets.symmetric(
                                  horizontal: doubleWidth(5), vertical: doubleHeight(2)),
                              itemCount: state.selectedChat.personalInformations.length,
                              separatorBuilder: (_,__)=>SizedBox(height: doubleHeight(1)),
                              itemBuilder: (_,index)=>
                              state.selectedChat.personalInformations[index]==null?
                              const SizedBox():
                              UserItem(
                                key: UniqueKey(),
                                user: state.selectedChat.personalInformations[index]!,
                                hasFollowBtn: false,
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





