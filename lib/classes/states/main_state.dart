import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shooting_app/classes/live_match_model.dart';
import 'package:shooting_app/classes/services/my_service.dart';
import 'package:shooting_app/classes/states/match_state.dart';

import '../../main.dart';
import '../../pages/home/Home.dart';
import '../models.dart';
import '../services/shots_service.dart';
import '../services/user_service.dart';
import 'chat_state.dart';
import 'package:soundpool/soundpool.dart';
class MainState extends ChangeNotifier {
  MyService service = getIt<MyService>();


  late Soundpool pool;
  late int soundId;
  MyTab tab = MyTab.fanFeed;
  late String userId;
  late String userName;
  play()async{
    int streamId = await pool.play(soundId);
  }
  init() async {
    pool = Soundpool.fromOptions(
      options: SoundpoolOptions(streamType: StreamType.notification
      )
    );
    ByteData soundData = await rootBundle.load("assets/images/shooting.mp3");
    soundId = await pool.load(soundData);

    String? ss = await getString('userid');
    print('ss $ss');
    userId = ss!;
    ss = await getString('username');
    print('ss $ss');
    userName = ss!;
  }

  DataPersonalInformation? personalInformation;
  Future<void> getProfile({bool force=false}) async {
    if (force==false && personalInformation != null) return;
    personalInformation = await UsersService.myProfile(getIt<MyService>());
    // if(noNotify)
      notifyListeners();
  }
  int postsPageNumber = 1;
  bool postsHasNext=false;
  List<DataPost> allPosts = [];
  bool loadingPost=false;
  getFanFeed({bool add=false}) async {
    if(!add){loadingPost=true;notifyListeners();}
    // allPosts = await ShotsService.shotsAll(service);
    print('add $add');
    Map<String,dynamic> bback = await ShotsService.fanFeed(service,pageNumber: postsPageNumber);
    loadingPost=false;notifyListeners();
    if(add)
      allPosts.addAll(bback['list']);
    else
      allPosts=bback['list'];

    postsHasNext=postsPageNumber<bback['totalPage'];
    notifyListeners();
    print('allPosts ${allPosts.length}');
  }

  DataMatch1? match;
  bool isOnMatchPage = false;

  ///story

  List<DataStoryUser>? storyViewed;
  List<DataStoryUser>? newStories;
  List<DataStoryMain> myStoriesAll=[];
  DataStoryUser? myStories;
  // getMyStories() async {
  //   List<DataStoryMain> all = await service.myStories();
  //   print('all ${all.length}');
  //   myStories = DataStoryUser.fromList(all);
  //
  //   notifyListeners();
  // }
  getStories() async {
    // List<DataStoryMain> all = await service.getStories();
    List<DataStoryMain> all = await service.myStories();
    print('all ${all.length}');
    List<DataPersonalInformationViewModel> persons = [];
    List<List<DataStoryMain>> out = [];
    myStoriesAll.clear();
    for (int j = 0; j < all.length; j++) {
      if(all[j].person.personalInformationId==personalInformation!.id){
        myStoriesAll.add(all[j]);
        continue;
      }
      int index = hasPerson(persons, all[j].person);
      if (index == -1) {
        persons.add(all[j].person);
        out.add([all[j]]);
      } else {
        out[index].add(all[j]);
      }
    }
    List<DataStoryUser> allstoryUsers = [];
    for (int j = 0; j < out.length; j++) {
      if(out[j].isNotEmpty)
        allstoryUsers.add(DataStoryUser.fromList(out[j]));
    }
    storyViewed =
        allstoryUsers.where((element) => element.isAllSeen == true).toList();
    newStories =
        allstoryUsers.where((element) => element.isAllSeen == false).toList();

    if(myStoriesAll.isNotEmpty) {
      myStories=null;
      myStories = DataStoryUser.fromList(myStoriesAll);
    }
    notifyListeners();
  }

  notify() => notifyListeners();
}

int hasPerson(List<DataPersonalInformationViewModel> persons,
        DataPersonalInformationViewModel person) =>
    persons.indexWhere((element) =>
        element.personalInformationId == person.personalInformationId);

class MainStateProvider extends StatelessWidget {
  final Widget child;
  const MainStateProvider({Key? key, required this.child}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
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
      builder: (BuildContext context, Widget? _) => child,
    );
  }
}
