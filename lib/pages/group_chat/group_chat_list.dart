import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../classes/functions.dart';
import '../../classes/dataTypes.dart';
import '../../classes/states/group_chat_state.dart';
import 'create_group.dart';

class GroupChatListBuilder extends StatelessWidget {
  const GroupChatListBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GroupChatStateProvider(
        child: GroupChatList());
  }
}


class GroupChatList extends StatefulWidget {
  const GroupChatList({Key? key}) : super(key: key);

  @override
  State<GroupChatList> createState() => _GroupChatListState();
}

class _GroupChatListState extends State<GroupChatList> {
  late GroupChatState state;
  late ScrollController _listController;
  @override
  void initState() {
    super.initState();
    state = Provider.of<GroupChatState>(context, listen: false);
    Future.delayed(Duration(milliseconds: 500),(){state.init();});
    _listController = ScrollController()
      ..addListener(() {
        if (state.listChats.isNotEmpty &&
            _listController.position.atEdge &&
            _listController.offset != 0.0) {
          debugPrint("notifHasNext ${state.chatHasNext}");
          if (state.chatHasNext) {
            state.pageNumber++;
            state.getChatsList();
          }
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    // return const SizedBox();
    return Consumer<GroupChatState>(
      builder: (context, state, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(AppLocalizations.of(context)!.group_chat.toUpperCase()),
          ),
          body: state.loadingListCaht?circle():RefreshIndicator(
            onRefresh: () async {
              await state.getChatsList(clean: true);
            },
            child: state.listChats.isEmpty
                ? ListView(
                    physics: AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(vertical: doubleHeight(1)),
                    children: [
                      SizedBox(
                          height: doubleHeight(70),
                          width: double.maxFinite,
                          child: Center(child: Text('${AppLocalizations.of(context)!.nomessage} 🙂'))),
                    ],
                  )
                : ListView(
                    physics: AlwaysScrollableScrollPhysics(),
                    controller: _listController,
                    padding: EdgeInsets.symmetric(
                        vertical: doubleHeight(2), horizontal: doubleWidth(4)),
                    children: [
                      ...state.listChats
                          .map((e) => Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // GroupChatListItem(
                                  //   chat: e,
                                  //   state: state,
                                  // ),
                                  if (e != state.listChats.last)
                                    Divider(color: grayCallDark)
                                ],
                              ))
                          .toList(),
                      if (state.chatHasNext)
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(height: doubleHeight(1)),
                            CircularProgressIndicator(),
                            SizedBox(height: doubleHeight(1)),
                          ],
                        )
                    ],
                  ),
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: mainGreen,
            onPressed: () async{
              bool? bb = await Go.pushSlideAnim(context, CreateGroup());
              if(bb!=null && bb){
                state.getChatsList(clean: true);
              }
            },
            heroTag: 'Create New Group Chat',
            child: Icon(Icons.group),
          ),
        );
      },
    );
  }
}
