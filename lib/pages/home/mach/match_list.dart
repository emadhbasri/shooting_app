import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shooting_app/classes/live_match_model.dart';
import 'package:shooting_app/classes/states/main_state.dart';
import 'package:shooting_app/classes/states/match_state.dart';
import 'package:shooting_app/classes/states/theme_state.dart';
import 'package:shooting_app/ui_items/shots/index.dart';
import '../../../main.dart';
import 'match/match.dart';

class MatchList extends StatefulWidget {
  const MatchList({Key? key, required this.state}) : super(key: key);
  final MainState state;
  @override
  _MatchListState createState() => _MatchListState();
}

class _MatchListState extends State<MatchList> {
  @override
  void initState() {
    super.initState();
    MatchState mainState = Provider.of(context, listen: false);
    if(mainState.loadCountry)
      mainState.init(context);

  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<MatchState,ThemeState>(
        builder: (context, state,themeState, child){
          // if(state.loadCountry && state.loadMatchs)
          //   return circle();

          if (state.matchPage) {
            return Match();
          } else {
            return Scaffold(
              body: RefreshIndicator(
                onRefresh: ()async{
                  await state.getMatchsV2();
                },
                child: ListView(
                  controller: widget.state.matchListController,
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                      horizontal: doubleWidth(4), vertical: doubleHeight(2)),
                  children: [
                    if(!state.loadCountry)
                      Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: themeState.isDarkMode?myDarkMatchItem: Colors.white
                          ),
                      child: DropdownButton<DataCountry>(
                        items: state.countries
                            .map((e) => DropdownMenuItem<DataCountry>(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('${e.name} ' +
                                  '${e.code != null ? '(${e.code})' : ''}'),
                              if (e.flag != null)
                                SizedBox(width: doubleWidth(2)),
                              if (e.flag != null)
                                SizedBox(
                                  width: doubleWidth(7),
                                  height: doubleWidth(5),
                                  child: SvgPicture.network(e.flag!,placeholderBuilder: (_)
                                  =>CircularProgressIndicator(),
                                  fit: BoxFit.fill,
                                  ),
                                )
                            ],
                          ),
                          value: e,
                        ))
                            .toList(),
                        elevation: 3,
                        dropdownColor: themeState.isDarkMode?myDarkMatchItem: grayCallLight,
                        menuMaxHeight: doubleHeight(70),
                        onChanged: (e) {
                          if (e != null) {
                            state.country = e;
                            state.cont = e.name;
                            state.notify();
                            // state.getLeagues();
                            state.getMatchsV2();
                          }
                        },
                        value: state.country,
                        borderRadius: BorderRadius.circular(10),
                        underline: const SizedBox(),
                        isExpanded: true,
                        icon: Icon(Icons.keyboard_arrow_down_outlined),
                        iconSize: 30,
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: doubleWidth(4), vertical: doubleHeight(1)),
                    )
                    else simpleCircle(),

                    SizedBox(
                      height: doubleHeight(1),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: state.dates
                          .map((e) => TextButton(
                          onPressed: () {
                            int index = state.dates.indexOf(e);
                            state.selectedDateTime = state.dateTimes[index];
                            state.selectedDate = e;
                            state.notify();
                            // state.getMatchs();
                            state.getMatchsV2();
                          },
                          child: Text(
                            e,
                            style: TextStyle(

                              color:
                              themeState.isDarkMode?
                              state.selectedDate == e? null
                                    : Colors.grey


                              :state.selectedDate == e? Colors.black
                                    : Colors.grey

                              ,
                                // color: state.selectedDate == e
                                //     ? Colors.black
                                //     : Colors.grey,
                                fontWeight: state.selectedDate == e ? FontWeight.bold:FontWeight.normal,
                                fontSize: state.selectedDate == e ? 15 : 12),
                          )))
                          .toList(),
                    ),
                    SizedBox(
                      height: doubleHeight(2),
                    ),



                    if(!state.loadMatchs)
                      if(state.leagues.isNotEmpty)
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: state.leagues
                              .map(
                                (e) => MatchListItem(
                                  themeState: themeState,
                              league: e,
                              state: state,
                            ),
                          )
                              .toList(),
                        )else
                          Center(child: Text(AppLocalizations.of(context)!.no_matches_for_today),)
                    else simpleCircle(),


                  ],
                ),
              ),
            );
          }
        }
    );
  }
}

class MatchListItem extends StatefulWidget {
  const MatchListItem({Key? key, required this.league, required this.state, required this.themeState})
      : super(key: key);
  final DataLeagueMain league;
  final MatchState state;
  final ThemeState themeState;
  @override
  State<MatchListItem> createState() => _MatchListItemState();
}

class _MatchListItemState extends State<MatchListItem>
    with AutomaticKeepAliveClientMixin {
  bool isOpen = true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ExpansionTile(
      trailing: isOpen
          ? Icon(Icons.keyboard_arrow_up_outlined)
          : Icon(CupertinoIcons.chevron_forward),
      initiallyExpanded: isOpen,
      onExpansionChanged: (e) {
        // if (e && widget.league.matchs.isEmpty) {
        //   widget.state.selectedLeagueIndex =
        //       widget.state.leagues.indexOf(widget.league);
        //   widget.state.notify();
        //   widget.state.getMatchs();
        // }
        setState(() {
          isOpen = e;
        });
      },
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(child: Text(widget.league.league.name)),
          SizedBox(width: doubleWidth(2)),
          if (widget.league.league.logo != null)
            SizedBox(
              width: doubleWidth(5),
              height: doubleWidth(5),
              child: imageNetwork(widget.league.league.logo!),
            )
        ],
      ),
      children: widget.league.matchs
          .map((e) => Column(
                children: [
                  MatchItem1(
                    themeState: widget.themeState,
                    match: e,
                    state: widget.state,
                  ),
                  if (e != widget.league.matchs.last)
                    SizedBox(height: doubleHeight(1)),
                ],
              ))
          .toList(),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class MatchItem1 extends StatelessWidget {
  const MatchItem1({Key? key, required this.match, required this.state, required this.themeState})
      : super(key: key);
  final DataMatch1 match;
  final MatchState state;
  final ThemeState themeState;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () {
        state.selectedLeagueIndex =state.leagues.indexWhere(
                (e) => e.matchs.contains(match));
        state.selectedMatchIndex =
            state.leagues[state.selectedLeagueIndex].matchs.indexOf(match);

        print('state.selectedLeagueIndex ${state.selectedLeagueIndex}');

        state.selectedMatch = match;
        state.matchPage = true;
        MainState mainS = getIt<MainState>();
        mainS.match = match;
        mainS.isOnMatchPage = true;
        state.notify();
        state.getMatch();
        // state.getMatchStatics();
        // state.getMatchEvents();
        // state.getMatchLineUps();
        state.getMatchUps();
      },
      child: Container(
        decoration: BoxDecoration(
          color: themeState.isDarkMode?myDarkMatchItem: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        width: double.maxFinite,
        height: doubleHeight(15),
        padding: EdgeInsets.symmetric(
            horizontal: doubleWidth(6), vertical: doubleHeight(2)),
        child: Row(
          children: [
            Expanded(
                flex: 2,
                child: Column(
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
                            child: imageNetwork(
                              match.home.logo ?? '',
                              fit: BoxFit.fill,
                            )),
                        SizedBox(width: doubleWidth(4)),
                        Expanded(
                            child: Text(
                          match.home.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ))
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                            width: doubleWidth(7),
                            height: doubleWidth(7),
                            child: imageNetwork(
                              match.away.logo ?? '',
                              fit: BoxFit.fill,
                            )),
                        SizedBox(width: doubleWidth(4)),
                        Expanded(
                            child: Text(
                          match.away.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ))
                      ],
                    ),
                  ],
                )),
            Expanded(
                child: Column(
              children: [
                SizedBox(height: doubleHeight(0.7)),
                Text(
                    match.homeGoals == null ? '0' : match.homeGoals.toString()),
                Spacer(),
                Text(
                    match.awayGoals == null ? '0' : match.awayGoals.toString()),
                SizedBox(height: doubleHeight(0.7)),
              ],
            )),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(height: doubleHeight(0.7)),
                if(match.fixture.isLive!=2)
                Text(AppLocalizations.of(context)!.kick_off_time, style: TextStyle(fontSize: 13)),
                if(match.fixture.isLive!=2)
                Spacer(),
                Text(match.fixture.isLive==0?
                    '${AppLocalizations.of(context)!.start_at} ${match.fixture.date!.hour.toString().padLeft(2,'0')}:${match.fixture.date!.minute.toString().padLeft(2,'0')}'
                    :match.fixture.status, style: TextStyle(fontSize: 12)),
                Spacer(),
                if(match.fixture.isLive==2)
                  Text(AppLocalizations.of(context)!.full_time,
                    style: TextStyle(fontSize: 13))
                else if (match.fixture.elapsed != null)
                  Text('${match.fixture.elapsed} \' ',
                    style: TextStyle(fontSize: 13)),
                SizedBox(height: doubleHeight(0.7)),
              ],
            )),
          ],
        ),
      ),
    );
  }
}
