import 'package:flutter/material.dart';
import 'package:shooting_app/classes/dataTypes.dart';
import 'package:shooting_app/classes/funcs/azure_translation.dart';
import 'package:shooting_app/classes/funcs/detect_lang.dart';
import 'package:shooting_app/classes/states/main_state.dart';
import 'package:shooting_app/pages/shoot/edit_comment.dart';
import 'package:shooting_app/pages/shoot/edit_reply.dart';
import 'package:shooting_app/pages/shoot/edit_shoot.dart';

import '../classes/functions.dart';
import '../classes/models.dart';
import '../classes/states/theme_state.dart';
import '../main.dart';
import 'report_sheet.dart';
import 'package:provider/provider.dart';

class MyBottomSheet extends StatefulWidget {
  const MyBottomSheet(this.post, {Key? key}) : super(key: key);
  final DataPost post;

  @override
  State<MyBottomSheet> createState() => _MyBottomSheetState();
}

class _MyBottomSheetState extends State<MyBottomSheet> {
  bool loading = false;
  Future<String?> translate(context) async {
    setState(() {
      loading = true;
    });
    String text = widget.post.details ?? '';
    if (text == '') {
      setState(() {
        loading = false;
      });
      return null;
    }
    String? start = await detectlang(text: text);
    if (start != null) {
      ThemeState state = Provider.of<ThemeState>(context,listen: false);
      String? out = await azureTranslation(
          text: text, start: start, end: state.lang.local.languageCode);
      print('out $out');
      return out;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Material(
          borderRadius:
              BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
          color: context.watch<ThemeState>().isDarkMode
              ? Color.fromRGBO(20, 20, 20, 1)
              : MyThemes.lightTheme.scaffoldBackgroundColor,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: doubleHeight(4)),
              SizedBox(
                  width: double.maxFinite,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: doubleWidth(4)),
                    child: OutlinedButton(
                      style: ButtonStyle(
                          side: MaterialStateProperty.all(BorderSide(
                              color: getIt<ThemeState>().isDarkMode ? mainColorDark : mainBlue)),
                          padding: MaterialStateProperty.all(
                              EdgeInsets.symmetric(vertical: doubleHeight(2.5)))),
                      child: loading ? CircularProgressIndicator() : Text(AppLocalizations.of(context)!.translate),
                      onPressed: () async {
                        String? back = await translate(context);
                        if (back != null) {
                          Go.pop(context, back);
                        }
                      },
                    ),
                  )),
              SizedBox(height: doubleHeight(1)),
              SizedBox(
                  width: double.maxFinite,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: doubleWidth(4)),
                    child: OutlinedButton(
                      style: ButtonStyle(
                          side: MaterialStateProperty.all(BorderSide(
                              color: getIt<ThemeState>().isDarkMode ? mainColorDark : mainBlue)),
                          padding: MaterialStateProperty.all(
                              EdgeInsets.symmetric(vertical: doubleHeight(2.5)))),
                      child: Text(AppLocalizations.of(context)!.copylink),
                      onPressed: () {
                        copyText('https://footballbuzz.co?shot=${widget.post.id}', context);
                      },
                    ),
                  )),
              SizedBox(height: doubleHeight(1)),
              SizedBox(
                  width: double.maxFinite,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: doubleWidth(4)),
                    child: OutlinedButton(
                      style: ButtonStyle(
                          side: MaterialStateProperty.all(BorderSide(
                              color: getIt<ThemeState>().isDarkMode ? mainColorDark : mainBlue)),
                          padding: MaterialStateProperty.all(
                              EdgeInsets.symmetric(vertical: doubleHeight(2.5)))),
                      child: Text(
                        AppLocalizations.of(context)!.share,
                        // 'Share...',
                      ),
                      onPressed: () {
                        sharePost(context, 'https://footballbuzz.co?shot=${widget.post.id}');
                      },
                    ),
                  )),
              SizedBox(height: doubleHeight(1)),
              if (widget.post.person != null &&
                  widget.post.person!.userName == getIt<MainState>().userName)
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                        width: double.maxFinite,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: doubleWidth(4)),
                          child: OutlinedButton(
                            style: ButtonStyle(
                                side: MaterialStateProperty.all(BorderSide(
                                    color:
                                        getIt<ThemeState>().isDarkMode ? mainColorDark : mainBlue)),
                                padding: MaterialStateProperty.all(
                                    EdgeInsets.symmetric(vertical: doubleHeight(2.5)))),
                            child: Text(
                              // 'Edit',
                              AppLocalizations.of(context)!.edit,
                              style: TextStyle(color: mainBlue),
                            ),
                            onPressed: () async {
                              DataPost? back = await Go.pushSlideAnimSheet(
                                  context,
                                  EditShoot(
                                    post: widget.post,
                                  ));
                              if (back != null) {
                                Go.pop(context, back);
                              }
                            },
                          ),
                        )),
                    SizedBox(height: doubleHeight(1)),
                  ],
                ),
              SizedBox(
                  width: double.maxFinite,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: doubleWidth(4)),
                    child: OutlinedButton(
                      style: ButtonStyle(
                          side: MaterialStateProperty.all(BorderSide(color: Colors.red)),
                          padding: MaterialStateProperty.all(
                              EdgeInsets.symmetric(vertical: doubleHeight(2.5)))),
                      child: Text(
                        AppLocalizations.of(context)!.report,
                        // 'Report',
                        style: TextStyle(color: Colors.red),
                      ),
                      onPressed: () {
                        Go.pushSlideAnimSheet(context, ReportSheet(post: widget.post));
                        // Go.pop(context);
                      },
                    ),
                  )),
              SizedBox(height: doubleHeight(1)),
              SizedBox(
                  width: double.maxFinite,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: doubleWidth(4)),
                    child: OutlinedButton(
                      style: ButtonStyle(
                          side: MaterialStateProperty.all(BorderSide(
                              color: getIt<ThemeState>().isDarkMode ? mainColorDark : mainBlue)),
                          padding: MaterialStateProperty.all(
                              EdgeInsets.symmetric(vertical: doubleHeight(2.5)))),
                      child: Text(AppLocalizations.of(context)!.cancel
                          // 'Cancel',
                          // style: TextStyle(color: mainBlue),
                          ),
                      onPressed: () {
                        Go.pop(context);
                      },
                    ),
                  )),
              SizedBox(height: doubleHeight(4)),
            ],
          ),
        ),
      ),
    );
  }
}

class MyBottomSheetComment extends StatefulWidget {
  const MyBottomSheetComment(this.comment, {Key? key}) : super(key: key);
  final DataPostComment comment;

  @override
  State<MyBottomSheetComment> createState() => _MyBottomSheetCommentState();
}

class _MyBottomSheetCommentState extends State<MyBottomSheetComment> {
  bool loading = false;
  Future<String?> translate(context) async {
    setState(() {
      loading = true;
    });
    String text = widget.comment.comment ?? '';
    if (text == '') {
      setState(() {
        loading = false;
      });
      return null;
    }
    String? start = await detectlang(text: text);
    if (start != null) {
      ThemeState state = Provider.of<ThemeState>(context,listen: false);
      String? out = await azureTranslation(
          text: text, start: start, end: state.lang.local.languageCode);
      print('out $out');
      return out;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Material(
          borderRadius:
              BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
          color: context.watch<ThemeState>().isDarkMode
              ? Color.fromRGBO(20, 20, 20, 1)
              : MyThemes.lightTheme.scaffoldBackgroundColor,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: doubleHeight(4)),
              SizedBox(
                  width: double.maxFinite,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: doubleWidth(4)),
                    child: OutlinedButton(
                      style: ButtonStyle(
                          side: MaterialStateProperty.all(BorderSide(
                              color: getIt<ThemeState>().isDarkMode ? mainColorDark : mainBlue)),
                          padding: MaterialStateProperty.all(
                              EdgeInsets.symmetric(vertical: doubleHeight(2.5)))),
                      child: loading ? CircularProgressIndicator() : Text(AppLocalizations.of(context)!.translate),
                      onPressed: () async {
                        String? back = await translate(context);
                        if (back != null) {
                          Go.pop(context, back);
                        }
                      },
                    ),
                  )),
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
                      child: Text(
                        AppLocalizations.of(context)!.copylink,
                        // 'Copy Link',
                        style: TextStyle(color: mainBlue),
                      ),
                      onPressed: () {
                        copyText('https://footballbuzz.co?shot=${widget.comment.postId}', context);
                      },
                    ),
                  )),
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
                      child: Text(
                        AppLocalizations.of(context)!.share,
                        // 'Share...',
                        style: TextStyle(color: mainBlue),
                      ),
                      onPressed: () {
                        sharePost(context, 'https://footballbuzz.co?shot=${widget.comment.postId}');
                      },
                    ),
                  )),
              SizedBox(height: doubleHeight(1)),
              if (widget.comment.personalInformationId == getIt<MainState>().userId)
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                        width: double.maxFinite,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: doubleWidth(4)),
                          child: OutlinedButton(
                            style: ButtonStyle(
                                side: MaterialStateProperty.all(BorderSide(color: mainBlue)),
                                padding: MaterialStateProperty.all(
                                    EdgeInsets.symmetric(vertical: doubleHeight(2.5)))),
                            child: Text(
                              AppLocalizations.of(context)!.edit,
                              // 'Edit',
                              style: TextStyle(color: mainBlue),
                            ),
                            onPressed: () async {
                              DataPostComment? back = await Go.pushSlideAnimSheet(
                                  context,
                                  EditComment(
                                    comment: widget.comment,
                                  ));
                              if (back != null) {
                                Go.pop(context, back);
                              }
                            },
                          ),
                        )),
                    SizedBox(height: doubleHeight(1)),
                  ],
                ),
              SizedBox(
                  width: double.maxFinite,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: doubleWidth(4)),
                    child: OutlinedButton(
                      style: ButtonStyle(
                          side: MaterialStateProperty.all(BorderSide(color: Colors.red)),
                          padding: MaterialStateProperty.all(
                              EdgeInsets.symmetric(vertical: doubleHeight(2.5)))),
                      child: Text(
                        AppLocalizations.of(context)!.report,
                        style: TextStyle(color: Colors.red),
                      ),
                      onPressed: () {
                        Go.pushSlideAnimSheet(context, ReportSheet(comment: widget.comment));
                        // Go.pop(context);
                      },
                    ),
                  )),
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
                      child: Text(
                        AppLocalizations.of(context)!.cancel,
                        style: TextStyle(color: mainBlue),
                      ),
                      onPressed: () {
                        Go.pop(context);
                      },
                    ),
                  )),
              SizedBox(height: doubleHeight(4)),
            ],
          ),
        ),
      ),
    );
  }
}

class MyBottomSheetReply extends StatefulWidget {
  final String shotId;
  const MyBottomSheetReply(this.reply, this.shotId, {Key? key}) : super(key: key);
  final DataCommentReply reply;

  @override
  State<MyBottomSheetReply> createState() => _MyBottomSheetReplyState();
}

class _MyBottomSheetReplyState extends State<MyBottomSheetReply> {
  bool loading = false;
  Future<String?> translate(context) async {
    setState(() {
      loading = true;
    });
    String text = widget.reply.replyDetail ?? '';
    if (text == '') {
      setState(() {
        loading = false;
      });
      return null;
    }
    String? start = await detectlang(text: text);
    if (start != null) {
      ThemeState state = Provider.of<ThemeState>(context,listen: false);
      String? out = await azureTranslation(
          text: text, start: start, end: state.lang.local.languageCode);
      print('out $out');
      return out;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Material(
          borderRadius:
              BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
          color: context.watch<ThemeState>().isDarkMode
              ? Color.fromRGBO(20, 20, 20, 1)
              : MyThemes.lightTheme.scaffoldBackgroundColor,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: doubleHeight(4)),
              SizedBox(
                  width: double.maxFinite,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: doubleWidth(4)),
                    child: OutlinedButton(
                      style: ButtonStyle(
                          side: MaterialStateProperty.all(BorderSide(
                              color: getIt<ThemeState>().isDarkMode ? mainColorDark : mainBlue)),
                          padding: MaterialStateProperty.all(
                              EdgeInsets.symmetric(vertical: doubleHeight(2.5)))),
                      child: loading ? CircularProgressIndicator() : Text(AppLocalizations.of(context)!.translate),
                      onPressed: () async {
                        String? back = await translate(context);
                        if (back != null) {
                          Go.pop(context, back);
                        }
                      },
                    ),
                  )),
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
                      child: Text(
                        AppLocalizations.of(context)!.copylink,
                        style: TextStyle(color: mainBlue),
                      ),
                      onPressed: () {
                        copyText('https://footballbuzz.co?shot=${widget.shotId}', context);
                      },
                    ),
                  )),
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
                      child: Text(
                        AppLocalizations.of(context)!.share,
                        style: TextStyle(color: mainBlue),
                      ),
                      onPressed: () {
                        sharePost(context, 'https://footballbuzz.co?shot=${widget.shotId}');
                      },
                    ),
                  )),
              SizedBox(height: doubleHeight(1)),
              if (widget.reply.personalInformationId == getIt<MainState>().userId)
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                        width: double.maxFinite,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: doubleWidth(4)),
                          child: OutlinedButton(
                            style: ButtonStyle(
                                side: MaterialStateProperty.all(BorderSide(color: mainBlue)),
                                padding: MaterialStateProperty.all(
                                    EdgeInsets.symmetric(vertical: doubleHeight(2.5)))),
                            child: Text(
                              AppLocalizations.of(context)!.edit,
                              style: TextStyle(color: mainBlue),
                            ),
                            onPressed: () async {
                              DataCommentReply? back = await Go.pushSlideAnimSheet(
                                  context,
                                  EditReply(
                                    reply: widget.reply,
                                  ));
                              if (back != null) {
                                Go.pop(context, back);
                              }
                            },
                          ),
                        )),
                    SizedBox(height: doubleHeight(1)),
                  ],
                ),
              SizedBox(
                  width: double.maxFinite,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: doubleWidth(4)),
                    child: OutlinedButton(
                      style: ButtonStyle(
                          side: MaterialStateProperty.all(BorderSide(color: Colors.red)),
                          padding: MaterialStateProperty.all(
                              EdgeInsets.symmetric(vertical: doubleHeight(2.5)))),
                      child: Text(
                        AppLocalizations.of(context)!.report,
                        style: TextStyle(color: Colors.red),
                      ),
                      onPressed: () {
                        Go.pushSlideAnimSheet(
                            context,
                            ReportSheet(
                              reply: widget.reply,
                            ));
                        // Go.pop(context);
                      },
                    ),
                  )),
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
                      child: Text(
                        AppLocalizations.of(context)!.cancel,
                        style: TextStyle(color: mainBlue),
                      ),
                      onPressed: () {
                        Go.pop(context);
                      },
                    ),
                  )),
              SizedBox(height: doubleHeight(4)),
            ],
          ),
        ),
      ),
    );
  }
}
