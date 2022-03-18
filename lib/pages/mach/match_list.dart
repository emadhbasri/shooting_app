import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shooting_app/classes/functions.dart';
import 'package:shooting_app/classes/states/match_state.dart';
import 'package:shooting_app/pages/mach/match/match.dart';
import 'package:shooting_app/ui_items/drawer.dart';

class MatchListBuilder extends StatelessWidget {
  const MatchListBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MatchStateProvider(
      child: MatchList(),
    );
  }
}
class MatchList extends StatefulWidget {
  const MatchList({Key? key}) : super(key: key);

  @override
  _MatchListState createState() => _MatchListState();
}

class _MatchListState extends State<MatchList> {
  @override
  Widget build(BuildContext context) {
    final MatchState state = Provider.of(context,listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Live Scores'),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: (){
            Go.pushSlideAnimDrawer(context, MyDrawer(page: 'live scores'));
          },
        ),
      ),
      body: ListView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(
          horizontal: doubleWidth(4),
          vertical: doubleHeight(2)
        ),
        children: [
          Consumer<MatchState>(
            builder: (context, state, child) =>
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white
                  ),
                  child: DropdownButton<String>(
                    items: state.leagues.map((e) =>
                        DropdownMenuItem<String>(child: Text(e),
                          value: e,)
                    ).toList(),
                    onChanged: (e){
                      if(e!=null){
                        state.selectedLeague=e;
                        state.notify();
                      }
                    },
                    value: state.selectedLeague,
                    borderRadius: BorderRadius.circular(10),
                    underline: const SizedBox(),
                    isExpanded: true,
                    icon: Icon(Icons.keyboard_arrow_down_outlined),
                    iconSize: 30,
                  ),
                  padding: EdgeInsets.symmetric(
                      horizontal: doubleWidth(4),
                      vertical: doubleHeight(1)
                  ),
                ),
          ),

          SizedBox(
            height: doubleHeight(1),
          ),
          Consumer<MatchState>(builder:
          (context, state, child) =>
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: state.dates
                    .map((e) => TextButton(
                    onPressed: () {
                      state.selectedDate=e;
                      state.notify();
                    },
                    child: Text(
                      e,
                      style: TextStyle(
                          color: state.selectedDate == e
                              ? Colors.black
                              : Colors.grey,
                          fontSize: state.selectedDate == e ? 15 : 12),
                    )))
                    .toList(),
              ),
          ),
          SizedBox(
            height: doubleHeight(2),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Premier League'),
              Icon(Icons.arrow_forward_ios)
            ],
          ),
          SizedBox(height: doubleHeight(2)),
          ...state.premierLeagueListMatch.map((e) => 
            Column(
              children: [
                MatchItem(match: e),
                if(e!=state.premierLeagueListMatch.last)
                  SizedBox(height: doubleHeight(1)),
              ],
            )
          ).toList(),
          SizedBox(height: doubleHeight(2)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('FA Cup'),
              Icon(Icons.arrow_forward_ios)
            ],
          ),
          SizedBox(height: doubleHeight(2)),
          ...state.FACupListMatch.map((e) =>
              Column(
                children: [
                  MatchItem(match: e),
                  if(e!=state.FACupListMatch.last)
                    SizedBox(height: doubleHeight(1)),
                ],
              )
          ).toList(),
        ],
      ),
    );
  }
}

class MatchItem extends StatelessWidget {
  const MatchItem({Key? key,required this.match}) : super(key: key);
  final DataMatch match;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Go.pushSlideAnim(context, MatchBuilder());
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        width: double.maxFinite,
        height: doubleHeight(15),
        padding: EdgeInsets.symmetric(
          horizontal: doubleWidth(6),
          vertical: doubleHeight(2)
        ),
        child: Row(
          children: [
            Expanded(flex:2,child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                        width: doubleWidth(7),
                        height: doubleWidth(7),
                        child: Image.asset(
                          match.teamAImage,
                          fit: BoxFit.fill,
                        )),
                    SizedBox(width: doubleWidth(4)),
                    Text(match.teamAName)
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                        width: doubleWidth(7),
                        height: doubleWidth(7),
                        child: Image.asset(
                          match.teamBImage,
                          fit: BoxFit.fill,
                        )),
                    SizedBox(width: doubleWidth(4)),
                    Text(match.teamBName)
                  ],
                ),
              ],
            )),
            Expanded(child: Column(
              children: [
                SizedBox(height: doubleHeight(0.7)),
                Text(match.teamAGoals.toString()),
                Spacer(),
                Text(match.teamBGoals.toString()),
                SizedBox(height: doubleHeight(0.7)),
              ],
            )),
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(height: doubleHeight(0.7)),
                Text('Kick Off time',style: TextStyle(
                  fontSize: 13
                )),
                Spacer(),

                Text(match.isCup?'FA Cup':'League',style: TextStyle(
                    fontSize: 13
                )),
                Spacer(),

                Text('${match.teamBGoals} \'  ',style: TextStyle(
                    fontSize: 13
                )),
                SizedBox(height: doubleHeight(0.7)),
              ],
            )),
          ],
        ),
      ),
    );
  }
}

