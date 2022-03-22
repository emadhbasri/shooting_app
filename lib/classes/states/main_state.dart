import 'package:shooting_app/classes/live_match_model.dart';
import 'package:shooting_app/classes/my_service.dart';


class MainState{
  late String userId;
  late String userName;
  init()async{
    String? ss=await getString('userid');print('ss $ss');
    userId=ss!;
    ss=await getString('username');print('ss $ss');
    userName=ss!;
  }
  DataMatch1? match;
  bool isOnMatchPage=false;
}