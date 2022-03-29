import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shooting_app/classes/live_match_model.dart';
import 'package:shooting_app/classes/services/live_match_service.dart';
import 'package:shooting_app/classes/services/my_service.dart';

import '../../main.dart';
import '../functions.dart';
import '../models.dart';
import '../services/shots_service.dart';

class MatchState extends ChangeNotifier {
  bool matchPage = false;

  LiveMatchService liveMatch = LiveMatchService();
  MyService service = getIt<MyService>();

  List<DataCountry> countries = [];
  DataCountry? country;
  bool loadMainMatchList=true;
  init()async{
    await getCountries(noLeague: true);
    print('finish cont');
    await getLeagues();
    print('finish leag');
    loadMainMatchList=false;
    notifyListeners();
  }
  getCountries({bool noLeague=false}) async {
    if (countries.isNotEmpty) return;
    countries = await liveMatch.countries();
    print('countries ${countries.length}');
    country =
        countries.singleWhere((element) => element.name == 'England'); //England
    notifyListeners();
    if(!noLeague)
      getLeagues();
  }

  List<DataLeagueMain> leagues = [];
  getLeagues() async {
    leagues = await liveMatch.leagues(
      country: country!.name,
    );
    print('leagues ${leagues.length}');
    notifyListeners();
  }

  late int selectedLeagueIndex;
  getMatchs() async {
    leagues[selectedLeagueIndex].matchs = await liveMatch.matchs(
        date:
            '${selectedDateTime.year}-${selectedDateTime.month.toString().padLeft(2, '0')}-${selectedDateTime.day.toString().padLeft(2, '0')}',
        league: leagues[selectedLeagueIndex].league.id,
        season: leagues[selectedLeagueIndex].latestSeason);
    print('matchs ${leagues[selectedLeagueIndex].matchs.length}');
    notifyListeners();
  }
  getMatch() async {//1min todo todo
    leagues[selectedLeagueIndex].matchs = await liveMatch.matchs(
        date:
            '${selectedDateTime.year}-${selectedDateTime.month.toString().padLeft(2, '0')}-${selectedDateTime.day.toString().padLeft(2, '0')}',
        league: leagues[selectedLeagueIndex].league.id,
        season: leagues[selectedLeagueIndex].latestSeason);
    print('matchs ${leagues[selectedLeagueIndex].matchs.length}');
    notifyListeners();
  }

  late int selectedMatchIndex;
  late DataMatch1 selectedMatch;
  getMatchStatics() async {//1min todo
    if(selectedMatch.isLive==0)return;
    if (selectedMatch.homeStatistics.isNotEmpty &&
        selectedMatch.awayStatistics.isNotEmpty) return;
    Map<String, List<DataStatistics>> map =
        await liveMatch.matchStatics(fixture: selectedMatch.fixture.id);
    if (leagues[selectedLeagueIndex].matchs.isNotEmpty) {
      leagues[selectedLeagueIndex].matchs[selectedMatchIndex].homeStatistics =
          map['home']!;
      leagues[selectedLeagueIndex].matchs[selectedMatchIndex].awayStatistics =
          map['away']!;
      selectedMatch.homeStatistics = map['home']!;
      selectedMatch.awayStatistics = map['away']!;
    }
    notifyListeners();
  }

  getMatchEvents() async {//1min todo
    if(selectedMatch.isLive==0)return;
    if (selectedMatch.events.isNotEmpty) return;
    List<DataEvent> back =
        await liveMatch.matchEvents(fixture: selectedMatch.fixture.id);
    selectedMatch.events = back;
    leagues[selectedLeagueIndex].matchs[selectedMatchIndex].events = back;
    notifyListeners();
  }

  bool loadingLineUps = true;
  getMatchLineUps() async {//15min todo
    if(selectedMatch.isLive==0)return;

    if (selectedMatch.homeLineUps != null && selectedMatch.awayLineUps != null)
      return;
    Map<String, DataLineUps?> map =
        await liveMatch.matchLineUps(fixture: selectedMatch.fixture.id);
    loadingLineUps = false;
    notifyListeners();
    if (map['home'] != null) {
      if (leagues[selectedLeagueIndex].matchs.isNotEmpty) {
        leagues[selectedLeagueIndex].matchs[selectedMatchIndex].homeLineUps =
            map['home']!;
        leagues[selectedLeagueIndex].matchs[selectedMatchIndex].awayLineUps =
            map['away']!;
        selectedMatch.homeLineUps = map['home']!;
        selectedMatch.awayLineUps = map['away']!;
      }
      notifyListeners();
    }
  }

  getMatchUps() async {
    if(selectedMatch.isLive==0)return;
    print('getMatchUps()');
    if (selectedMatch.matchUps.isNotEmpty) return;
    List<DataPost> back = await ShotsService.getMatchUps(service,
        teamHomeId: selectedMatch.home.id,
        teamAwayId: selectedMatch.away.id,
        date: '${selectedMatch.fixture.date!.year}-'
            '${selectedMatch.fixture.date!.month.toString().padLeft(2, '0')}-'
            '${selectedMatch.fixture.date!.day.toString().padLeft(2, '0')}');
    selectedMatch.matchUps = back;
    leagues[selectedLeagueIndex].matchs[selectedMatchIndex].matchUps = back;
    notifyListeners();
    print('matchUps.length ${selectedMatch.matchUps.length}');
    notifyListeners();
  }

  // List<String> leagues = ['England','Spanish'];

  static DateTime date = DateTime.now();
  List<String> dates = [
    '${date.add(Duration(days: -2)).day} ${getMonString(date.add(Duration(days: -2)))}',
    'Yesterday',
    'Today',
    '${date.add(Duration(days: 1)).day} ${getMonString(date.add(Duration(days: 1)))}',
    '${date.add(Duration(days: 2)).day} ${getMonString(date.add(Duration(days: 2)))}'
  ];
  List<DateTime> dateTimes = [
    date.add(Duration(days: -2)),
    date.add(Duration(days: -1)),
    date,
    date.add(Duration(days: 1)),
    date.add(Duration(days: 2))
  ];
  String selectedDate = 'Today';
  DateTime selectedDateTime = date;

  List<String> tabs = ['Matchups', 'Lineups', 'Goals', 'Cards', 'Stats'];
  String selectedTab = 'Matchups';

  notify() => notifyListeners();
}

class MatchStateProvider extends StatelessWidget {
  final Widget child;
  const MatchStateProvider({Key? key, required this.child}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListenableProvider<MatchState>(
      create: (context) => getIt<MatchState>(),
      child: child,
    );
  }
}
