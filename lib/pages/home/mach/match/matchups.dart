import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shooting_app/classes/states/main_state.dart';
import 'package:shooting_app/ui_items/shots/post_from_shot.dart';

import '../../../../classes/functions.dart';
import '../../../../classes/states/match_state.dart';
import '../../../../main.dart';
class MatchUps extends StatelessWidget {
  const MatchUps({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MatchState state = Provider.of(context, listen: false);

    if(getIt<MainState>().personalInformation!.team==null){
        return SizedBox.expand(
          child: Center(
            child: Text('You are not allowed to see this section'),
          ),
        );
    }
    if(state.selectedMatch.home.id.toString()!=getIt<MainState>().personalInformation!.team!.team_key
    && state.selectedMatch.away.id.toString()!=getIt<MainState>().personalInformation!.team!.team_key) {
      return SizedBox.expand(
        child: Center(
          child: Text('You Are Not Allowed To see This Section'),
        ),
      );
    }
    if(state.selectedMatch.isLive==0)
      return SizedBox.expand(
        child: Center(
          child: Text('Match Is Not started'),
        ),
      );
    if(state.selectedMatch.isLive==2)
      return SizedBox.expand(
        child: Center(
          child: Text('Match Is Finished'),
        ),
      );
    if(state.selectedMatch.matchUps.isEmpty){
      return SizedBox.expand(
        child: Center(
          child: Text('No Shots'),
        ),
      );
    }
    return ListView(
      children: state.selectedMatch.matchUps.map((e) =>
          PostFromMatch(post: e, onTapTag: gogo)
      ).toList(),
    );
  }
}
