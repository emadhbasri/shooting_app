import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shooting_app/ui_items/shots/post_from_shot.dart';

import '../../classes/functions.dart';
import '../../classes/states/profile_state.dart';

class Shots extends StatefulWidget {
  const Shots({Key? key}) : super(key: key);

  @override
  _ShotsState createState() => _ShotsState();
}

class _ShotsState extends State<Shots> {
  @override
  Widget build(BuildContext context) {
    final ProfileState state =
        Provider.of<ProfileState>(context, listen: false);
    if(state.personalInformation!.posts.isEmpty)
      if(state.personalInformation!.posts.isEmpty)
        return ListView(physics: AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(vertical: doubleHeight(1)),
          children: [
            SizedBox(
                height: doubleHeight(40),
                width: double.maxFinite,
                child: Center(child: Text('no shot. 🙂'))),
          ],
        );
    return ListView(
      physics: BouncingScrollPhysics(),
      children: state.personalInformation!.posts
          .map((e) => PostFromShotProfile(
                post: e,
                onTapTag: gogo,
        canDelete: false,
        delete: (){},
                person: state.personalInformation!,
              ))
          .toList(),
    );
  }
}
