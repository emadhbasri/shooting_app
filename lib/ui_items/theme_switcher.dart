import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../classes/states/theme_state.dart';

class ThemeSwitcher extends StatelessWidget {
  const ThemeSwitcher({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeState>(builder: (context, state, child) {
      // var switchIcon = Icon(state.isDarkMode
      //   ? CupertinoIcons.moon_fill
      //   : CupertinoIcons.sun_max_fill);

    return IconButton(
        onPressed: () {
          state.toggleTheme();
        },
        icon: SizedBox(
              width: 25,
              height: 25,
              child: Center(
                child: SvgPicture.asset(
                  'assets/icons/${state.isDarkMode?'darkMode':'default'}.svg',
                  width: 25,
                  height: 25,
                ),
              ))
        );
    },);
    // final themeProvider = Provider.of<ThemeState>(context);
    
  }
}
