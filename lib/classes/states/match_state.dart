import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shooting_app/classes/live_match_model.dart';
import 'package:shooting_app/classes/services/live_match_service.dart';
import 'package:shooting_app/classes/services/my_service.dart';

import '../../main.dart';
import '../functions.dart';
import '../models.dart';
import '../services/shots_service.dart';
import 'main_state.dart';

late BuildContext firstContext;

class MatchState extends ChangeNotifier {
  bool matchPage = false;

  LiveMatchService liveMatch = LiveMatchService();
  MyService service = getIt<MyService>();
  MainState mainState = getIt<MainState>();
  List<DataCountry> countries = [];
  DataCountry? country;
  String cont = '';
  bool loadCountry = true;
  bool loadMatchs = true;
  init(context) async {
    await Future.delayed(Duration(milliseconds: 200));
    dates = [
      '${date.add(Duration(days: -2)).day} ${getMonString(date.add(Duration(days: -2)))}',
      AppLocalizations.of(context)!.yesterday,
      AppLocalizations.of(context)!.today,
      '${date.add(Duration(days: 1)).day} ${getMonString(date.add(Duration(days: 1)))}',
      '${date.add(Duration(days: 2)).day} ${getMonString(date.add(Duration(days: 2)))}'
    ];
    selectedDate = AppLocalizations.of(context)!.today;
    selectedTab = AppLocalizations.of(context)!.in_play;
    tabs = [
      AppLocalizations.of(context)!.in_play,
      AppLocalizations.of(context)!.lineups,
      AppLocalizations.of(context)!.goals,
      AppLocalizations.of(context)!.cards,
      AppLocalizations.of(context)!.stats
    ];

    List<Future> futures = [];
    futures.add(getCountries());
    // futures.add(getLeagues());
    futures.add(getMatchsV2());
    await Future.wait(futures);
    print('finish leag');
    notifyListeners();
  }

  getCountries() async {
    if (countries.isNotEmpty) return;
    countries = await liveMatch.countries();
    print('countries ${countries.length}');
    country = countries.singleWhere((element) {
      // return element.name == 'World';
      if (mainState.personalInformation != null && mainState.personalInformation!.team != null) {
        return element.name == mainState.personalInformation!.team!.team_country!;
      } else {
        return element.name == country!.name; //
      }
    });
    loadCountry = false;
    notifyListeners();
    // if(!noLeague)
    //   getLeagues();
  }

  List<DataLeagueMain> leagues = [];
  // getLeagues() async {
  //   print('getLeagues');
  //   leagues = await liveMatch.leagues(
  //     country: 'World', //country!.name
  //   );

  //   // leagues.first.league.id
  //   print('leagues.length} ${leagues.length}');

  // int index = leagues.indexWhere((element) => element.league.id == 1);
  // print('leag index $index');
  // if (index != -1) {
  //   DataLeagueMain world = leagues.removeAt(index);
  //   print('world name ${world.league.name}');
  //   print('world logo ${world.league.logo}');
  // }

  //   notifyListeners();
  // }

  getMatchsV2() async {
    print('getMatchsV2');
    //TODO
    //1min todo
    if (loadMatchs == false) {
      loadMatchs = true;
      notifyListeners();
    }
    leagues.clear();

    if (cont == '') {
      // cont = 'World';
      if (mainState.personalInformation != null && mainState.personalInformation!.team != null)
        cont = mainState.personalInformation!.team!.team_country!;
      else
        cont = 'England';
    }
    List<DataMatch1> back = await liveMatch.matchsV2(
      date:
          '${selectedDateTime.year}-${selectedDateTime.month.toString().padLeft(2, '0')}-${selectedDateTime.day.toString().padLeft(2, '0')}',
    );
    back = back.where((element) => element.league.country == cont).toList();
    print('adad ${back.length}');
    for (int j = 0; j < back.length; j++) {
      int index = hasLeague(back[j].league.id);
      if (index == -1) {
        leagues.add(DataLeagueMain.fromDataLeague(back[j].league));
        index = leagues.length - 1;
        leagues[index].matchs.add(back[j]);
      } else {
        leagues[index].matchs.add(back[j]);
      }
    }

    // int index = leagues.indexWhere((element) => element.league.id == 1);
    // print('leag index $index');
    // DataLeagueMain world;
    // if (index != -1) {
    //   DataLeagueMain world = leagues.removeAt(index);
    //   print('world name ${world.league.name}');
    //   print('world logo ${world.league.logo}');
    //   leagues.insert(0, world);
    // }

    loadMatchs = false;
    notifyListeners();
  }

  int hasLeague(int id) => leagues.indexWhere((element) => element.league.id == id);
  late int selectedLeagueIndex;
  getMatch() async {
    //1min todo todo
    print('getMatch()');
    DataMatch1 match1 = await liveMatch.match(id: selectedMatch.fixture.id);
    leagues[selectedLeagueIndex].matchs[selectedMatchIndex].setData(match1);
    selectedMatch.setData(match1);
    mainState.match!.setData(match1);
    print('matchs ${match1.fixture.id}');
    notifyListeners();
    if (matchPage && selectedMatch.isLive == 1) {
      await Future.delayed(Duration(minutes: 1));
      getMatch();
    }
  }

  late int selectedMatchIndex;
  late DataMatch1 selectedMatch;
  getMatchStatics() async {
    //1min todo
    if (selectedMatch.isLive == 0) return;
    if (selectedMatch.homeStatistics.isNotEmpty && selectedMatch.awayStatistics.isNotEmpty) return;
    Map<String, List<DataStatistics>> map =
        await liveMatch.matchStatics(fixture: selectedMatch.fixture.id);
    if (leagues[selectedLeagueIndex].matchs.isNotEmpty) {
      leagues[selectedLeagueIndex].matchs[selectedMatchIndex].homeStatistics = map['home']!;
      leagues[selectedLeagueIndex].matchs[selectedMatchIndex].awayStatistics = map['away']!;
      selectedMatch.homeStatistics = map['home']!;
      selectedMatch.awayStatistics = map['away']!;
    }
    notifyListeners();
  }

  getMatchEvents() async {
    //1min todo
    if (selectedMatch.isLive == 0) return;
    if (selectedMatch.events.isNotEmpty) return;
    List<DataEvent> back = await liveMatch.matchEvents(fixture: selectedMatch.fixture.id);
    selectedMatch.events = back;
    leagues[selectedLeagueIndex].matchs[selectedMatchIndex].events = back;
    notifyListeners();
  }

  bool loadingLineUps = true;
  getMatchLineUps() async {
    //15min todo
    if (selectedMatch.isLive == 0) return;

    if (selectedMatch.homeLineUps != null && selectedMatch.awayLineUps != null) return;
    Map<String, DataLineUps?> map = await liveMatch.matchLineUps(fixture: selectedMatch.fixture.id);
    loadingLineUps = false;
    notifyListeners();
    if (map['home'] != null) {
      if (leagues[selectedLeagueIndex].matchs.isNotEmpty) {
        leagues[selectedLeagueIndex].matchs[selectedMatchIndex].homeLineUps = map['home']!;
        leagues[selectedLeagueIndex].matchs[selectedMatchIndex].awayLineUps = map['away']!;
        selectedMatch.homeLineUps = map['home']!;
        selectedMatch.awayLineUps = map['away']!;
      }
      notifyListeners();
    }
  }

  int matchUpPage = 1;
  getMatchUps({int? pageNumber}) async {
    if (selectedMatch.isLive == 0 || selectedMatch.isLive == 2) return;
    if (mainState.personalInformation!.team == null) return;
    if (selectedMatch.home.id.toString() != mainState.personalInformation!.team!.team_key &&
        selectedMatch.away.id.toString() != mainState.personalInformation!.team!.team_key) return;
    print('getMatchUps()');
    List<DataPost> back = await ShotsService.getMatchUps(
      service,
      // pageNumber: pageNumber??matchUpPage,
      matchId: selectedMatch.fixture.id,
    );
    selectedMatch.matchUps = back;
    leagues[selectedLeagueIndex].matchs[selectedMatchIndex].matchUps = back;
    notifyListeners();
    print('matchUps.length ${selectedMatch.matchUps.length}');
    if (matchPage && selectedMatch.isLive != 0) {
      await Future.delayed(Duration(seconds: 5));
      getMatchUps(pageNumber: 1);
    }
  }

  static DateTime date = DateTime.now();
  List<String> dates = [];
  List<DateTime> dateTimes = [
    date.add(Duration(days: -2)),
    date.add(Duration(days: -1)),
    date,
    date.add(Duration(days: 1)),
    date.add(Duration(days: 2))
  ];
  late String selectedDate;
  DateTime selectedDateTime = date;

  List<String> tabs = [];
  late String selectedTab;
  // init1(){

  // }
  // MatchState() {

  // }

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
