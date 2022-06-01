import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shooting_app/classes/dataTypes.dart';

import '../../../../classes/functions.dart';

class LinkViewHorizontal extends StatelessWidget {
  final String url;
  final String title;
  final String description;
  final String imageUri;
  final Function() onTap;
  final Function() onLongPress;
  final TextStyle? titleTextStyle;
  final TextStyle? bodyTextStyle;
  final bool? showMultiMedia;
  final TextOverflow? bodyTextOverflow;
  final int? bodyMaxLines;
  final double? radius;
  final Color? bgColor;

  const LinkViewHorizontal({
    Key? key,
    required this.url,
    required this.title,
    required this.description,
    required this.imageUri,
    required this.onTap,
    required this.onLongPress,
    this.titleTextStyle,
    this.bodyTextStyle,
    this.showMultiMedia,
    this.bodyTextOverflow,
    this.bodyMaxLines,
    this.bgColor,
    this.radius,
  }) : super(key: key);

  double computeTitleFontSize(double width) {
    var size = width * 0.13;
    if (size > 15) {
      size = 15;
    }
    return size;
  }

  int computeTitleLines(layoutHeight) {
    return layoutHeight >= 100 ? 2 : 1;
  }

  int computeBodyLines(layoutHeight) {
    var lines = 1;
    if (layoutHeight > 40) {
      lines += (layoutHeight - 40.0) ~/ 15.0 as int;
    }
    return lines;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        var layoutWidth = constraints.biggest.width;
        var layoutHeight = constraints.biggest.height;

        var titleFontSize_ = titleTextStyle ??
            TextStyle(
              fontSize: computeTitleFontSize(layoutWidth),
              color: Colors.black,
              fontWeight: FontWeight.bold,
            );
        var bodyFontSize_ = bodyTextStyle ??
            TextStyle(
              fontSize: computeTitleFontSize(layoutWidth) - 1,
              color: Colors.grey,
              fontWeight: FontWeight.w400,
            );

        ImageProvider? img_ = imageUri != '' ? NetworkImage(imageUri) : null;
        if (imageUri.startsWith('data:image')) {
          img_ = MemoryImage(
            base64Decode(imageUri.substring(imageUri.indexOf('base64') + 7)),
          );
        }

        return InkWell(
          onTap: () => onTap(),
          onLongPress: () => onLongPress(),
          child: Row(
            children: <Widget>[
              showMultiMedia!
                  ? img_ == null
                      ? AspectRatio(
                          aspectRatio: 1,
                          child: Container(color: bgColor ?? Colors.grey))
                      : AspectRatio(
                          aspectRatio: 1,
                          child: Container(
                            margin: const EdgeInsets.only(right: 5),
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: img_,
                                fit: BoxFit.fill,
                              ),
                              borderRadius: BorderRadius.circular(7),
                            ),
                            alignment: Alignment.centerLeft,
                            child: Container(
                              width: 10,
                              height: double.maxFinite,
                              decoration: BoxDecoration(
                                color: mainGreen,
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(7),
                                    topLeft: Radius.circular(7)),
                              ),
                            ),
                          ),
                        )
                  : const SizedBox(width: 5),
              Expanded(
                flex: 4,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 3).copyWith(left: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      _buildTitleContainer(
                          titleFontSize_, computeTitleLines(layoutHeight)),
                      _buildBodyContainer(
                          bodyFontSize_, computeBodyLines(layoutHeight)),
                      Row(
                        textDirection: TextDirection.ltr,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            Uri.parse(url).host,
                            style: titleFontSize_,
                          ),
                          SizedBox(width: doubleWidth(1)),
                          Icon(Icons.link)
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTitleContainer(TextStyle titleTS_, int? maxLines_) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 2, 3, 1),
      child: Column(
        children: <Widget>[
          Container(
            alignment: const Alignment(-1.0, -1.0),
            child: Text(
              title,
              style: titleTS_,
              overflow: TextOverflow.ellipsis,
              maxLines: maxLines_,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBodyContainer(TextStyle bodyTS_, int? maxLines_) {
    return Expanded(
      flex: 2,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 3, 5, 0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                alignment: const Alignment(-1.0, -1.0),
                child: Text(
                  description,
                  textAlign: TextAlign.left,
                  style: bodyTS_,
                  overflow: bodyTextOverflow ?? TextOverflow.ellipsis,
                  maxLines: bodyMaxLines ?? maxLines_,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
