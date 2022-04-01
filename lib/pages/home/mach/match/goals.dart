import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shooting_app/classes/live_match_model.dart';

import '../../../../classes/functions.dart';
import '../../../../classes/states/match_state.dart';

class Goals extends StatelessWidget {
  const Goals({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MatchState state = Provider.of(context, listen: false);
    if(state.selectedMatch.isLive==0)
      return SizedBox.expand(
        child: Center(
          child: Text('Match is not started'),
        ),
      );
    List<DataEvent> first = state.selectedMatch.events.where((element) => element.type=='Goal' && element.teamId==state.selectedMatch.home.id).toList();
    List<DataEvent> second = state.selectedMatch.events.where((element) => element.type=='Goal' && element.teamId==state.selectedMatch.away.id).toList();

    if(first.isEmpty && second.isEmpty){
      return SizedBox.expand(
        child: Center(
          child: Text('no Goals'),
        ),
      );
    }
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
                  children: first
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
                                  Text('${(e.timeElapsed!=null?e.timeElapsed!:0)+(e.timeExtra!=null?e.timeExtra!:0)}\''),
                                  SizedBox(width: doubleWidth(1)),
                                  Expanded(child: Text(e.playerName??''))
                                ],
                              ),
                              if (e != first.last)
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
                    horizontal: doubleWidth(2), vertical: doubleHeight(0.5)),
                child: Column(
                  textDirection: TextDirection.ltr,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: second
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
                          Text('${(e.timeElapsed!=null?e.timeElapsed!:0)+(e.timeExtra!=null?e.timeExtra!:0)}\''),
                          SizedBox(width: doubleWidth(1)),
                          Expanded(child: Text(e.playerName??''))
                        ],
                      ),
                      if (e != second.last)
                        SizedBox(
                          height: doubleHeight(2),
                        ),
                    ],
                  ))
                      .toList(),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
