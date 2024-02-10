import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shooting_app/classes/functions.dart';
import 'package:shooting_app/classes/models.dart';
import 'package:shooting_app/classes/services/my_service.dart';
import 'package:shooting_app/classes/states/theme_state.dart';
import 'package:shooting_app/pages/profile/profile.dart';
import 'package:shooting_app/pages/shot/shot.dart';

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
  bool loading = false;
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

  getData({bool clean = false}) async {
    if (clean) {
      pageNumber = 1;
      notifs.clear();
      setState(() {
        loading = true;
      });
    }

    Map<String, dynamic>? back = await service.getNotif(pageNumber: pageNumber);
    if(loading)
      setState(() {
        loading = false;
      });
    if (back != null) {
      print('back $pageNumber ${back}');
      notifs.addAll(convertDataList<DataNotification>(
          back, 'results', 'DataNotification'));
      print('backnnn ${back.keys}');
      notifHasNext = pageNumber < back['total_pages'];
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) return circle();
    // ThemeState theme = Provider.of<ThemeState>(context,listen: false);

     return RefreshIndicator(
        onRefresh: () async {
          await getData(clean: true);
        },
        child: notifs.isEmpty
            ? ListView(
          physics: AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(vertical: doubleHeight(1)),
          children: [
            SizedBox(
                height: doubleHeight(70),
                width: double.maxFinite,
                child: Center(child: Text(
                  '${
                    AppLocalizations.of(context)!.nonotification
                    // 'no notification.'
                    } 🙂'))),
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
                  onTap: () {
                    print('data ${e.data}');
                    print('kind ${e.kind}');
                    if (e.data != null && e.kind != null) {
                      if (e.kind == 'User') {
                        Go.push(context,
                            ProfileBuilder(username: e.data!));
                      } else if (e.kind == 'Shot') {
                        Go.push(
                            context,
                            Shot(
                              postId: e.data!,
                            ));
                      }
                    }
                  },
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                  leading: GestureDetector(
                    onTap: () {
                      Go.push(
                          context,
                          ProfileBuilder(
                              username: e
                                  .personalInformationViewModel
                                  .userName));
                    },
                    child: SizedBox(
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
                                      : profilePlaceHolder(context)),
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
                  ),
                  title: Consumer<ThemeState>(builder: (context, theme, child) {
     return RichText(
                    textAlign: TextAlign.left,
                    text: TextSpan(
                        children: [
                          TextSpan(
                            text:e.personalInformationViewModel.fullName ??
                                '',
                            style: TextStyle(
                                color: theme.isDarkMode?white:black,
                                fontWeight: FontWeight.bold,
                                fontSize: doubleWidth(3.5)),
                          ),
                          TextSpan(
                            text:' ',
                            style: TextStyle(
                                color: theme.isDarkMode?white:black,
                                fontWeight: FontWeight.w600,
                                fontSize: doubleWidth(3)),
                          ),
                          TextSpan(
                            text:e.notificationMessage ?? '',
                            style: TextStyle(
                                color: theme.isDarkMode?white:black,
                                fontWeight: FontWeight.w600,
                                fontSize: doubleWidth(3)),
                          ),
                      ]));
    }),

                  trailing: e.timeStamp == null
                      ? null
                      : Text(
                      makeDurationToString(
                          DateTime.parse(e.timeStamp!)),
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
