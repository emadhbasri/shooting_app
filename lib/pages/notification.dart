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
  late ScrollController _listController;
  bool notifHasNext = false;
  int pageNumber = 1;
  @override
  void initState() {
    super.initState();
    getData(clean: true);
    _listController = ScrollController()
      ..addListener(() {
        if (notifs.isNotEmpty) {
          if (_listController.position.atEdge &&
              _listController.offset != 0.0) {
            debugPrint("notifHasNext ${notifHasNext}");
            if (notifHasNext) {
              pageNumber++;
              getData();
            }
          }
        }
      });
  }
  getData({bool clean=false}) async {
    if(clean) {
      pageNumber=1;
      notifs.clear();
    };
    Map<String, dynamic>? back = await service.getNotif();
    if (back != null) {
      notifs.addAll(convertDataList<DataNotification>(
          back, 'results', 'DataNotification'));
      print('backnnn ${back.keys}');
      notifHasNext = pageNumber < back['total_pages'];
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        onRefresh: () async {
          await getData(clean: true);
        },
        child: notifs.isEmpty
            ? ListView(
                padding: EdgeInsets.symmetric(vertical: doubleHeight(1)),
                children: [
                  SizedBox(
                      height: doubleHeight(70),
                      width: double.maxFinite,
                      child: Center(child: Text('no notification. 🙂'))),
                ],
              )
            : ListView(
          physics: AlwaysScrollableScrollPhysics(),
                controller: _listController,
                children: [
                  ...notifs
                      .map((e) => Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
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
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                              child: e.personalInformationViewModel
                                                          .profilePhoto !=
                                                      null
                                                  ? imageNetwork(
                                                      e.personalInformationViewModel
                                                              .profilePhoto ??
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
                                              border: Border.all(
                                                  color: Colors.white,
                                                  width: 3),
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                              image: e.personalInformationViewModel
                                                              .team !=
                                                          null &&
                                                      e.personalInformationViewModel
                                                              .team!.team_badge !=
                                                          null
                                                  ? DecorationImage(
                                                      image: networkImage(e
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
                                      e.personalInformationViewModel.fullName ??
                                          '',
                                      style: TextStyle(
                                          color: black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: doubleWidth(3.5)),
                                    ),
                                    SizedBox(width: doubleWidth(1)),
                                    Text(
                                      e.event ?? '',
                                      style: TextStyle(
                                          color: black,
                                          fontWeight: FontWeight.w600,
                                          fontSize: doubleWidth(3)),
                                    ),
                                    // if (e.hasIcon) SizedBox(width: doubleWidth(1)),
                                    // if (e.hasIcon)
                                    //   SizedBox(
                                    //     width: 18,
                                    //     height: 18,
                                    //     child: Image.asset(e.icon!),
                                    //   ),
                                  ],
                                ),
                                trailing: Text(
                                    makeDurationToString(
                                        DateTime.parse(e.timeStamp)),
                                    style: TextStyle(
                                        color: grayCall,
                                        fontWeight: FontWeight.bold,
                                        fontSize: doubleWidth(2.5))),
                              ),
                              if (e != notifs.last)
                                Divider(
                                  color: grayCall,
                                )
                            ],
                          ))
                      .toList(),
                  if (notifHasNext)
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: doubleHeight(1)),
                        CircularProgressIndicator(),
                        SizedBox(height: doubleHeight(1)),
                      ],
                    )
                ],
                padding: EdgeInsets.symmetric(
                    horizontal: doubleWidth(4), vertical: doubleHeight(2)),
              ));
  }
}
