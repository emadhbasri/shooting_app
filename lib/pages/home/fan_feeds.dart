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

class _FanFeedsState extends State<FanFeeds> with SingleTickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
    print('FanFeeds init');
    MainState state = Provider.of(context,listen: false);
    state.getFanFeed();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MainState>(
      builder: (context, state, child) {
        return RefreshIndicator(
          onRefresh: ()async{
            await state.getFanFeed();
          },
          child: ListView.builder(
            itemCount: state.allPosts.length,
            itemBuilder: (context, index) => PostFromShot(
              post: state.allPosts[index],
              onTapTag: gogo,
            ),
          ),
        );
      },
    );
  }
}

