import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../classes/functions.dart';
import '../../../../classes/states/match_state.dart';

class Stats extends StatelessWidget {
  const Stats({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MatchState state = Provider.of(context,listen: false);
    if(state.selectedMatch.isLive==0)
      return SizedBox.expand(
        child: Center(
          child: Text(AppLocalizations.of(context)!.match_is_not_started),
        ),
      );
    if(state.selectedMatch.homeStatistics.isEmpty){
      return SizedBox.expand(
        child: Center(
          child: Text(AppLocalizations.of(context)!.no_stats),
        ),
      );
    }
    return ListView(
      padding: EdgeInsets.only(bottom: doubleHeight(1)),
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
        ...List.generate(state.selectedMatch.homeStatistics.length,
                (index) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: doubleHeight(2),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(state.selectedMatch.homeStatistics[index].value??'0'),
                        Text(state.selectedMatch.homeStatistics[index].type),
                        Text(state.selectedMatch.awayStatistics[index].value??'0'),
                      ],
                    ),
                  ],
                )),
      ],
    );
  }
}
