import 'dart:convert';
import 'package:flutter/material.dart';

class LinkViewVertical extends StatelessWidget {
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

  const LinkViewVertical({
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

  double computeTitleFontSize(double height) {
    var size = height * 0.13;
    if (size > 15) {
      size = 15;
    }
    return size;
  }

  int computeTitleLines(layoutHeight, layoutWidth) {
    return layoutHeight - layoutWidth < 50 ? 1 : 2;
  }

  int? computeBodyLines(layoutHeight) {
    return layoutHeight ~/ 60 == 0 ? 1 : layoutHeight ~/ 60;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      var layoutWidth = constraints.biggest.width;
      var layoutHeight = constraints.biggest.height;

      var titleTS_ = titleTextStyle ??
          TextStyle(
            fontSize: computeTitleFontSize(layoutHeight),
            color: Colors.black,
            fontWeight: FontWeight.bold,
          );
      var bodyTS_ = bodyTextStyle ??
          TextStyle(
            fontSize: computeTitleFontSize(layoutHeight) - 1,
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
          child: Column(
            children: <Widget>[
              showMultiMedia!
                  ? Expanded(
                      flex: 2,
                      child: img_ == null
                          ? Container(color: bgColor ?? Colors.grey)
                          : Container(
                              padding: const EdgeInsets.only(bottom: 15),
                              decoration: BoxDecoration(
                                borderRadius: radius == 0
                                    ? BorderRadius.zero
                                    : const BorderRadius.only(
                                        topLeft: Radius.circular(12),
                                        topRight: Radius.circular(12),
                                      ),
                                image: DecorationImage(
                                  image: img_,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                    )
                  : const SizedBox(height: 5),

              _buildTitleContainer(
                  titleTS_, computeTitleLines(layoutHeight, layoutWidth)),
              _buildBodyContainer(bodyTS_, computeBodyLines(layoutHeight)),
            ],
          ));
    });
  }

  Widget _buildTitleContainer(TextStyle titleTS_, int? maxLines_) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 5, 5, 1),
      child: Container(
        alignment: const Alignment(-1.0, -1.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              title,
              style: titleTS_,
              // overflow: TextOverflow.ellipsis,
              // maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBodyContainer(TextStyle bodyTS_, int? maxLines_) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 5, 5, 10),
      child: Container(
        alignment: const Alignment(-1.0, -1.0),
        child: Text(
          description,
          style: bodyTS_,
          overflow: bodyTextOverflow ?? TextOverflow.ellipsis,
          maxLines: bodyMaxLines ?? maxLines_,
        ),
      ),
    );
  }
}
