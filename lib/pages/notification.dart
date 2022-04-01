import 'package:flutter/material.dart';
import 'package:shooting_app/classes/functions.dart';
import 'package:shooting_app/classes/models.dart';
import 'package:shooting_app/classes/services/my_service.dart';

import '../classes/dataTypes.dart';
import '../main.dart';

class MyNotification extends StatefulWidget {
  const MyNotification({Key? key}) : super(key: key);

  @override
  _MyNotificationState createState() => _MyNotificationState();
}

class _MyNotificationState extends State<MyNotification> {
  List<DataNotification> notifs = [];
  MyService service = getIt<MyService>();
@override
  void initState() {
    super.initState();
    getData();
  }//mohammadhope13711371
  getData()async{
    notifs = await service.getNotif();
    setState(() {});
  }
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
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: notifs[index].personalInformationViewModel.profilePhoto !=
                                null
                                ? imageNetwork(
                                notifs[index].personalInformationViewModel.profilePhoto ??
                                    '',
                                fit: BoxFit.fill)
                                : null),
                      ),
                    ),
                    Align(
                      alignment: Alignment(1, -1),
                      child: SizedBox(
                        width: doubleHeight(3),
                        height: doubleHeight(3),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.white, width: 3),
                            borderRadius: BorderRadius.circular(100),
                            image:
                            notifs[index].personalInformationViewModel.team != null &&
                                notifs[index].personalInformationViewModel.team!
                                    .team_badge !=
                                    null
                                ? DecorationImage(
                              image: networkImage(notifs[index]
                                  .personalInformationViewModel
                                  .team!
                                  .team_badge!),
                            )
                                : null,
                          ),
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
                    notifs[index].personalInformationViewModel.fullName??'',
                    style: TextStyle(
                        color: black,
                        fontWeight: FontWeight.bold,
                        fontSize: doubleWidth(3.5)),
                  ),
                  SizedBox(width: doubleWidth(1)),
                  Text(
                    notifs[index].event??'',
                    style: TextStyle(
                        color: black,
                        fontWeight: FontWeight.w600,
                        fontSize: doubleWidth(3)),
                  ),
                  // if (notifs[index].hasIcon) SizedBox(width: doubleWidth(1)),
                  // if (notifs[index].hasIcon)
                  //   SizedBox(
                  //     width: 18,
                  //     height: 18,
                  //     child: Image.asset(notifs[index].icon!),
                  //   ),
                ],
              ),
              trailing: Text(makeDurationToString(DateTime.parse(notifs[index].timeStamp)),
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

