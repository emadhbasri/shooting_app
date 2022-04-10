import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import '../models.dart';
import '../services/my_service.dart';
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
  init(String username) async {
    personalInformation = await UsersService.getUser(service, username);
    userName=username;
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
