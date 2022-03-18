import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../classes/functions.dart';
import '../../../classes/states/match_state.dart';
class Cards extends StatelessWidget {
  const Cards({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MatchState state = Provider.of(context, listen: false);

    List<DataCard> all = [
      ...state.teamACard,
      ...state.teamBCard,
    ]..sort((b, a) => a.time.compareTo(b.time));

    return ListView(
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                width: double.maxFinite,
                padding: EdgeInsets.symmetric(
                    horizontal: doubleWidth(3), vertical: doubleHeight(0.5)),
                decoration: DottedDecoration(
                    shape: Shape.line, linePosition: LinePosition.right),
                child: Column(
                  textDirection: TextDirection.rtl,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: all
                      .map((e) => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if(state.teamACard.contains(e))
                        Row(
                          textDirection: TextDirection.rtl,
                          children: [
                            PlayCard(isRed: e.isRed),
                            SizedBox(width: doubleWidth(2)),
                            Text('${e.time}\''),
                            SizedBox(width: doubleWidth(2)),
                            Text(e.name)
                          ],
                        )
                      else SizedBox(height: doubleHeight(3)),
                      if (e != all.last)
                        SizedBox(
                          height: doubleHeight(2),
                        ),
                    ],
                  ))
                      .toList(),
                ),
              ),
            ),
            Expanded(
              child: Container(
                width: double.maxFinite,
                padding: EdgeInsets.symmetric(
                    horizontal: doubleWidth(3), vertical: doubleHeight(0.5)),
                child: Column(
                  textDirection: TextDirection.ltr,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: all
                      .map((e) => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if(state.teamBCard.contains(e))
                        Row(
                          textDirection: TextDirection.ltr,
                          children: [
                            PlayCard(isRed: e.isRed),
                            SizedBox(width: doubleWidth(2)),
                            Text('${e.time}\''),
                            SizedBox(width: doubleWidth(2)),
                            Text(e.name)
                          ],
                        )
                      else SizedBox(height: doubleHeight(3)),
                      if (e != all.last)
                        SizedBox(
                          height: doubleHeight(2),
                        ),
                    ],
                  ))
                      .toList(),
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}

class PlayCard extends StatelessWidget {
  const PlayCard({Key? key,required this.isRed}) : super(key: key);
  final bool isRed;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isRed?Colors.red:Colors.yellow,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(width: 1,color: Colors.black),
      ),
      width: doubleWidth(4),
      height: doubleHeight(3),
    );
  }
}

