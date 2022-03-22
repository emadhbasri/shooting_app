import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import '../models.dart';
import '../my_service.dart';

class ProfileState extends ChangeNotifier {
  MyService service = getIt<MyService>();

  // bool isFollowed = false;

  List<String> medias = [
    'images/stadium.jpg',
    'images/Untitled-12.png',
    'images/Untitled-13.png',
    'images/fskldf.jpg',
    'images/boxfinal.png',
    'images/1668011.jpg',
  ];


  String selectedTab = 'Shots';
  List<String> tabs = ['Shots', 'Media', 'Fan Mates'];


  DataPersonalInformation? personalInformation;
  notify() => notifyListeners();
  ProfileState(String username){
    init(username);
  }
  init(String username)async{
    personalInformation = await UsersService.getUser(service,username);
    notifyListeners();
  }

}

class ProfileStateProvider extends StatelessWidget {
  final Widget child;
  final String username;
  const ProfileStateProvider({Key? key, required this.child,required this.username}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListenableProvider<ProfileState>(
      create: (context) => ProfileState(username),
      child: child,
    );
  }
}
