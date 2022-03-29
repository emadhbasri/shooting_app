import 'package:flutter/material.dart';
import 'package:shooting_app/classes/functions.dart';

import '../classes/dataTypes.dart';

class MyNotification extends StatefulWidget {
  const MyNotification({Key? key}) : super(key: key);

  @override
  _MyNotificationState createState() => _MyNotificationState();
}

class _MyNotificationState extends State<MyNotification> {
  final List<DataNotify> notifs = [
    DataNotify(
        profileImage: profileImageDefault,
        teamImage: 'images/arsenal.png',
        text: 'followed you',
        person: 'Kwak Seong-Min',
        hasIcon: false,
        time: '2s'),
    DataNotify(
        profileImage: profileImageDefault,
        teamImage: 'images/barcelona.png',
        text: 'is now live',
        person: 'Andrei Masharin',
        hasIcon: true,
        icon: 'images/live-stream.png',
        time: '1min'),
    DataNotify(
        profileImage: profileImageDefault,
        teamImage: 'images/manchester-united.png',
        text: 'nodded your shot',
        person: 'Ezequiel Dengra',
        hasIcon: false,
        time: '30mins'),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        padding: EdgeInsets.symmetric(
            horizontal: doubleWidth(4), vertical: doubleHeight(2)),
        itemBuilder: (context, index) => ListTile(
              contentPadding: EdgeInsets.zero,
              dense: true,
              leading: SizedBox(
                width: doubleWidth(13),
                child: Stack(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: SizedBox(
                        width: doubleHeight(5),
                        height: doubleHeight(5),
                        child: Container(
                          decoration: BoxDecoration(
                              color: white,
                              borderRadius: BorderRadius.circular(100),
                              image: DecorationImage(
                                image: AssetImage(notifs[index].profileImage),
                              )),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment(1, -1),
                      child: SizedBox(
                        width: doubleHeight(3),
                        height: doubleHeight(3),
                        child: Container(
                          decoration: BoxDecoration(
                              color: white,
                              border: Border.all(color: white, width: 2),
                              borderRadius: BorderRadius.circular(100),
                              image: DecorationImage(
                                image: AssetImage(notifs[index].teamImage),
                              )),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              title: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    notifs[index].person,
                    style: TextStyle(
                        color: black,
                        fontWeight: FontWeight.bold,
                        fontSize: doubleWidth(3.5)),
                  ),
                  SizedBox(width: doubleWidth(1)),
                  Text(
                    notifs[index].text,
                    style: TextStyle(
                        color: black,
                        fontWeight: FontWeight.w600,
                        fontSize: doubleWidth(3)),
                  ),
                  if (notifs[index].hasIcon) SizedBox(width: doubleWidth(1)),
                  if (notifs[index].hasIcon)
                    SizedBox(
                      width: 18,
                      height: 18,
                      child: Image.asset(notifs[index].icon!),
                    ),
                ],
              ),
              trailing: Text('${notifs[index].time}',
                  style: TextStyle(
                      color: grayCall,
                      fontWeight: FontWeight.bold,
                      fontSize: doubleWidth(2.5))),
            ),
        separatorBuilder: (_, __) => Divider(
              color: grayCall,
            ),
        itemCount: notifs.length);
  }
}

class DataNotify {
  String profileImage;
  String teamImage;
  String person;
  String text;
  String? icon;
  bool hasIcon;
  String time;

  DataNotify(
      {required this.person,
      required this.profileImage,
      required this.teamImage,
      required this.text,
      this.icon,
      required this.hasIcon,
      required this.time});
}
