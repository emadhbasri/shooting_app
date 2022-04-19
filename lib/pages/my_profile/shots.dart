import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shooting_app/classes/states/main_state.dart';
import 'package:shooting_app/ui_items/shots/post_from_shot.dart';

import '../../classes/functions.dart';
import '../../classes/models.dart';

class Shots extends StatefulWidget {
  const Shots({Key? key}) : super(key: key);

  @override
  _ShotsState createState() => _ShotsState();
}

class _ShotsState extends State<Shots> {
  @override
  Widget build(BuildContext context) {
    final MainState state = Provider.of<MainState>(context, listen: false);
    if(state.personalInformation!.posts.isEmpty)
      if(state.personalInformation!.posts.isEmpty)
        return ListView(
          padding: EdgeInsets.symmetric(vertical: doubleHeight(1)),
          children: [
            SizedBox(
                height: doubleHeight(40),
                width: double.maxFinite,
                child: Center(child: Text('no shot. Try shoot a few soon 🙂'))),
          ],
        );
    return RefreshIndicator(
      onRefresh: ()async{
        await state.getProfile(force: true);
      },
      child: ListView(
        physics: AlwaysScrollableScrollPhysics(),
          children: state.personalInformation!.posts.reversed.toList().map((e) =>
              PostFromShotProfile(
                key: UniqueKey(),
              post: e,onTapTag: gogo,
                canDelete: true,
                delete: () {
                  int index = state.personalInformation!.posts.indexOf(e);
                  List<DataPost> temp = state.personalInformation!.posts.toList();
                  temp.removeAt(index);
                    state.personalInformation!.posts=temp.toList();
                  state.notify();
                },
            person: state.personalInformation!,
          )
      ).toList(),
      ),
    );
  }
}
