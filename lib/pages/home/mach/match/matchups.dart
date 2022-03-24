import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shooting_app/ui_items/shots/post_from_shot.dart';

import '../../../../classes/functions.dart';
import '../../../../classes/states/match_state.dart';
class MatchUps extends StatelessWidget {
  const MatchUps({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MatchState state = Provider.of(context, listen: false);

    return ListView(
      children: state.selectedMatch.matchUps.map((e) =>
      PostFromShot(post: e, onTapTag: gogo)
      ).toList(),
    );
  }
}
