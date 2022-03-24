import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shooting_app/classes/live_match_model.dart';
import 'package:shooting_app/classes/services/my_service.dart';
import 'package:shooting_app/classes/states/match_state.dart';

import '../../main.dart';
import '../models.dart';
import '../services/shots_service.dart';
import '../services/user_service.dart';
import 'chat_state.dart';


class MainState extends ChangeNotifier {
  MyService service = getIt<MyService>();

  late String userId;
  late String userName;
  init()async{
    String? ss=await getString('userid');print('ss $ss');
    userId=ss!;
    ss=await getString('username');print('ss $ss');
    userName=ss!;
  }
  DataPersonalInformation? personalInformation;
  Future<void> getProfile()async{
    if(personalInformation!=null)return;
    personalInformation = await UsersService.myProfile(getIt<MyService>());
    notifyListeners();
  }
  List<DataPost> allPosts = [];
  getFanFeed() async {
    allPosts = await ShotsService.shotsAll(service);
    // allPosts = await ShotsService.fanFeed(service);
  notifyListeners();
    print('allPosts ${allPosts.length}');
  }

  DataMatch1? match;
  bool isOnMatchPage=false;

///story
  String url = 'https://upload.wikimedia.org/wikipedia/commons/thumb/7/71/Bill_Gates_Buys_Skype_%285707954468%29.jpg/2560px-Bill_Gates_Buys_Skype_%285707954468%29.jpg';
  ///story



  notify() => notifyListeners();

}
class MainStateProvider extends StatelessWidget {
  final Widget child;
  const MainStateProvider({Key? key, required this.child}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ListenableProvider<MainState>(
        create: (context) => getIt<MainState>(),
      ),
      ListenableProvider<MatchState>(
        create: (context) => getIt<MatchState>(),
      ),
      ListenableProvider<ChatState>(
        create: (context) => getIt<ChatState>(),
      ),
    ],
    builder:(BuildContext context, Widget? _)=>child,
    );

  }
}