import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shooting_app/ui_items/shots/post_from_shot.dart';

import '../../classes/functions.dart';
import '../../classes/models.dart';
import '../../classes/states/profile_state.dart';

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
    final ProfileState state =
    Provider.of<ProfileState>(context, listen: false);

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
    // final ProfileState state =
    //     Provider.of<ProfileState>(context, listen: false);
    List<DataPost> posts=context.watch<ProfileState>().profilePosts;
    if(context.read<ProfileState>().loadingProfilePost){
      return circle();
    }
    if(posts.isEmpty) {
        return RefreshIndicator(
          onRefresh: ()async{
            await context.read<ProfileState>().getProfileShots(force: true);
          },
          child: ListView(
            physics: AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(vertical: doubleHeight(1)),
            children: [
              SizedBox(
                  height: doubleHeight(40),
                  width: double.maxFinite,
                  child: Center(child: Text('No Shots'))),
            ],
          ),
        );
      }
    return RefreshIndicator(
      onRefresh: ()async{
        await context.read<ProfileState>().getProfileShots(force: true);
      },
      child: ListView(
        addAutomaticKeepAlives: true,
        controller: _listController,
        physics: BouncingScrollPhysics(),
        children: [
          ...posts.toList()
              .map((e) => PostFromShotProfile(
            post: e,
            onTapTag: gogo,
            canDelete: false,
            delete: (){},
            person: context.read<ProfileState>().personalInformation!,
          ))
              .toList(),
          if (context.watch<ProfileState>().profilePostsHasNext)
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
