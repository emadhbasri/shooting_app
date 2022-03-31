import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shooting_app/classes/live_match_model.dart';
import 'package:shooting_app/classes/services/user_service.dart';
import 'package:shooting_app/classes/states/main_state.dart';

import '../../classes/functions.dart';
import '../../classes/services/live_match_service.dart';
import '../../classes/services/my_service.dart';
import '../../classes/dataTypes.dart';
import '../../main.dart';
import '../AppPage.dart';
import '../team_search.dart';

class Team extends StatefulWidget {
  @override
  _TeamState createState() => _TeamState();
}

class _TeamState extends State<Team> {
  LiveMatchService liveMatch = LiveMatchService();
  MyService service = getIt<MyService>();

  List<DataCountry> countries = [];
  DataCountry? country;

  getCountries() async {
    if (countries.isNotEmpty) return;
    countries = await liveMatch.countries();
    print('countries ${countries.length}');
    country =
        countries.singleWhere((element) => element.name == 'England'); //England
    getLeagues();
  }

  List<DataLeagueMain> leagues = [];
  DataLeagueMain? league;
  getLeagues() async {
    leagues = await liveMatch.leagues(
      country: country!.name,
    );
    setState(() {});
    print('leagues ${leagues.length}');
  }

  DataMatchTeam? team;
  List<DataMatchTeam> teams = [];
  DataMatchTeam? searchTeam;
  getTeams() async {
    teams = await liveMatch.getTeams(
        league: league!.league.id, season: league!.latestSeason);
    setState(() {});
    print('leagues ${leagues.length}');
  }

  @override
  void initState() {
    super.initState();
    statusSet(trans);
    getCountries();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: decorImage(img: 'images/stadium.jpg'),
      child: Scaffold(
        backgroundColor: trans,
        body: Stack(
          children: <Widget>[
            Container(
              width: max,
              height: max,
              padding: EdgeInsets.symmetric(horizontal: doubleWidth(4.5)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  GestureDetector(
                    onTap: () async {
                      DataMatchTeam? team =
                          await Go.pushSlideAnim(context, TeamSearch());
                      setState(() {
                        searchTeam = team;
                      });
                    },
                    child: ClipRRect(
                      child: Container(
                          width: max,
                          padding: EdgeInsets.symmetric(
                              horizontal: doubleWidth(5),
                              vertical: doubleHeight(2)),
                          color: Color.fromRGBO(216, 216, 216, 1),
                          child: searchTeam == null
                              ? Text('Search for teams...')
                              : Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (searchTeam!.logo != null)
                                      SizedBox(
                                          width: doubleWidth(8),
                                          height: doubleWidth(8),
                                          child: imageNetwork(searchTeam!.logo!,
                                              fit: BoxFit.fill)),
                                    SizedBox(width: doubleWidth(2)),
                                    Text(searchTeam!.name)
                                  ],
                                )),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  sizeh(doubleHeight(3)),
                  Container(
                    width: max,
                    height: doubleHeight(3),
                    padding: EdgeInsets.symmetric(horizontal: doubleWidth(5)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: doubleWidth(28),
                          decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [
                            gray.withOpacity(0.1),
                            gray.withOpacity(0.2),
                            gray.withOpacity(0.4),
                            gray.withOpacity(0.6),
                            gray.withOpacity(0.8),
                            gray,
                            white
                          ])),
                          height: doubleHeight(0.2),
                        ),
                        Text(
                          'OR',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: doubleWidth(4.5),
                              color: white),
                        ),
                        Container(
                          width: doubleWidth(28),
                          decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [
                            white,
                            gray,
                            gray.withOpacity(0.8),
                            gray.withOpacity(0.6),
                            gray.withOpacity(0.4),
                            gray.withOpacity(0.2),
                            gray.withOpacity(0.1),
                          ])),
                          height: doubleHeight(0.2),
                        ),
                      ],
                    ),
                  ),
                  sizeh(doubleHeight(4)),
                  Text(
                    'Search by country',
                    style: TextStyle(fontSize: doubleWidth(4), color: white),
                  ),
                  sizeh(doubleHeight(3)),
                  ClipRRect(
                    child: Container(
                      width: max,
                      height: doubleHeight(7),
                      padding: EdgeInsets.symmetric(horizontal: doubleWidth(5)),
                      color: Color.fromRGBO(216, 216, 216, 1),
                      child: Center(
                        child: DropdownButton<DataCountry>(
                          items: countries
                              .map((e) => DropdownMenuItem<DataCountry>(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        if (e.flag != null)
                                          SizedBox(
                                            width: doubleWidth(5),
                                            height: doubleWidth(5),
                                            child: SvgPicture.network(e.flag!),
                                          ),
                                        SizedBox(width: doubleWidth(2)),
                                        Text('${e.name} ' +
                                            '${e.code != null ? '(${e.code})' : ''}'),
                                      ],
                                    ),
                                    value: e,
                                  ))
                              .toList(),
                          onChanged: (e) {
                            if (e != null) {
                              setState(() {
                                country = e;
                              });
                              getLeagues();
                            }
                          },
                          underline: non,
                          isDense: true,
                          iconSize: 30,
                          borderRadius: BorderRadius.circular(10),
                          value: country,
                          isExpanded: true,
                          hint: Text('Countries'),
                          icon: Icon(Icons.keyboard_arrow_down),
                        ),
                      ),
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  sizeh(doubleHeight(1.3)),
                  ClipRRect(
                    child: Container(
                      width: max,
                      height: doubleHeight(7),
                      padding: EdgeInsets.symmetric(horizontal: doubleWidth(5)),
                      color: Color.fromRGBO(216, 216, 216, 1),
                      child: Center(
                        child: DropdownButton<DataLeagueMain>(
                          items: leagues
                              .map((e) => DropdownMenuItem<DataLeagueMain>(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        if (e.league.logo != null)
                                          imageNetwork(e.league.logo!),
                                        SizedBox(width: doubleWidth(2)),
                                        Text(e.league.name)
                                      ],
                                    ),
                                    value: e,
                                  ))
                              .toList(),
                          onChanged: (e) {
                            if (e != null) {
                              setState(() {
                                league = e;
                              });
                              getTeams();
                            }
                          },
                          underline: non,
                          isDense: true,
                          iconSize: 30,
                          borderRadius: BorderRadius.circular(10),
                          value: league,
                          isExpanded: true,
                          hint: Text('Leagues'),
                          icon: Icon(Icons.keyboard_arrow_down),
                        ),
                      ),
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  sizeh(doubleHeight(1.3)),
                  ClipRRect(
                    child: Container(
                      width: max,
                      height: doubleHeight(7),
                      padding: EdgeInsets.symmetric(horizontal: doubleWidth(5)),
                      color: Color.fromRGBO(216, 216, 216, 1),
                      child: Center(
                        child: DropdownButton<DataMatchTeam>(
                          items: teams
                              .map((e) => DropdownMenuItem<DataMatchTeam>(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        if (e.logo != null)
                                          imageNetwork(e.logo!),
                                        SizedBox(width: doubleWidth(2)),
                                        Text(e.name)
                                      ],
                                    ),
                                    value: e,
                                  ))
                              .toList(),
                          onChanged: (e) {
                            if (e != null) {
                              setState(() {
                                team = e;
                                searchTeam = e;
                              });
                            }
                          },
                          underline: non,
                          isDense: true,
                          iconSize: 30,
                          borderRadius: BorderRadius.circular(10),
                          value: team,
                          isExpanded: true,
                          hint: Text('Teams'),
                          icon: Icon(Icons.keyboard_arrow_down),
                        ),
                      ),
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  sizeh(doubleHeight(1.3)),
                  Container(
                    width: max,
                    height: doubleHeight(8),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10)),
                      child: RaisedButton(
                        onPressed: () async {
                          print('searchTeam $searchTeam');
                          if (searchTeam == null) {
                            toast('Please pick a team.');
                          } else {
                            bool back = await UsersService.changeTeam(
                                getIt<MyService>(), searchTeam!);
                            if (back) {
                              await getIt<MainState>().getProfile();
                              Go.pushSlideAnim(context, AppPageBuilder());
                            }
                          }
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        color: mainBlue,
                        child: Text(
                          'Join the line up',
                          style:
                              TextStyle(fontSize: doubleWidth(5), color: white),
                        ),
                      ),
                    ),
                  ),
                  sizeh(doubleHeight(17)),
                ],
              ),
            ),
            Align(
              alignment: Alignment(0, -0.7),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    'Choose your team',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: doubleWidth(5),
                        color: white),
                  ),
                  sizeh(doubleHeight(3)),
                  Text(
                    'What\s yout favorite team?',
                    style: TextStyle(fontSize: doubleWidth(4), color: white),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
