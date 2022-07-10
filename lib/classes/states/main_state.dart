import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:shooting_app/classes/live_match_model.dart';
import 'package:shooting_app/classes/services/my_service.dart';
import 'package:shooting_app/classes/states/match_state.dart';
import 'package:shooting_app/ui_items/dialogs/choose_chat.dart';
import 'package:shooting_app/ui_items/dialogs/choose_sharing_way.dart';

import '../../main.dart';
import '../../pages/home/Home.dart';
import '../../pages/profile/profile.dart';
import '../../pages/shoot/shoot.dart';
import '../../pages/shot/shot.dart';
import '../../ui_items/dialogs/dialog1.dart';
import '../functions.dart';
import '../models.dart';
import '../services/shots_service.dart';
import '../services/user_service.dart';
import 'chat_state.dart';
import 'package:soundpool/soundpool.dart';

class MainState extends ChangeNotifier {
  ///share in app
  receiveShare({List<SharedMediaFile>? sharedFiles, String? sharedText,bool? update}) async {
    print('receiveShare');
    print('sharedFiles $sharedFiles');
    print('sharedText $sharedText');
    if (appPageContext == null) {
      await Future.delayed(Duration(seconds: 1));
      receiveShare(sharedFiles: sharedFiles, sharedText: sharedText);
    } else if (sharedFiles != null || sharedText != null) {
      await Future.delayed(Duration(seconds: 1));
      String? way = await showDialog(
          context: appPageContext!, builder: (context) => ChooseSharingWay());
      print('way $way');
      if (way != null) {
        if (way == 'chat') {
          sharedFiles = sharedFiles;
          sharedText = sharedText;
          Go.push(
              appPageContext!,
              ChooseChatBuilder(
                  sharedText: sharedText, sharedFiles: sharedFiles));
          notifyListeners();
        } else if(way == 'stadia') {
          Go.push(
              appPageContext!,
              Shoot(
                sharedText: sharedText,
                sharedFiles: sharedFiles,
                stadia: true,
              ));
        }else{
          Go.push(
              appPageContext!,
              Shoot(
                sharedText: sharedText,
                sharedFiles: sharedFiles,
                stadia: false,
              ));
        }
      }
    }else if(update!=true){
      bool? alert = await MyAlertDialog(appPageContext,
          content: 'There is a new version for Football Buzz');
      //yes to update green
      //not dismiss
      if(alert==true){
        if(Platform.isAndroid){
          openUrl('https://play.google.com/store/apps/details?id=com.footballbuzz.android');
        }else{
          // openUrl('https://apps.apple.com/us/app/football-buzz/id1618681919');
          openUrl('https://apps.apple.com/us/app/football-buzz/');
        }
      }
    }
  }

  BuildContext? appPageContext;
  reciveNotif(String notifKind, String notifData) async {
    print('state.notifData ${notifData}');
    print('notifKind ${notifKind}');
    if (appPageContext == null) {
      await Future.delayed(Duration(seconds: 1));
      reciveNotif(notifKind, notifData);
    } else {
      await Future.delayed(Duration(seconds: 1));
      if (notifKind == 'User') {
        Go.pushSlideAnim(appPageContext!, ProfileBuilder(username: notifData));
        // notifKind=null;
        // notifData=null;
      } else if (notifKind == 'Shot') {
        Go.pushSlideAnim(
            appPageContext!,
            Shot(
              postId: notifData,
            ));
        // notifKind=null;
        // notifData=null;
      }
    }
  }

  MyService service = getIt<MyService>();
  late ScrollController listController;

  late Soundpool pool;
  late int soundId;
  MyTab tab = MyTab.fanFeed;
  late String userId;
  late String userName;
  play() async {
    await pool.play(soundId);
  }

  init() async {
    pool = Soundpool.fromOptions(
        options: SoundpoolOptions(streamType: StreamType.notification));
    ByteData soundData = await rootBundle.load("assets/images/shooting.mp3");
    soundId = await pool.load(soundData);

    String? ss = await getString('userid');
    print('ss $ss');
    userId = ss!;
    ss = await getString('username');
    print('ss $ss');
    userName = ss!;
    getTags();

  }

  DataPersonalInformation? personalInformation;
  List<DataPost> profilePosts = [];
  int profilePostsPageNumber = 1;
  bool profilePostsHasNext = false;
  bool loadingProfilePost = false;

  Future<void> getProfileShots({bool force = false}) async {
    debugPrint('getProfileShots($force)');
    if (force) {
      profilePostsPageNumber = 1;
      profilePosts.clear();
      loadingProfilePost = true;
      notifyListeners();
    }
    Map<String, dynamic> back = await ShotsService.getByUserId(service,
        pageNumber: profilePostsPageNumber);
    loadingProfilePost = false;
    notifyListeners();
    if (back.length > 0) {
      profilePostsHasNext = back['hasNext'];
      profilePosts.addAll(back['list']);
    }
    // if(noNotify)
    notifyListeners();
  }

  Future<void> getProfile({bool force = false}) async {



    if (force == false && personalInformation != null) return;
    getProfileShots(force: true);
    personalInformation = await UsersService.myProfile(getIt<MyService>());
    // if(noNotify)
    notifyListeners();
  }

  int postsPageNumber = 1;
  bool postsHasNext = false;
  List<DataPost> allPosts = [];
  bool loadingPost = false;
  getFanFeed({bool add = false}) async {
    if (!add) {
      loadingPost = true;
      notifyListeners();
    }
    // allPosts = await ShotsService.shotsAll(service);
    print('add $add');
    Map<String, dynamic> bback =
        await ShotsService.fanFeed(service, pageNumber: postsPageNumber);
    loadingPost = false;
    notifyListeners();
    if (add)
      allPosts.addAll(bback['list']);
    else
      allPosts = bback['list'];

    postsHasNext = postsPageNumber < bback['totalPage'];
    notifyListeners();
    print('allPosts ${allPosts.length}');
  }

  List<String> tags = ['Global'];
  String? selectedTag;
  List<DataPost> stadiaShots = [];
  bool loadingStadia = false;
  getTags() async {
    List<String> tagsTemp = await ShotsService.getStadiaTags(service);
    print('getTags = ${tagsTemp}');
    tags.clear();
    tags.add('Global');
    tags.addAll(tagsTemp.map((e) => e));
    notifyListeners();
    await Future.delayed(Duration(minutes: 5));
    getTags();
  }

  getStadia() async {
    if (selectedTag != null) {
      getStadiaSearch();
    } else {
      loadingStadia = true;
      notifyListeners();
      stadiaShots = await ShotsService.getStadiaShots(service);
      loadingStadia = false;
      notifyListeners();
    }
  }

  getStadiaSearch() async {
    loadingStadia = true;
    notifyListeners();
    if (selectedTag != null) {
      stadiaShots = await ShotsService.getStadiaSearch(service, selectedTag!);
    }
    loadingStadia = false;
    notifyListeners();
  }

  DataMatch1? match;
  bool isOnMatchPage = false;

  ///story

  List<DataStoryUser>? storyViewed;
  List<DataStoryUser>? newStories;
  List<DataStoryMain> myStoriesAll = [];
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
      if (all[j].person.personalInformationId == personalInformation!.id) {
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
      if (out[j].isNotEmpty) allstoryUsers.add(DataStoryUser.fromList(out[j]));
    }
    storyViewed =
        allstoryUsers.where((element) => element.isAllSeen == true).toList();
    newStories =
        allstoryUsers.where((element) => element.isAllSeen == false).toList();

    if (myStoriesAll.isNotEmpty) {
      myStories = null;
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
