import 'package:flutter/material.dart';
import 'package:shooting_app/classes/dataTypes.dart';
import 'package:shooting_app/classes/services/shots_service.dart';
import 'package:shooting_app/main.dart';

import '../classes/functions.dart';
import '../classes/models.dart';
import '../classes/services/my_service.dart';

class ReportSheet extends StatefulWidget {
  const ReportSheet({Key? key, this.post, this.comment, this.reply}) : super(key: key);
  final DataPost? post;
  final DataPostComment? comment;
  final DataCommentReply? reply;

  @override
  State<ReportSheet> createState() => _ReportSheetState();
}

class _ReportSheetState extends State<ReportSheet> {
  List<String> send = [];
  List<String> items = [
    "its_spam"
    "nud"
    "not_like"
    "hate_speech"
    "violence_dangerous"
    "bullying_harassment"
    "false_info"
    "suicide"
    "sale"
    "intellectual"
    "eating"
  ];
  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: EdgeInsets.only(top: doubleHeight(10)),
          child: ClipRRect(
            borderRadius:
                BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
            child: Scaffold(
              appBar: AppBar(
                primary: false,
                leading: IconButton(
                  padding: EdgeInsets.only(top: doubleHeight(3)),
                  onPressed: () {
                    Go.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                ),
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                elevation: 0,
                title: Padding(
                  padding: EdgeInsets.only(top: doubleHeight(3)),
                  child: Text(
                    AppLocalizations.of(context)!.report
                    // 'Report'
                    ,
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
              body: ListView(
                children: [
                  SizedBox(height: doubleHeight(1)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: doubleWidth(5)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.whyreport,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: doubleWidth(5)),
                        ),
                        SizedBox(height: doubleHeight(2)),
                        Text(AppLocalizations.of(context)!.yourreport),
                      ],
                    ),
                  ),
                  ...items
                      .map((e) => CheckboxListTile(
                            onChanged: (f) {
                              setState(() {
                                if (send.contains(e)) {
                                  send.remove(e);
                                } else {
                                  send.add(e);
                                }
                              });
                            },
                            value: send.contains(e),
                            selected: send.contains(e),
                            title: Text(e),
                          ))
                      .toList(),
                  SizedBox(height: doubleHeight(1)),
                  SizedBox(
                      width: double.maxFinite,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: doubleWidth(4)),
                        child: OutlinedButton(
                          style: ButtonStyle(
                              side: MaterialStateProperty.all(BorderSide(color: mainBlue)),
                              padding: MaterialStateProperty.all(
                                  EdgeInsets.symmetric(vertical: doubleHeight(2.5)))),
                          child: loading
                              ? simpleCircle()
                              : Text(
                                  AppLocalizations.of(context)!.sendreport,
                                  // 'Send Report',
                                  style: TextStyle(color: mainBlue),
                                ),
                          onPressed: () async {
                            setState(() {
                              loading = true;
                            });
                            bool back;
                            if (widget.post != null) {
                              back = await ShotsService.shotReport(getIt<MyService>(), context,
                                  message: send.join(','), post: widget.post!);
                            } else if (widget.comment != null) {
                              back = await ShotsService.commentReport(getIt<MyService>(), context,
                                  message: send.join(','), comment: widget.comment!);
                            } else if (widget.reply != null) {
                              back = await ShotsService.replyReport(getIt<MyService>(), context,
                                  message: send.join(','), reply: widget.reply!);
                            } else {
                              back = false;
                              setState(() {
                                loading = false;
                              });
                              return;
                            }
                            setState(() {
                              loading = false;
                            });
                            print('block $back');
                            if (back) {
                              toast(AppLocalizations.of(context)!.report_send_successfully);
                            }
                            Go.pop(context);
                          },
                        ),
                      )),
                  SizedBox(height: doubleHeight(4)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool loading = false;
}
