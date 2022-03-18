import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shooting_app/ui_items/comment.dart';

import '../../../classes/states/match_state.dart';
class MatchUps extends StatelessWidget {
  const MatchUps({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MatchState state = Provider.of(context, listen: false);

    return ListView(
      children: state.listComment.map((e) =>
        Comment(comment: e)
      ).toList(),
    );
  }
}
