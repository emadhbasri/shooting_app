import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shooting_app/classes/functions.dart';

import '../../classes/states/profile_state.dart';


class Media extends StatefulWidget {
  const Media({Key? key}) : super(key: key);

  @override
  _MediaState createState() => _MediaState();
}

class _MediaState extends State<Media> {
  @override
  Widget build(BuildContext context) {
    final ProfileState state = Provider.of<ProfileState>(context, listen: false);

    if(state.personalInformation!.posts.isEmpty)
      return ListView(
        padding: EdgeInsets.symmetric(vertical: doubleHeight(1)),
        children: [
          SizedBox(
              height: doubleHeight(40),
              width: double.maxFinite,
              child: Center(child: Text('no media. 🙂'))),
        ],
      );
    List<String> first=[];
    List<String> second=[];
    for(int j=0;j<state.personalInformation!.posts.length;j++){
      if(j%2==0)
        first.addAll(state.personalInformation!.posts[j].mediaTypes.map((e) => e.media));
      else
        second.addAll(state.personalInformation!.posts[j].mediaTypes.map((e) => e.media));
    }

    return Container(
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(
            horizontal: doubleWidth(4),
            vertical: doubleHeight(2)
        ),
        child: Row(
          children: [
            Expanded(child: Column(
              children: first.map((e) =>
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: double.maxFinite,
                        child: imageNetwork(e,fit: BoxFit.fitWidth,),
                      ),
                      if(e!=first.last)
                        SizedBox(height: doubleHeight(1)),
                    ],
                  )
              ).toList(),
            )),
            SizedBox(width: doubleWidth(2)),
            Expanded(child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: second.map((e) =>
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: double.maxFinite,
                        child: imageNetwork(e,fit: BoxFit.fitWidth,
                        ),
                      ),
                      if(e!=second.last)
                        SizedBox(height: doubleHeight(1)),
                    ],
                  )
              ).toList(),
            )),
          ],
        ),
      ),
    );
  }
}
