import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shooting_app/dataTypes.dart';
import 'package:shooting_app/ui_items/shots/index.dart';
import '../../../../classes/states/main_state.dart';
import '../../../../main.dart';
import 'goals.dart';
import 'lineups.dart';
import 'stats.dart';

import '../../../../classes/functions.dart';
import '../../../../classes/states/match_state.dart';
import 'cards.dart';
import 'matchups.dart';

class MatchBuilder extends StatelessWidget {
  const MatchBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MatchStateProvider(
      child: Match(),
    );
  }
}

class Match extends StatefulWidget {
  const Match({Key? key}) : super(key: key);

  @override
  _MatchState createState() => _MatchState();
}

class _MatchState extends State<Match> {
  @override
  void initState() {
    // MatchState state = Provider.of(context,listen: false);
    // state.getMatchStatics();
    // state.getMatchEvents();
    // state.getMatchLineUps();
    // state.getMatchUps();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<MatchState>(
      builder: (context, state, child) => WillPopScope(
        onWillPop: ()async{
          print('wilpop');
          state.matchPage=false;
          state.notify();
          MainState mainS = getIt<MainState>();
          mainS.match=null;
          mainS.isOnMatchPage=false;
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: trans,
            leading: IconButton(
              icon: Icon(Icons.arrow_back,color: Colors.black),
              onPressed: (){
                state.matchPage=false;
                state.notify();
                MainState mainS = getIt<MainState>();
                mainS.match=null;
                mainS.isOnMatchPage=false;

              },
            ),
            elevation: 0,
            centerTitle: true,
            title: Text('Match Stats',style: TextStyle(color: Colors.black),),
          ),
          backgroundColor: Color.fromRGBO(244, 244, 244, 1),
          body: SizedBox.expand(
              child: Padding(
            padding: EdgeInsets.all(doubleWidth(6)).copyWith(bottom: 0),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(doubleWidth(8)),
                  width: double.maxFinite,
                  height: doubleHeight(20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                                width: doubleWidth(10),
                                height: doubleWidth(10),
                                child: imageNetwork(
                                  state.selectedMatch.home.logo??'',
                                  fit: BoxFit.fill,
                                )),
                            SizedBox(height: doubleHeight(1)),
                            Text(state.selectedMatch.home.name,textAlign: TextAlign.center,)
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(state.selectedMatch.homeGoals==null?'0':state.selectedMatch.homeGoals.toString(),style: TextStyle(
                                  color: mainBlue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24
                                ),),
                                SizedBox(
                                  width: doubleWidth(4),
                                ),
                                Text(':',style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24
                                )),
                                SizedBox(
                                  width: doubleWidth(4),
                                ),
                                Text(state.selectedMatch.awayGoals==null?'0':state.selectedMatch.awayGoals.toString(),style: TextStyle(
                                    color: Color.fromRGBO(127, 127, 127, 1),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24
                                )),
                              ],
                            ),
                            SizedBox(height: doubleHeight(2)),
                            Builder(
                              builder: (context) {
                                String out='';
                                if(state.selectedMatch.fixture.status=='Match Finished'){
                                  out='Full Time';
                                }else if(state.selectedMatch.fixture.elapsed==null){
                                  out='Not Started';
                                }else out=state.selectedMatch.fixture.elapsed.toString();
                                return Text(out,style: TextStyle(
                                  color: grayCall,
                                  fontSize: 10
                                ));
                              }
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                                width: doubleWidth(10),
                                height: doubleWidth(10),
                                child: imageNetwork(
                                  state.selectedMatch.away.logo??'',
                                  fit: BoxFit.fill,
                                )),
                            SizedBox(height: doubleHeight(1)),
                            Text(state.selectedMatch.away.name,textAlign: TextAlign.center,)
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                    height: doubleHeight(1),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: state.tabs
                      .map((e) => TextButton(
                          onPressed: () {
                            state.selectedTab=e;
                            state.notify();
                          },
                          child: Text(
                            e,
                            style: TextStyle(
                                color: state.selectedTab == e
                                    ? Colors.black
                                    : Colors.grey,
                                fontSize: state.selectedTab == e ? 15 : 12),
                          )))
                      .toList(),
                ),
                SizedBox(
                    height: doubleHeight(2),
                ),
                Expanded(child: Builder(
                  builder: (context) {
                    switch(state.selectedTab){
                      case 'Matchups': return MatchUps();
                      case 'Lineups': return LineUps();
                      case 'Goals': return Goals();
                      case 'Cards': return Cards();
                      case 'Stats': return Stats();
                      default:return SizedBox();
                    }
                  },
                ))
              ],
            ),
          )),
        ),
      ),
    );
  }
}
