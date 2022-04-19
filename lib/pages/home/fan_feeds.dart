import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shooting_app/classes/models.dart';
import 'package:shooting_app/classes/services/my_service.dart';
import 'package:shooting_app/classes/states/main_state.dart';
import '../../classes/functions.dart';
import '../../classes/services/shots_service.dart';
import '../../main.dart';
import '../../ui_items/shots/post_from_shot.dart';

class FanFeeds extends StatefulWidget {
  @override
  _FanFeedsState createState() => _FanFeedsState();
}

class _FanFeedsState extends State<FanFeeds> {
  late ScrollController _listController;

  @override
  void initState() {
    super.initState();
    print('FanFeeds init');
    MainState state = Provider.of(context, listen: false);
    if (state.allPosts.isEmpty) state.getFanFeed();

    _listController = ScrollController()
      ..addListener(() {
        if (state.allPosts.isNotEmpty) if (_listController.position.atEdge &&
            _listController.offset != 0.0) {
          debugPrint("state.dataSearchPage!.hasNext ${state.postsHasNext}");
          if (state.postsHasNext) {
            state.postsPageNumber++;
            state.getFanFeed(add: true);
          }
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MainState>(
      builder: (context, state, child) {
        if(state.loadingPost)return circle();
        return RefreshIndicator(
            onRefresh: () async {
              state.postsPageNumber = 1;
              state.postsHasNext = false;
              await state.getFanFeed();
            },
            child: state.allPosts.isEmpty?ListView(physics: AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(vertical: doubleHeight(1)),
              children: [
                SizedBox(
                    height: doubleHeight(70),
                    width: double.maxFinite,
                    child: Center(child: Text('no shot. 🙂'))),
              ],
            ):ListView(
              controller: _listController,
              physics: AlwaysScrollableScrollPhysics(),
              children: [
                ...state.allPosts
                    .map((e) => PostFromShot(
                  delete: (){
                    state.allPosts.remove(e);
                    state.notify();
                  },
                  key: UniqueKey(),
                          post: e,
                          onTapTag: gogo,
                        ))
                    .toList(),
                if (state.postsHasNext)
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: doubleHeight(1)),
                      CircularProgressIndicator(),
                      SizedBox(height: doubleHeight(1)),
                    ],
                  )
              ],
            ));
      },
    );
  }
}
