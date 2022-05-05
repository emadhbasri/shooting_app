export 'reply_from_shot.dart';

export '../bottom_sheet.dart';
export '../dialogs/share_dialog.dart';
export '../../classes/functions.dart';

export '../../classes/models.dart';

import 'package:flutter/material.dart';
export 'package:flutter/material.dart';
import '../../classes/dataTypes.dart';
import '../../classes/functions.dart';
export '../../classes/dataTypes.dart';

Widget convertHashtag(String text, Function(String) onTapTag) {
  List<String> split = text.split(' ');
  // List<String> split = text.split('#');
  // List<String> hashtags = split.getRange(1, split.length).fold([], (t, e) {
  //   var texts = e.split(" ");
  //   if (texts.length > 1) {
  //     return List.from(t)
  //       ..addAll(["#${texts.first}", "${e.substring(texts.first.length)}"]);
  //   }
  //   return List.from(t)..add("#${texts.first}");
  // });
  return SizedBox(
    width: double.maxFinite,
    child: Wrap(
      alignment: WrapAlignment.start,
      crossAxisAlignment: WrapCrossAlignment.start,
      runAlignment: WrapAlignment.start,
      spacing: 3,
      children: split.map((e) {
        if (e.length > 0) {
          // if (e[0] == '#') {
          //   return GestureDetector(onLongPress: (){
          //     copyText(text);
          //   },
          //       onTap: () {
          //         onTapTag(e);
          //       },
          //       child: Text(e, style: TextStyle(color: mainBlue)));
          // } else
            if (e[0] == '@') {
            return GestureDetector(onLongPress: (){
              copyText(text);
            },
                onTap: () {
                  onTapTag(e);
                },
                child: Text(e, style: TextStyle(color: mainBlue)));
          } else if (e.startsWith('http')) {
            return GestureDetector(
                onLongPress: (){
                  copyText(text);
                },
                onTap: () {
                  openUrl(e);
                },
                child: Text(e, style: TextStyle(color: mainBlue)));
          } else {
            return GestureDetector(
                onLongPress: (){
                  copyText(text);
                },
                child: Text(e, style: TextStyle(color: black)));
          }
        } else {
          return Text('', style: TextStyle(color: black));
        }
      }).toList(),
    ),
  );
  // return RichText(
  //   text: TextSpan(
  //     children: [TextSpan(text: split.first, style: TextStyle(color: black))]
  //       ..addAll(hashtags
  //           .map((text) => text.contains("#")
  //           ? TextSpan(text: text, style: TextStyle(color: mainBlue),
  //
  //         onEnter: (PointerEnterEvent e){
  //             print('asdasd');
  //         }
  //       )
  //           : TextSpan(text: text, style: TextStyle(color: black)))
  //           .toList()),
  //   ),
  // );
}
