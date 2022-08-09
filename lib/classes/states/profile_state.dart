import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import '../functions.dart';
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
  ProfileState(String username,context) {
    init(username,context);
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

  init(String username,context) async {
    personalInformation = await UsersService.getUser(service, username);
    print('personalInformation $personalInformation');
    if(personalInformation!=null){
      userName=username;
      getProfileShots(force: true);
      notifyListeners();
    }else{
      toast('User not Found');
      Go.pop(context);
    }

  }
}

class ProfileStateProvider extends StatelessWidget {
  final Widget child;
  final String username;
  final context;
  const ProfileStateProvider(
      {Key? key, required this.child, required this.username,required this.context})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListenableProvider<ProfileState>(
      create: (context) => ProfileState(username,context),
      child: child,
    );
  }
}
