import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import '../models.dart';
import '../services/my_service.dart';
import '../services/shots_service.dart';
import '../services/user_service.dart';

class ProfileState extends ChangeNotifier {
  MyService service = getIt<MyService>();

  String selectedTab = 'Shots';
  List<String> tabs = ['Shots', 'Fan Mates'];//'Media'

  DataPersonalInformation? personalInformation;
  notify() => notifyListeners();
  ProfileState(String username) {
    init(username);
  }
  late String userName;

  List<DataPost> profilePosts=[];
  int profilePostsPageNumber=1;
  bool profilePostsHasNext=false;
  bool loadingProfilePost=false;

  Future<void> getProfileShots({bool force=false}) async {
    debugPrint('getProfileShots($force)');
    if (force) {
      profilePostsPageNumber = 1;
      profilePosts.clear();
      loadingProfilePost = true;
      notifyListeners();
    }
    Map<String,dynamic> back = await ShotsService.getByUsername(
        service,pageNumber: profilePostsPageNumber,username: userName);
    loadingProfilePost = false;notifyListeners();
    if(back.length>0){
      profilePostsHasNext=back['hasNext'];
      profilePosts.addAll(back['list']);
    }
    // if(noNotify)
    notifyListeners();
  }

  init(String username) async {
    personalInformation = await UsersService.getUser(service, username);
    userName=username;
    getProfileShots(force: true);
    notifyListeners();
  }
}

class ProfileStateProvider extends StatelessWidget {
  final Widget child;
  final String username;
  const ProfileStateProvider(
      {Key? key, required this.child, required this.username})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListenableProvider<ProfileState>(
      create: (context) => ProfileState(username),
      child: child,
    );
  }
}
