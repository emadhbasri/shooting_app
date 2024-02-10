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
            child: Text(AppLocalizations.of(context)!.you_are_not_allowed),
          ),
        );
    }
    if(state.selectedMatch.home.id.toString()!=getIt<MainState>().personalInformation!.team!.team_key
    && state.selectedMatch.away.id.toString()!=getIt<MainState>().personalInformation!.team!.team_key) {
      return SizedBox.expand(
        child: Center(
          child: Text(AppLocalizations.of(context)!.you_are_not_allowed),
        ),
      );
    }
    if(state.selectedMatch.isLive==0)
      return SizedBox.expand(
        child: Center(
          child: Text(AppLocalizations.of(context)!.match_is_not_started),
        ),
      );

    if(state.selectedMatch.matchUps.isEmpty){
      return SizedBox.expand(
        child: Center(
          child: Text(AppLocalizations.of(context)!.no_shots),
        ),
      );
    }
    return ListView(
      children: state.selectedMatch.matchUps.map((e) =>
          PostFromMatch(
            key: UniqueKey(),
            post: e, onTapTag: gogo,delete: (){
            state.selectedMatch.matchUps.remove(e);
            state.notify();
          })
      ).toList(),
    );
  }
}
