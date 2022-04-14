import 'models.dart';

class DataCountry {
  late String name;
  String? code;
  String? flag;

  DataCountry.fromJson(Map<String, dynamic> data) {
    name = convertData(data, 'name', DataType.string);
    code = convertData(data, 'code', DataType.string);
    flag = convertData(data, 'flag', DataType.string);
  }
}

class DataLeague {
  late int id;
  late String name;
  String? country;
  String? logo;
  int? season;
  DataLeague.fromJson(Map<String, dynamic> data) {
    id = convertData(data, 'id', DataType.int);
    season = convertData(data, 'season', DataType.int);
    name = convertData(data, 'name', DataType.string);
    country = convertData(data, 'country', DataType.string);
    logo = convertData(data, 'logo', DataType.string);
  }
}

class DataLeagueMain {
  late DataLeague league;
  // late DataCountry country;
  late String country;
  late int latestSeason;
  List<DataMatch1> matchs=[];
  DataLeagueMain.fromJson(Map<String, dynamic> data) {
    league =
        convertData(data, 'league', DataType.clas, classType: 'DataLeague');
    country =
        convertData(data['country'], 'name', DataType.string);
    List seasons = data['seasons'];
    Map<String, dynamic> map =
        seasons.lastWhere((element) => element['current'] == true);
    latestSeason = map['year'];
  }
  DataLeagueMain.fromDataLeague(DataLeague data){
    league=data;
    country=data.country??'';
    if(data.season!=null) {
      latestSeason = data.season!;
    }
  }
}
class DataPlayer{
  late String name;
  int number=0;
  DataPlayer.fromJson(Map<String, dynamic> data) {
    number=convertData(data, 'number', DataType.int);
    name=convertData(data, 'name', DataType.string);
  }
}
class DataLineUps{
  late int teamId;
  String? formation;
  List<DataPlayer> players=[];
  List<DataPlayer> subPlayers=[];
  DataLineUps.fromJson(Map<String, dynamic> data) {
    teamId=convertData(data['team'], 'id', DataType.int);
    formation=convertData(data, 'formation', DataType.string);
    for(int j=0;j<data['startXI'].length;j++){
      players.add(convertData(data['startXI'][j], 'player', DataType.clas,classType: 'DataPlayer'));
    }
    for(int j=0;j<data['substitutes'].length;j++){
      subPlayers.add(convertData(data['substitutes'][j], 'player', DataType.clas,classType: 'DataPlayer'));
    }
  }
}
class DataEvent{
  int? timeElapsed;
  int? timeExtra;
  late int teamId;
  String? playerName;
  late String type;
  late String detail;
  DataEvent.fromJson(Map<String, dynamic> data) {
    timeElapsed=convertData(data['time'], 'elapsed', DataType.int);
    timeExtra=convertData(data['time'], 'extra', DataType.int);
    teamId=convertData(data['team'], 'id', DataType.int);
    playerName=convertData(data['player'], 'name', DataType.string);
    type=convertData(data, 'type', DataType.string);
    detail=convertData(data, 'detail', DataType.string);  }
}
class DataStatistics{

late String type;
String? value;
DataStatistics.fromJson(Map<String, dynamic> data) {
  type=convertData(data, 'type', DataType.string);
  value=convertData(data, 'value', DataType.string);
}
}
class DataMatch1 {
  late int isLive;// 0 not started 1 live 2 finished
  late DataFixture fixture;
  late DataLeague league;
  late DataMatchTeam home;
  late DataMatchTeam away;
  int? homeGoals;
  int? awayGoals;
  List<DataStatistics> homeStatistics=[];
  List<DataStatistics> awayStatistics=[];
  List<DataEvent> events=[];
  List<DataPost> matchUps=[];
  DataLineUps? homeLineUps;
  DataLineUps? awayLineUps;
  setData(DataMatch1 data){
    isLive=data.isLive;
    fixture=data.fixture;
    league=data.league;
    home=data.home;
    away=data.away;
    homeGoals=data.homeGoals;
    awayGoals=data.awayGoals;
    homeStatistics=data.homeStatistics;
    awayStatistics=data.awayStatistics;
    events=data.events;
    homeLineUps=data.homeLineUps;
    awayLineUps=data.awayLineUps;
  }
  DataMatch1.fromJson(Map<String, dynamic> data) {
    print('DataMatch1 $data');
    fixture =
        convertData(data, 'fixture', DataType.clas, classType: 'DataFixture');
    league =
        convertData(data, 'league', DataType.clas, classType: 'DataLeague');
    isLive=fixture.isLive;
    home = convertData(data['teams'], 'home', DataType.clas, classType: 'DataMatchTeam');
    away = convertData(data['teams'], 'away', DataType.clas, classType: 'DataMatchTeam');
    homeGoals = convertData(data['goals'], 'home', DataType.int);
    awayGoals = convertData(data['goals'], 'away', DataType.int);
  }
  DataMatch1.fromAllJson(Map<String, dynamic> all){
    fixture =
        convertData(all, 'fixture', DataType.clas, classType: 'DataFixture');
    league =
        convertData(all, 'league', DataType.clas, classType: 'DataLeague');
    isLive=fixture.isLive;
    home = convertData(all['teams'], 'home', DataType.clas, classType: 'DataMatchTeam');
    away = convertData(all['teams'], 'away', DataType.clas, classType: 'DataMatchTeam');
    homeGoals = convertData(all['goals'], 'home', DataType.int);
    awayGoals = convertData(all['goals'], 'away', DataType.int);

    ///STATICS
    List statics=all['statistics'];
    if(statics.isEmpty){
      homeStatistics=[];
      awayStatistics=[];
    }else{
      homeStatistics=convertDataList<DataStatistics>(
          statics[0], 'statistics', 'DataStatistics');
      awayStatistics=convertDataList<DataStatistics>(
          statics[1], 'statistics', 'DataStatistics');
    }
    ///STATICS
    events = convertDataList<DataEvent>(
        all, 'events', 'DataEvent');
    ///Lineups
    List<DataLineUps> lineups=convertDataList<DataLineUps>(
        all, 'lineups', 'DataLineUps');
    if(lineups.isEmpty) {
      homeLineUps=null;
      awayLineUps=null;
    }else{
      homeLineUps=lineups[0];
      awayLineUps=lineups[1];
    }
    ///Lineups
    //leagues[selectedLeagueIndex].matchs[selectedMatchIndex]
    //selectedMatch
  }
}

class DataFixture {
  late int isLive;// 0 not started 1 live 2 finished
  late int id;
  late String status;
  DateTime? date;

  int? elapsed;
  DataFixture.fromJson(Map<String, dynamic> data) {
    id = convertData(data, 'id', DataType.int);
    status = convertData(data['status'], 'long', DataType.string);
    elapsed = convertData(data['status'], 'elapsed', DataType.int);
    date=DateTime.fromMillisecondsSinceEpoch(data['timestamp'] * 1000);
        // convertData(data, 'date', DataType.datetime);
    if(status=='Match Finished'){
      isLive=2;
    }else if(status =='Not Started'){
      isLive=0;
    }else{
      isLive=1;
    }
  }
}

class DataMatchTeam {
  late int id;
  late String name;
  String? logo;
  String? country;
  bool? winner;
  DataMatchTeam.fromJson(Map<String, dynamic> data) {
    id = convertData(data, 'id', DataType.int);
    name = convertData(data, 'name', DataType.string);
    logo = convertData(data, 'logo', DataType.string);
    country = convertData(data, 'country', DataType.string);
    winner = convertData(data, 'winner', DataType.bool);
  }

  @override
  String toString() {
    return 'DataMatchTeam{id: $id, name: $name, logo: $logo, winner: $winner}';
  }
}
