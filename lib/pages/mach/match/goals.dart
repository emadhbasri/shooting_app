import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shooting_app/classes/functions.dart';

import '../../../classes/states/match_state.dart';

class Goals extends StatelessWidget {
  const Goals({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MatchState state = Provider.of(context, listen: false);
    return ListView(
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                width: double.maxFinite,
                padding: EdgeInsets.symmetric(
                    horizontal: doubleWidth(2), vertical: doubleHeight(0.5)),
                decoration: DottedDecoration(
                    shape: Shape.line, linePosition: LinePosition.right),
                child: Column(
                  textDirection: TextDirection.rtl,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: state.teamAGoal
                      .map((e) => Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                textDirection: TextDirection.rtl,
                                children: [
                                  SizedBox(
                                      width:24,
                                      height: 24,
                                      child: Image.asset('images/football (1).png')
                                      // Icon(Icons.sports_basketball)
                                  ),
                                  SizedBox(width: doubleWidth(1)),
                                  Text('${e.time}\''),
                                  SizedBox(width: doubleWidth(1)),
                                  Text(e.name)
                                ],
                              ),
                              if (e != state.teamAGoal.last)
                                SizedBox(
                                  height: doubleHeight(2),
                                ),
                            ],
                          ))
                      .toList(),
                ),
              ),
            ),
            Expanded(child: const SizedBox())
          ],
        ),
      ],
    );
  }
}
