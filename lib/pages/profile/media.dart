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
    return Container(
      color: Color.fromRGBO(245, 244, 248, 1),
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(
          horizontal: doubleWidth(4),
          vertical: doubleHeight(2)
        ),
        child: Row(
          children: [
            Expanded(child: Column(
              children: state.medias.where((element) =>
              state.medias.indexOf(element)%2==0).map((e) =>
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: double.maxFinite,
                        child: Image.asset(e,fit: BoxFit.fitWidth,),
                      ),
                      if(e!=state.medias.where((element) =>
                      state.medias.indexOf(element)%2==1).last)
                        SizedBox(height: doubleHeight(1)),
                    ],
                  )
              ).toList(),
            )),
            SizedBox(width: doubleWidth(2)),
            Expanded(child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: state.medias.where((element) =>
              state.medias.indexOf(element)%2==1).map((e) =>
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: double.maxFinite,
                        child: Image.asset(e,fit: BoxFit.fitWidth,
                        ),
                      ),
                      if(e!=state.medias.where((element) =>
                      state.medias.indexOf(element)%2==1).last)
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
