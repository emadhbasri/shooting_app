import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shooting_app/classes/functions.dart';
import 'package:shooting_app/classes/models.dart';
import 'package:shooting_app/pages/profile/profile.dart';

import '../../classes/states/my_profile_state.dart';
import '../../dataTypes.dart';

class FanMates extends StatefulWidget {
  const FanMates({Key? key}) : super(key: key);

  @override
  _FanMatesState createState() => _FanMatesState();
}

class _FanMatesState extends State<FanMates> {
  @override
  Widget build(BuildContext context) {
    final MyProfileState state = Provider.of<MyProfileState>(context, listen: false);
    return Container(
      color: Color.fromRGBO(244, 244, 244, 1),
      child: ListView.separated(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(
          vertical: doubleHeight(1)
        ),
        itemCount: state.personalInformation!.userFollowers.length,
        itemBuilder: (BuildContext context, int index)=>FanMateItem(
            fan: state.personalInformation!.userFollowers[index]),
        separatorBuilder: (BuildContext context, int index)=>
        Divider(
          endIndent: doubleWidth(4),
          indent: doubleWidth(4),
          color: grayCall,
        ),
        // children: state.fans.map((e) =>
        //     FanMateItem(fan: e)
        // ).toList(),
      ),
    );
  }
}


class FanMateItem extends StatefulWidget {
  const FanMateItem({Key? key,required this.fan}) : super(key: key);
final DataUserFollower fan;

  @override
  State<FanMateItem> createState() => _FanMateItemState();
}

class _FanMateItemState extends State<FanMateItem> {
  late DataUserFollower fan;
@override
  void initState() {
    super.initState();
    fan=widget.fan;
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Go.pushSlideAnim(context, ProfileBuilder(username: fan.personalInformationViewModel.userName!));
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: doubleWidth(4)
        ),
        width: double.maxFinite,
        // height: doubleHeight(15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: doubleHeight(1)),
                Text(fan.personalInformationViewModel.fullName??''),SizedBox(height: doubleHeight(0.5)),
                Text(
                  '@${fan.personalInformationViewModel.userName??''}',
                  style: TextStyle(color: grayCall, fontSize: 12),
                ),SizedBox(height: doubleHeight(0.5)),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Consumer<MyProfileState>(builder: (context, value, child) {
                      // int index = value.fans.indexOf(fan);
                      return ElevatedButton(
                        onPressed: () {
                          print('click');
                          // value.fans[index].isFollowed=!value.fans[index].isFollowed;
                          // value.notify();
                        },
                        child: Text(fan.followingMe?'Follow':'Following',style: TextStyle(color: Colors.black),),
                        style: ButtonStyle(
                          backgroundColor:
                          MaterialStateProperty.all(
                              fan.followingMe?//todo
                              Color.fromRGBO(216, 216, 216, 1):Color.fromRGBO(78, 255, 187, 1)
                          ),
                          elevation: MaterialStateProperty.all(0),
                          shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7),
                          )),
                          padding: MaterialStateProperty.all(EdgeInsets.symmetric(
                              horizontal: doubleWidth(7))),
                        ),
                      );
                    }),
                  ],
                ),
              ],
            ),
            SizedBox(
                width: doubleWidth(20),
                height: doubleWidth(20),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: fan.personalInformationViewModel.profilePhoto
                            !=null?
                        imageNetwork(fan.personalInformationViewModel.profilePhoto??'',fit: BoxFit.fill):null),
                    Align(
                      alignment: Alignment(0.9, -0.9),
                      child: SizedBox(
                        width: doubleHeight(3),
                        height: doubleHeight(3),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border:
                              Border.all(color: Colors.white, width: 3),
                              borderRadius:
                              BorderRadius.circular(100),
                                image: fan.personalInformationViewModel.team!=null && fan.personalInformationViewModel.team!.team_badge!=null?DecorationImage(
                                  image: networkImage(fan.personalInformationViewModel.team!.team_badge!),
                                ):null,
                              ),
                        ),
                      ),
                    )
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
