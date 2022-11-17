
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shooting_app/classes/services/my_service.dart';

import '../../main.dart';
import '../dataTypes.dart';

class ThemeState extends ChangeNotifier{

  ThemeState(){
    init();
  }
  init()async{
    bool? temp = await getBool('isDarkMode');
    if(temp!=null){
      themeMode=temp?ThemeMode.dark:ThemeMode.light;
    }
  }
  ThemeMode themeMode = ThemeMode.light;

  bool get isDarkMode => themeMode == ThemeMode.dark;
  notify()=>notifyListeners();
  void toggleTheme(){
    themeMode = themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    setBool('isDarkMode', themeMode==ThemeMode.dark);
    notifyListeners();
  }

}

class ThemeStateProvider extends StatelessWidget {
  final Widget child;
  const ThemeStateProvider({Key? key, required this.child,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // ThemeState state = getIt<ThemeState>()..themeMode=
    //     brightness==Brightness.dark?ThemeMode.dark:ThemeMode.light;
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
      titleLarge: TextStyle(color: Colors.white, fontSize: 22,fontWeight: FontWeight.bold),
      bodySmall: TextStyle(color: Colors.white, fontSize: 15),
      labelSmall: TextStyle(color: Colors.white54, fontSize: 13),
      titleSmall: TextStyle(color: Colors.white, fontSize: 12),
      titleMedium: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
      bodyMedium: TextStyle(color: Colors.white),
    ),
    popupMenuTheme: PopupMenuThemeData(
      color: Colors.grey.shade800
    ),
    listTileTheme: ListTileThemeData(
      textColor: white,
    ),
    unselectedWidgetColor: Colors.white70,
    primaryColorLight: Colors.black,
    scaffoldBackgroundColor: myDarkScaffold,
    primaryColor: headerColor,//Color(0xFF1f1b24),
    secondaryHeaderColor: Colors.white,
    iconTheme: const IconThemeData(color: Colors.black,opacity: 0.8),

      // scaffoldBackgroundColor: Color.fromRGBO(244, 244, 244, 1),
      // primaryColor: mainBlue,
      // primarySwatch: Color(0xFF1f1b24),
      primarySwatch: mainColorDark,
      appBarTheme:
        AppBarTheme(
          elevation: 0,
          centerTitle: true,
          // backgroundColor: Color(0xFF1f1b24),
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 22,fontWeight: FontWeight.bold),
          actionsIconTheme: IconThemeData(color: white),
          iconTheme: IconThemeData(color: white),
          color: headerColor),



    // textSelectionTheme: const TextSelectionThemeData(
    //   cursorColor: Colors.red,
    //   selectionColor: Colors.green,
    //   selectionHandleColor: Colors.blue,
    // )
    // colorScheme: const ColorScheme.dark()
  );

  static final lightTheme = ThemeData(
    textTheme: TextTheme(
      titleLarge: TextStyle(color: Colors.black, fontSize: 22,fontWeight: FontWeight.bold),
      bodySmall: TextStyle(color: Colors.black, fontSize: 15),
      labelSmall: TextStyle(color: Colors.black38, fontSize: 13),
      titleSmall: TextStyle(color: Colors.black, fontSize: 12),
      titleMedium: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
      // bodyLarge: TextStyle(color: red),
      bodyMedium: TextStyle(color: Colors.black),
      // displayLarge: TextStyle(color: red),
      // displayMedium: TextStyle(color: red),
      // displaySmall: TextStyle(color: red),
      // headlineLarge: TextStyle(color: red),
      // headlineMedium: TextStyle(color: red),
      // headlineSmall: TextStyle(color: red),
      // labelLarge: TextStyle(color: red),
      // labelMedium: TextStyle(color: red),



      // subtitle1: TextStyle(color: red),
      // subtitle2: TextStyle(color: red),
      // bodyText1: TextStyle(color: red),
      // bodyText2: TextStyle(color: red),
      // button: TextStyle(color: red),
      // caption: TextStyle(color: red),
      // overline: TextStyle(color: red),
      // headline1: TextStyle(color: red),
      // headline2: TextStyle(color: red),
      // headline3: TextStyle(color: red),
      // headline4: TextStyle(color: red),
      // headline5: TextStyle(color: red),
      // headline6: TextStyle(color: red),





    ),
    listTileTheme: ListTileThemeData(
      textColor: black,
    ),
    unselectedWidgetColor: Colors.black,
    primaryColorLight: Colors.white,
    // scaffoldBackgroundColor: Colors.white,
    // primaryColor: Colors.blueAccent,
    secondaryHeaderColor: Colors.black,
    iconTheme: const IconThemeData(color: Colors.white , opacity: 0.8),
//todo
    scaffoldBackgroundColor: Color.fromRGBO(244, 244, 244, 1),
    primaryColor: mainBlue,
    primarySwatch: mainColor,
      appBarTheme:
      AppBarTheme(
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 22,fontWeight: FontWeight.bold),
          actionsIconTheme: IconThemeData(color: white),
          iconTheme: IconThemeData(color: white),
          color: mainBlue),

    // colorScheme: const ColorScheme.light()
  );

}