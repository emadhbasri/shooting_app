import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shooting_app/ui_items/comment.dart';

class MatchState extends ChangeNotifier {

  static DataComment defaultComment = DataComment(
      comments: [],
      isLiked: false,
      time: '2s',
      profileImage: 'images/158023.png',
      profilename: 'Mason Moreno',
      teamImage: 'images/unnamed.png',
      comment: 'What is the loop of #Creation ? How is there something from nothing? '
          'In spite of the fact that it is impossible to prove that anythin',
      userName: 'masonmoreno',
      commentCount: '1k',
      likeCount: '2');

  List<DataComment> listComment =[
    DataComment(
        comments: [defaultComment,defaultComment],
        isLiked: defaultComment.isLiked,
        time: defaultComment.time,
        profileImage: defaultComment.profileImage,
        profilename: defaultComment.profilename,
        teamImage: defaultComment.teamImage,
        comment: defaultComment.comment,
        userName: defaultComment.userName,
        commentCount: defaultComment.commentCount,
        likeCount: defaultComment.likeCount),
    DataComment(
        comments: [defaultComment],
        isLiked: defaultComment.isLiked,
        time: defaultComment.time,
        profileImage: defaultComment.profileImage,
        profilename: defaultComment.profilename,
        teamImage: defaultComment.teamImage,
        comment: defaultComment.comment,
        userName: defaultComment.userName,
        commentCount: defaultComment.commentCount,
        likeCount: defaultComment.likeCount),
    defaultComment
  ];


  List<String> leagues = ['England','Spanish'];
  String selectedLeague='England';

  List<String> dates = ['17 Dec', 'Yesterday', 'Today', '20 Dec', '21 Dec'];
  String selectedDate = 'Today';

  List<DataMatch> premierLeagueListMatch=[
    DataMatch(
        date: DateTime.now(),
        kikOffTime: 24,
        teamAImage: 'images/arsenal.png',
        teamBImage: 'images/barcelona.png',
        teamAName: 'Arsenal',
        teamBName: 'Barcelona',
        teamAGoals: 0,
        teamBGoals: 3,
        isCup: true),
    DataMatch(
        date: DateTime.now(),
        kikOffTime: 24,
        teamAImage: 'images/manchester-united.png',
        teamBImage: 'images/unnamed.png',
        teamAName: 'Home Team',
        teamBName: 'Away Team',
        teamAGoals: 0,
        teamBGoals: 0,
        isCup: false),
  ];
  List<DataMatch> FACupListMatch=[
    DataMatch(
        date: DateTime.now(),
        kikOffTime: 24,
        teamAImage: 'images/manchester-united.png',
        teamBImage: 'images/unnamed.png',
        teamAName: 'Home Team',
        teamBName: 'Away Team',
        teamAGoals: 0,
        teamBGoals: 0,
        isCup: false),
    DataMatch(
        date: DateTime.now(),
        kikOffTime: 24,
        teamAImage: 'images/manchester-united.png',
        teamBImage: 'images/unnamed.png',
        teamAName: 'Home Team',
        teamBName: 'Away Team',
        teamAGoals: 0,
        teamBGoals: 0,
        isCup: false),
    DataMatch(
        date: DateTime.now(),
        kikOffTime: 24,
        teamAImage: 'images/manchester-united.png',
        teamBImage: 'images/unnamed.png',
        teamAName: 'Home Team',
        teamBName: 'Away Team',
        teamAGoals: 0,
        teamBGoals: 0,
        isCup: false),
    DataMatch(
        date: DateTime.now(),
        kikOffTime: 24,
        teamAImage: 'images/manchester-united.png',
        teamBImage: 'images/unnamed.png',
        teamAName: 'Home Team',
        teamBName: 'Away Team',
        teamAGoals: 0,
        teamBGoals: 0,
        isCup: false),
    DataMatch(
        date: DateTime.now(),
        kikOffTime: 24,
        teamAImage: 'images/manchester-united.png',
        teamBImage: 'images/unnamed.png',
        teamAName: 'Home Team',
        teamBName: 'Away Team',
        teamAGoals: 0,
        teamBGoals: 0,
        isCup: false),

  ];

  List<String> tabs = ['Matchups', 'Lineups', 'Goals', 'Cards', 'Stats'];
  String selectedTab = 'Matchups';

  List<DataStatsItem> listStats = [
    DataStatsItem(teamA: '14', teamB: '16', title: 'shots'),
    DataStatsItem(teamA: '8', teamB: '2', title: 'shots on Target'),
    DataStatsItem(teamA: '50%', teamB: '50%', title: 'Possession'),
    DataStatsItem(teamA: '441', teamB: '435', title: 'Passes'),
    DataStatsItem(teamA: '85%', teamB: '86%', title: 'Pass Accuracy'),
    DataStatsItem(teamA: '14', teamB: '11', title: 'Fouls'),
    DataStatsItem(teamA: '2', teamB: '0', title: 'Yellow Cards'),
    DataStatsItem(teamA: '0', teamB: '0', title: 'Red Cards'),
    DataStatsItem(teamA: '1', teamB: '3', title: 'Offsides'),
    DataStatsItem(teamA: '7', teamB: '5', title: 'Corners'),
  ];
  List<DataCard> teamACard=[
    DataCard(name: 'Willian', time: 79, isRed: false),
    DataCard(name: 'T. Abraham', time: 19, isRed: false),
  ];
  List<DataCard> teamBCard=[
    DataCard(name: 'J. Willock', time: 35, isRed: true),
  ];
  List<DataGoal> teamAGoal=[
    DataGoal(name: 'Willian', time: 79,),
    DataGoal(name: 'Azpilicueta', time: 35,),
    DataGoal(name: 'T. Abraham', time: 19,),
  ];
  List<DataGoal> teamBGoal=[];
  DataLineups teamALineups=DataLineups(
    deck: '4-3-3',
    players: [
      DataPlayer(name: 'Willian', number: 79),
      DataPlayer(name: 'Azpilicueta', number: 35),
      DataPlayer(name: 'T. Abraham', number: 19),
      DataPlayer(name: 'Willian', number: 79),
      DataPlayer(name: 'Azpilicueta', number: 35),
      DataPlayer(name: 'T. Abraham', number: 19),
      DataPlayer(name: 'Willian', number: 79),
      DataPlayer(name: 'Azpilicueta', number: 35),
      DataPlayer(name: 'T. Abraham', number: 19),
      DataPlayer(name: 'Willian', number: 79),
      DataPlayer(name: 'Azpilicueta', number: 35),
    ]
  );
  DataLineups teamBLineups=DataLineups(
      deck: '4-2-3-1',
      players: [
        DataPlayer(name: 'Willian', number: 79),
        DataPlayer(name: 'Azpilicueta', number: 35),
        DataPlayer(name: 'T. Abraham', number: 19),
        DataPlayer(name: 'Willian', number: 79),
        DataPlayer(name: 'Azpilicueta', number: 35),
        DataPlayer(name: 'T. Abraham', number: 19),
        DataPlayer(name: 'Willian', number: 79),
        DataPlayer(name: 'Azpilicueta', number: 35),
        DataPlayer(name: 'T. Abraham', number: 19),
        DataPlayer(name: 'Willian', number: 79),
        DataPlayer(name: 'Azpilicueta', number: 35),
      ]
  );

  notify() => notifyListeners();
}

class DataLineups{
  final String deck;
  final List<DataPlayer> players;

  DataLineups({required this.deck, required this.players});
}

class DataStatsItem {
  final String teamA;
  final String teamB;
  final String title;

  DataStatsItem(
      {required this.teamA, required this.teamB, required this.title});
}
class DataPlayer {
final String name;
final int number;

DataPlayer({required this.name, required this.number});
}
class DataGoal {
  final String name;
  final int time;

  DataGoal({required this.name, required this.time});
}
class DataCard {
  final String name;
  final int time;
  final bool isRed;

  DataCard({required this.name, required this.time, required this.isRed});
}

class DataMatch{
   DateTime date = DateTime.now();
   int kikOffTime=0;
   String teamAImage='';
   String teamBImage='';
   String teamAName='';
   String teamBName='';
   int teamAGoals=0;
   int teamBGoals=0;
   bool isCup=false;

   DataMatch(
      {required this.date,
      required this.kikOffTime,
      required this.teamAImage,
      required this.teamBImage,
      required this.teamAName,
      required this.teamBName,
      required this.teamAGoals,
      required this.teamBGoals,
      required this.isCup});
}


class MatchStateProvider extends StatelessWidget {
  final Widget child;
  const MatchStateProvider({Key? key, required this.child}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListenableProvider<MatchState>(
      create: (context) => MatchState(),
      child: child,
    );
  }
}
