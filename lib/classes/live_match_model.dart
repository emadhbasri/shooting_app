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
  String? type;
  String? logo;

  DataLeague.fromJson(Map<String, dynamic> data) {
    id = convertData(data, 'id', DataType.int);
    name = convertData(data, 'name', DataType.string);
    type = convertData(data, 'type', DataType.string);
    logo = convertData(data, 'logo', DataType.string);
  }
}

class DataLeagueMain {
  late DataLeague league;
  late DataCountry country;
  late int latestSeason;
  List<DataMatch1> matchs=[];
  DataLeagueMain.fromJson(Map<String, dynamic> data) {
    league =
        convertData(data, 'league', DataType.clas, classType: 'DataLeague');
    country =
        convertData(data, 'country', DataType.clas, classType: 'DataCountry');
    List seasons = data['seasons'];
    Map<String, dynamic> map =
        seasons.lastWhere((element) => element['current'] == true);
    latestSeason = map['year'];
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
  late String playerName;
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
  late DataFixture fixture;
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
  DataMatch1.fromJson(Map<String, dynamic> data) {
    print('DataMatch1 $data');
    fixture =
        convertData(data, 'fixture', DataType.clas, classType: 'DataFixture');
    home = convertData(data['teams'], 'home', DataType.clas, classType: 'DataMatchTeam');
    away = convertData(data['teams'], 'away', DataType.clas, classType: 'DataMatchTeam');
    homeGoals = convertData(data['goals'], 'home', DataType.int);
    awayGoals = convertData(data['goals'], 'away', DataType.int);
  }
}

class DataFixture {
  late int id;
  late String status;
  DateTime? date;
  int? elapsed;
  DataFixture.fromJson(Map<String, dynamic> data) {
    id = convertData(data, 'id', DataType.int);
    status = convertData(data['status'], 'long', DataType.string);
    elapsed = convertData(data['status'], 'elapsed', DataType.int);
    date=convertData(data, 'date', DataType.datetime);
  }
}

class DataMatchTeam {
  late int id;
  late String name;
  String? logo;
  bool? winner;
  DataMatchTeam.fromJson(Map<String, dynamic> data) {
    id = convertData(data, 'id', DataType.int);
    name = convertData(data, 'name', DataType.string);
    logo = convertData(data, 'logo', DataType.string);
    winner = convertData(data, 'winner', DataType.bool);
  }
}
