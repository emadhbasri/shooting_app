import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shooting_app/classes/states/main_state.dart';

import '../../../classes/dataTypes.dart';
import '../../../classes/functions.dart';
import '../../../ui_items/shots/post_from_shot.dart';

class Stadia extends StatefulWidget {
  const Stadia({Key? key}) : super(key: key);
  @override
  _StadiaState createState() => _StadiaState();
}

class _StadiaState extends State<Stadia> {
  @override
  void initState() {
    super.initState();
    print('Stadia init');
    MainState state = Provider.of<MainState>(context, listen: false);
    if (state.stadiaShots.isEmpty) state.getStadia();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MainState>(
      builder: (context, state, child) {
        return Column(
          children: [
            SizedBox(height: doubleHeight(2)),
            SizedBox(
              width: double.maxFinite,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: doubleWidth(4)),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    textDirection: TextDirection.ltr,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: state.tags
                        .map((e) => Row(children: [
                              if ((state.selectedTag == null && e == 'Global') ||
                                  state.selectedTag != null &&
                                      state.selectedTag == e)
                                Container(
                                    decoration: BoxDecoration(
                                      color: mainGreen1.withOpacity(.5),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        vertical: doubleHeight(.7),
                                        horizontal: doubleWidth(2)),
                                    child: Text(
                                      '#$e',
                                      style: TextStyle(
                                        fontSize: 17,
                                        color: mainBlue,
                                        fontWeight: FontWeight.bold,
                                        // fontSize:
                                      ),
                                    ))
                              else
                                GestureDetector(
                                    onTap: () {
                                      if (e == 'Global') {
                                        state.selectedTag = null;
                                      } else {
                                        state.selectedTag = e;
                                      }
                                      state.notify();
                                      state.getStadia();
                                    },
                                    child: Text(
                                      '#$e',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    )),
                              if (e != state.tags.last)
                                SizedBox(width: doubleWidth(3))
                            ]))
                        .toList(),
                  ),
                ),
              ),
            ),
            SizedBox(height: doubleHeight(2)),
            Expanded(
              child: state.loadingStadia
                  ? circle()
                  : RefreshIndicator(
                      onRefresh: () async {
                        await state.getStadia();
                      },
                      child: state.stadiaShots.isEmpty
                          ? ListView(
                              physics: AlwaysScrollableScrollPhysics(),
                              padding: EdgeInsets.symmetric(
                                  vertical: doubleHeight(1)),
                              children: [
                                SizedBox(
                                    height: doubleHeight(70),
                                    width: double.maxFinite,
                                    child: Center(child: Text('No Shots'))),
                              ],
                            )
                          : ListView(
                              controller: state.listController,
                              physics: AlwaysScrollableScrollPhysics(),
                              children: state.stadiaShots
                                  .map((e) => PostFromShot(
                                        delete: () {
                                          state.stadiaShots.remove(e);
                                          state.notify();
                                        },
                                        key: UniqueKey(),
                                        post: e,
                                        onTapTag: gogo,
                                      ))
                                  .toList(),
                            )),
            ),
          ],
        );
      },
    );
  }
}
