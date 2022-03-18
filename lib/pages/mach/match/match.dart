import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shooting_app/dataTypes.dart';
import 'package:shooting_app/pages/mach/match/goals.dart';
import 'package:shooting_app/pages/mach/match/lineups.dart';
import 'package:shooting_app/pages/mach/match/stats.dart';

import '../../../classes/functions.dart';
import '../../../classes/states/match_state.dart';
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
  Widget build(BuildContext context) {
    return Consumer<MatchState>(
      builder: (context, state, child) => Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: Text('Match Stats'),
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
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                            width: doubleWidth(10),
                            height: doubleWidth(10),
                            child: Image.asset(
                              'images/arsenal.png',
                              fit: BoxFit.fill,
                            )),
                        SizedBox(height: doubleHeight(1)),
                        Text('Arsenal')
                      ],
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('3',style: TextStyle(
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
                            Text('0',style: TextStyle(
                                color: Color.fromRGBO(127, 127, 127, 1),
                                fontWeight: FontWeight.bold,
                                fontSize: 24
                            )),
                          ],
                        ),
                        SizedBox(height: doubleHeight(2)),
                        Text('Full Time',style: TextStyle(
                          color: grayCall,
                          fontSize: 10
                        ),)
                      ],
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                            width: doubleWidth(10),
                            height: doubleWidth(10),
                            child: Image.asset(
                              'images/barcelona.png',
                              fit: BoxFit.fill,
                            )),
                        SizedBox(height: doubleHeight(1)),
                        Text('Barcelona')
                      ],
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
    );
  }
}
