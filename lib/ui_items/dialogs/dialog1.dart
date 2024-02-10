import 'package:flutter/material.dart';
import 'package:shooting_app/classes/dataTypes.dart';

import '../../classes/functions.dart';
import '../../package/rflutter_alert/rflutter_alert.dart';

MyAlertDialog(context,
    {AlertType type = AlertType.warning,
    String? title,
    String? content,
    String? yes,
    bool no = true}) async {
  yes ??= AppLocalizations.of(context)!.yes;
  return await Alert(
    context: context,
    type: type,
    title: title,
    desc: content,
    padding: EdgeInsets.symmetric(horizontal: doubleWidth(4)).copyWith(top: doubleHeight(3)),
    style: AlertStyle(
        animationType: AnimationType.grow,
        isCloseButton: false,
        overlayColor: Colors.black.withOpacity(0.5)),
    buttons: [
      if (no)
        DialogButton(
          child: Text(
            AppLocalizations.of(context)!.no,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
          ),
          onPressed: () => Go.pop(context, false),
          color: pink,
        ),
      DialogButton(
        child: Text(
          yes,
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        onPressed: () {
          Go.pop(context, true);
        },
        color: mainGreen,
      )
    ],
  ).show();
}
