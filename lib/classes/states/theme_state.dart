// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shooting_app/classes/functions.dart';

import 'package:shooting_app/classes/services/my_service.dart';

import '../../main.dart';
import '../dataTypes.dart';

class LocalCountry {
  final Locale local;
  final String name;
  final String img;
  LocalCountry({
    required this.local,
    required this.name,
    required this.img,
  });
}

class ChangeLang extends StatelessWidget {
  const ChangeLang({Key? key, this.samll = false}) : super(key: key);
  final bool samll;
  @override
  Widget build(BuildContext context) {
    if (samll) {
      return Align(
        alignment: Alignment.centerRight,
        child: DropdownButton<LocalCountry>(
          alignment: Alignment.centerRight,
          items: ThemeState.localCounties
              .map((e) => DropdownMenuItem<LocalCountry>(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: doubleWidth(5),
                          height: doubleWidth(5),
                          child: SvgPicture.network(e.img),
                        ),
                        SizedBox(width: doubleWidth(2)),
                        Text(
                          '${e.local.languageCode} ',
                          style: TextStyle(color: white),
                        ),
                      ],
                    ),
                    value: e,
                  ))
              .toList(),
          onChanged: (e) {
            if (e != null) {
              context.read<ThemeState>().changeLang(e);
            }
          },
          dropdownColor: Colors.grey.shade800,
          underline: non,
          isDense: true,
          iconSize: 30,
          borderRadius: BorderRadius.circular(10),
          value: context.watch<ThemeState>().lang,
          isExpanded: false,
          icon: Icon(Icons.keyboard_arrow_down),
        ),
      );
    }
    return ClipRRect(
      child: Container(
        width: max,
        height: doubleHeight(7),
        padding: EdgeInsets.symmetric(horizontal: doubleWidth(5)),
        color: Color.fromRGBO(216, 216, 216, 1),
        child: Center(
          child: DropdownButton<LocalCountry>(
            items: ThemeState.localCounties
                .map((e) => DropdownMenuItem<LocalCountry>(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: doubleWidth(5),
                            height: doubleWidth(5),
                            child: SvgPicture.network(e.img),
                          ),
                          SizedBox(width: doubleWidth(2)),
                          Text(
                            '${e.name} ',
                            style: TextStyle(color: black),
                          ),
                        ],
                      ),
                      value: e,
                    ))
                .toList(),
            onChanged: (e) {
              if (e != null) {
                context.read<ThemeState>().changeLang(e);
              }
            },
            underline: non,
            isDense: true,
            iconSize: 30,
            borderRadius: BorderRadius.circular(10),
            value: context.watch<ThemeState>().lang,
            isExpanded: true,
            icon: Icon(Icons.keyboard_arrow_down),
          ),
        ),
      ),
      borderRadius: BorderRadius.circular(10),
    );
  }
}

class ThemeState extends ChangeNotifier {
  static List<LocalCountry> localCounties = [
    LocalCountry(
        local: Locale('en'),
        name: 'English',
        img: 'https://media-2.api-sports.io/flags/gb.svg'), //*

    LocalCountry(
        local: Locale('ar'), name: 'Arabic', img: 'https://media-3.api-sports.io/flags/sa.svg'), //*
    LocalCountry(
        local: Locale('bg'),
        name: 'Bulgarian',
        img: 'https://media-3.api-sports.io/flags/bg.svg'), //*
    LocalCountry(
        local: Locale('cs'), name: 'Czech', img: 'https://media-3.api-sports.io/flags/cz.svg'), //?
    LocalCountry(
        local: Locale('da'), name: 'Danish', img: 'https://media-3.api-sports.io/flags/dk.svg'), //?
    LocalCountry(
        local: Locale('de'), name: 'German', img: 'https://media-3.api-sports.io/flags/de.svg'), //*
    LocalCountry(
        local: Locale('el'), name: 'Greek', img: 'https://upload.wikimedia.org/wikipedia/commons/5/5c/Flag_of_Greece.svg'),
    LocalCountry(
        local: Locale('es'),
        name: 'Spanish',
        img: 'https://media-3.api-sports.io/flags/es.svg'), //*
    LocalCountry(
        local: Locale('fa'),
        name: 'Persian',
        img: 'https://media-3.api-sports.io/flags/ir.svg'), //*
    LocalCountry(
        local: Locale('fr'), name: 'French', img: 'https://media-3.api-sports.io/flags/fr.svg'), //*
    LocalCountry(
        local: Locale('hi'), name: 'Hindi', img: 'https://media-3.api-sports.io/flags/in.svg'), //*
    LocalCountry(
        local: Locale('it'),
        name: 'Italian',
        img: 'https://media-3.api-sports.io/flags/it.svg'), //*
    LocalCountry(
        local: Locale('ja'), name: 'Japanese', img: 'https://media-3.api-sports.io/flags/jp.svg'),
    LocalCountry(
        local: Locale('nl'), name: 'Dutch', img: 'https://media-3.api-sports.io/flags/nl.svg'),
    LocalCountry(
        local: Locale('no'), name: 'Norwegian', img: 'https://media-3.api-sports.io/flags/no.svg'),
    LocalCountry(
        local: Locale('pl'), name: 'Polish', img: 'https://media-3.api-sports.io/flags/pl.svg'),
    LocalCountry(
        local: Locale('pt'),
        name: 'Portuguese',
        img: 'https://media-3.api-sports.io/flags/pt.svg'), //*
    LocalCountry(
        local: Locale('ru'),
        name: 'Russian',
        img: 'https://media-3.api-sports.io/flags/ru.svg'), //*
    LocalCountry(
        local: Locale('sv'), name: 'Sweden', img: 'https://media-3.api-sports.io/flags/se.svg'),
    LocalCountry(
        local: Locale('sr'),
        name: 'Serbian',
        img: 'https://upload.wikimedia.org/wikipedia/commons/f/ff/Flag_of_Serbia.svg'
        // 'https://media-3.api-sports.io/flags/rs.svg'
        ),
    LocalCountry(
        local: Locale('tr'),
        name: 'Turkish',
        img: 'https://media-3.api-sports.io/flags/tr.svg'), //*
    LocalCountry(
        local: Locale('zh'), name: 'Chinese', img: 'https://media-3.api-sports.io/flags/cn.svg'),
  ];

  LocalCountry lang = localCounties.first;
  changeLang(LocalCountry local) {
    setString('lang', local.name);
    lang = local;
    notifyListeners();
  }

  ThemeState() {
    init();
  }
  init() async {
    String? lang = await getString('lang');
    if (lang != null) {
      this.lang = localCounties.singleWhere((element) => element.name == lang);
    }
    bool? temp = await getBool('isDarkMode');
    if (temp != null) {
      themeMode = temp ? ThemeMode.dark : ThemeMode.light;
    }
  }

  ThemeMode themeMode = ThemeMode.light;

  bool get isDarkMode => themeMode == ThemeMode.dark;
  notify() => notifyListeners();
  void toggleTheme() {
    themeMode = themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    setBool('isDarkMode', themeMode == ThemeMode.dark);
    notifyListeners();
  }
}

class ThemeStateProvider extends StatelessWidget {
  final Widget child;
  const ThemeStateProvider({
    Key? key,
    required this.child,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListenableProvider<ThemeState>(
      create: (context) => getIt<ThemeState>(),
      child: child,
    );
  }
}

const headerColor = Color.fromRGBO(34, 44, 51, 1);

class MyThemes {
  static final darkTheme = ThemeData(
    textTheme: TextTheme(
      titleLarge: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
      bodySmall: TextStyle(color: Colors.white, fontSize: 15),
      labelSmall: TextStyle(color: Colors.white54, fontSize: 13),
      titleSmall: TextStyle(color: Colors.white, fontSize: 12),
      titleMedium: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      bodyMedium: TextStyle(color: Colors.white),
    ),
    popupMenuTheme: PopupMenuThemeData(color: Colors.grey.shade800),
    listTileTheme: ListTileThemeData(
      textColor: white,
    ),
    unselectedWidgetColor: Colors.white70,
    primaryColorLight: Colors.black,
    scaffoldBackgroundColor: myDarkScaffold,
    primaryColor: headerColor,
    secondaryHeaderColor: Colors.white,
    iconTheme: const IconThemeData(color: Colors.black, opacity: 0.8),
    primarySwatch: mainColorDark,
    appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
        actionsIconTheme: IconThemeData(color: white),
        iconTheme: IconThemeData(color: white),
        color: headerColor),
  );

  static final lightTheme = ThemeData(
    textTheme: TextTheme(
      titleLarge: TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold),
      bodySmall: TextStyle(color: Colors.black, fontSize: 15),
      labelSmall: TextStyle(color: Colors.black38, fontSize: 13),
      titleSmall: TextStyle(color: Colors.black, fontSize: 12),
      titleMedium: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      bodyMedium: TextStyle(color: Colors.black),
    ),
    listTileTheme: ListTileThemeData(
      textColor: black,
    ),
    unselectedWidgetColor: Colors.black,
    primaryColorLight: Colors.white,
    // scaffoldBackgroundColor: Colors.white,
    // primaryColor: Colors.blueAccent,
    secondaryHeaderColor: Colors.black,
    iconTheme: const IconThemeData(color: Colors.white, opacity: 0.8),
//todo
    scaffoldBackgroundColor: Color.fromRGBO(244, 244, 244, 1),
    primaryColor: mainBlue,
    primarySwatch: mainColor,
    appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
        actionsIconTheme: IconThemeData(color: white),
        iconTheme: IconThemeData(color: white),
        color: mainBlue),

    // colorScheme: const ColorScheme.light()
  );
}
