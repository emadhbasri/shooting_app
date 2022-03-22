import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import '../models.dart';
import '../my_service.dart';

class MyProfileState extends ChangeNotifier {
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
  /*
  stadium.jpg
  Untitled-12.png
  Untitled-13.png
  fskldf.jpg
  boxfinal.png
  1668011.jpg

   */
  // List<DataFan> fans = [
  //   DataFan.fromDefault(),
  //   DataFan.fromDefault(),
  //   DataFan.fromDefault(),
  //   DataFan.fromDefault(),
  //   DataFan.fromDefault(),
  //   DataFan.fromDefault()
  // ];

  String selectedTab = 'Shots';
  List<String> tabs = ['Shots', 'Media', 'Fan Mates'];

  // bool isMine = true;
  // String profileImage = 'images/158023.png';
  // String teamImage = 'images/unnamed.png';
  // String username = 'masonmoreno';
  // String profileName = 'Mason Moreno';
  // String shots = '21';
  // String followers = '981';
  // String following = '63';


  DataPersonalInformation? personalInformation;
  notify() => notifyListeners();

  init()async{
    if(personalInformation!=null)return;
    personalInformation = await UsersService.myProfile(service);
    notifyListeners();
  }

}

class MyProfileStateProvider extends StatelessWidget {
  final Widget child;
  const MyProfileStateProvider({Key? key, required this.child}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListenableProvider<MyProfileState>(
      create: (context) => getIt<MyProfileState>(),
      child: child,
    );
  }
}
