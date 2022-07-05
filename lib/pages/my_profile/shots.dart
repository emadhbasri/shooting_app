import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shooting_app/classes/states/main_state.dart';
import 'package:shooting_app/ui_items/shots/post_from_shot.dart';

import '../../classes/functions.dart';
import '../../classes/models.dart';

class Shots extends StatefulWidget {
  const Shots({Key? key}) : super(key: key);

  @override
  _ShotsState createState() => _ShotsState();
}

class _ShotsState extends State<Shots> {
  late ScrollController _listController;

  @override
  void initState() {
    super.initState();
    final MainState state = Provider.of<MainState>(context, listen: false);

    _listController = ScrollController()
      ..addListener(() {
        if (state.profilePosts.isNotEmpty) {
          if (_listController.position.atEdge &&
              _listController.offset != 0.0) {
            if (state.profilePostsHasNext) {
              state.profilePostsPageNumber++;
              state.getProfileShots();
            }
          }
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    // final MainState state = Provider.of<MainState>(context, listen: false);
  List<DataPost> posts=context.watch<MainState>().profilePosts;
    if(context.read<MainState>().loadingProfilePost){
      return circle();
    }
      if(posts.isEmpty) {
        return RefreshIndicator(
          onRefresh: ()async{
            await context.read<MainState>().getProfileShots(force: true);
          },
          child: ListView(
            padding: EdgeInsets.symmetric(vertical: doubleHeight(1)),
            children: [
              SizedBox(
                  height: doubleHeight(40),
                  width: double.maxFinite,
                  child: Center(child: Text('No Shot. Try Shoot A Few Soon'))),
            ],
          ),
        );
      }
    return RefreshIndicator(
      onRefresh: ()async{
        await context.read<MainState>().getProfileShots(force: true);
      },
      child: ListView(
        addAutomaticKeepAlives: true,

        controller: _listController,
        physics: AlwaysScrollableScrollPhysics(),
          children: [
            ...posts.toList().map((e) =>
                PostFromShotProfile(
                  key: UniqueKey(),
                  post: e,onTapTag: gogo,
                  canDelete: true,
                  delete: () {
                    posts.remove(e);
                    context.read<MainState>().notify();
                  },
                  person: context.read<MainState>().personalInformation!,
                )
            ).toList(),
            if (context.watch<MainState>().profilePostsHasNext)
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: doubleHeight(1)),
                  CircularProgressIndicator(),
                  SizedBox(height: doubleHeight(1)),
                ],
              )
          ],
      ),
    );
  }
}
