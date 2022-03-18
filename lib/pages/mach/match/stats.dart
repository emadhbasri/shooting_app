import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shooting_app/classes/states/match_state.dart';

import '../../../classes/functions.dart';

class Stats extends StatelessWidget {
  const Stats({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MatchState state = Provider.of(context,listen: false);
    return ListView(
      children: [
        Container(
          width: double.maxFinite,
          height: 1,
          decoration: DottedDecoration(
              shape: Shape.line, linePosition: LinePosition.bottom),
        ),
        SizedBox(
            height: doubleHeight(1),
        ),
        ...state.listStats.map((e) =>
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                  height: doubleHeight(2),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(e.teamA),
                  Text(e.title),
                  Text(e.teamB),
                ],
              ),
            ],
          )
        ).toList()

      ],
    );
  }
}
