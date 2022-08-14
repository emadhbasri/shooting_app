import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../classes/states/theme_state.dart';

class ThemeSwitcher extends StatelessWidget {
  const ThemeSwitcher({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeState>(builder: (context, themeProvider, child) {
      var switchIcon = Icon(themeProvider.isDarkMode
        ? CupertinoIcons.moon_fill
        : CupertinoIcons.sun_max_fill);

    return IconButton(
        onPressed: () {
          themeProvider.toggleTheme();
        },
        icon: switchIcon);
    },);
    // final themeProvider = Provider.of<ThemeState>(context);
    
  }
}
