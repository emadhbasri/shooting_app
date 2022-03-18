import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shooting_app/pages/profile/fan_mates.dart';
import 'package:shooting_app/ui_items/comment.dart';

import '../../main.dart';
import '../models.dart';
import '../my_service.dart';

class ProfileState extends ChangeNotifier {
  MyService service = getIt<MyService>();

  bool isFollowed = false;
  static DataComment defaultComment = DataComment(
      comments: [],
      isLiked: false,
      time: '2s',
      profileImage: 'images/158023.png',
      profilename: 'Mason Moreno',
      teamImage: 'images/unnamed.png',
      comment:
          'What is the loop of #Creation ? How is there something from nothing? '
          'In spite of the fact that it is impossible to prove that anythin',
      userName: 'masonmoreno',
      commentCount: '1k',
      likeCount: '2');
  static DataFan defaultFan = DataFan(
      name: 'Mason Moreno',
      image: 'images/158023.png',
      teamImage: 'images/unnamed.png',
      username: 'masonmoreno',
      isFollowed: false);
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
  List<DataFan> fans = [
    DataFan.fromDefault(),
    DataFan.fromDefault(),
    DataFan.fromDefault(),
    DataFan.fromDefault(),
    DataFan.fromDefault(),
    DataFan.fromDefault()
  ];
  List<DataComment> listShots = [
    defaultComment,
    defaultComment,
    defaultComment
  ];

  String selectedTab = 'Shots';
  List<String> tabs = ['Shots', 'Media', 'Fan Mates'];

  bool isMine = true;
  String profileImage = 'images/158023.png';
  String teamImage = 'images/unnamed.png';
  String username = 'masonmoreno';
  String profileName = 'Mason Moreno';
  String shots = '21';
  String followers = '981';
  String following = '63';


  DataPersonalInformation? personalInformation;
  notify() => notifyListeners();

  init()async{
    personalInformation = await UsersService.myProfile(service);
    notifyListeners();
  }

}

class ProfileStateProvider extends StatelessWidget {
  final Widget child;
  const ProfileStateProvider({Key? key, required this.child}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListenableProvider<ProfileState>(
      create: (context) => ProfileState(),
      child: child,
    );
  }
}
