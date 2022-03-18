import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../classes/functions.dart';
import '../../../classes/states/match_state.dart';

class LineUps extends StatelessWidget {
  const LineUps({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MatchState state = Provider.of(context, listen: false);
    return ListView(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(state.teamALineups.deck),
            Text(state.teamBLineups.deck),
          ],
        ),
        SizedBox(
          height: doubleHeight(0.5),
        ),
        Container(
          width: double.maxFinite,
          height: 1,
          decoration: DottedDecoration(
              shape: Shape.line, linePosition: LinePosition.bottom),
        ),
        SizedBox(
          height: doubleHeight(1),
        ),
        ...List.generate(
            state.teamALineups.players.length,
            (index) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: doubleHeight(2),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          textDirection: TextDirection.ltr,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(state.teamALineups.players[index].number
                                .toString()),
                            SizedBox(
                              width: doubleWidth(4),
                            ),
                            Text(state.teamALineups.players[index].name),
                          ],
                        ),
                        Row(
                          textDirection: TextDirection.rtl,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(state.teamALineups.players[index].number
                                .toString()),
                            SizedBox(
                              width: doubleWidth(4),
                            ),
                            Text(state.teamALineups.players[index].name),
                          ],
                        ),
                      ],
                    ),
                  ],
                )),
      ],
    );
  }
}
