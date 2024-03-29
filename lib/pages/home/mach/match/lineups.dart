import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:provider/provider.dart';
import 'package:shooting_app/ui_items/shots/index.dart';

import '../../../../classes/states/match_state.dart';

class LineUps extends StatelessWidget {
  const LineUps({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MatchState state = Provider.of(context, listen: false);

    if(state.selectedMatch.isLive==0)
    return SizedBox.expand(
      child: Center(
        child: Text(AppLocalizations.of(context)!.match_is_not_started),
      ),
    );
    if(state.selectedMatch.homeLineUps==null){
      return SizedBox.expand(
        child: Center(
          child: Text(AppLocalizations.of(context)!.no_lineups),
        ),
      );
    }
    return ListView(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(state.selectedMatch.homeLineUps!.formation??''),
            Text(state.selectedMatch.awayLineUps!.formation??''),
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
                  textDirection: TextDirection.ltr,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ...state.selectedMatch.homeLineUps!.players
                        .map((e) => Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          textDirection: TextDirection.ltr,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(e.number
                                .toString()),
                            SizedBox(
                              width: doubleWidth(4),
                            ),
                            Text(e.name),
                          ],
                        ),
                        if (e != state.selectedMatch.homeLineUps!.players.last)
                          SizedBox(
                            height: doubleHeight(2),
                          ),
                      ],
                    ))
                        .toList(),


                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                width: double.maxFinite,
                padding: EdgeInsets.symmetric(
                    horizontal: doubleWidth(2), vertical: doubleHeight(0.5)),
                child: Column(
                  textDirection: TextDirection.rtl,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ...state.selectedMatch.awayLineUps!.players
                        .map((e) => Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          textDirection: TextDirection.rtl,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(e.number
                                .toString()),
                            SizedBox(
                              width: doubleWidth(4),
                            ),
                            Text(e.name),
                          ],
                        ),
                        if (e != state.selectedMatch.awayLineUps!.players.last)
                          SizedBox(
                            height: doubleHeight(2),
                          ),
                      ],
                    ))
                        .toList(),


                  ],
                ),
              ),
            ),
          ],
        ),

      ],
    );
  }
}
