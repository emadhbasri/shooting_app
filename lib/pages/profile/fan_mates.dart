import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shooting_app/classes/functions.dart';

import '../../classes/states/profile_state.dart';
import '../../dataTypes.dart';

class FanMates extends StatefulWidget {
  const FanMates({Key? key}) : super(key: key);

  @override
  _FanMatesState createState() => _FanMatesState();
}

class _FanMatesState extends State<FanMates> {
  @override
  Widget build(BuildContext context) {
    final ProfileState state = Provider.of<ProfileState>(context, listen: false);
    return Container(
      color: Color.fromRGBO(244, 244, 244, 1),
      child: ListView.separated(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(
          vertical: doubleHeight(1)
        ),
        itemCount: state.fans.length,
        itemBuilder: (BuildContext context, int index)=>FanMateItem(fan: state.fans[index]),
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

class DataFan{
  String name='Mason Moreno';
  String image='images/158023.png';
  String teamImage='images/unnamed.png';
  String username='masonmoreno';
  bool isFollowed=false;
  DataFan(
      {required this.name,
      required this.image,
      required this.teamImage,
      required this.username,
      required this.isFollowed});
  DataFan.fromDefault();
}

class FanMateItem extends StatefulWidget {
  const FanMateItem({Key? key,required this.fan}) : super(key: key);
final DataFan fan;

  @override
  State<FanMateItem> createState() => _FanMateItemState();
}

class _FanMateItemState extends State<FanMateItem> {
  late DataFan fan;
@override
  void initState() {
    super.initState();
    fan=widget.fan;
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: doubleWidth(4)
      ),
      width: double.maxFinite,
      // height: doubleHeight(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: doubleHeight(1)),
              Text(fan.name),SizedBox(height: doubleHeight(0.5)),
              Text(
                '@${fan.username}',
                style: TextStyle(color: grayCall, fontSize: 12),
              ),SizedBox(height: doubleHeight(0.5)),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Consumer<ProfileState>(builder: (context, value, child) {
                    int index = value.fans.indexOf(fan);
                    return ElevatedButton(
                      onPressed: () {
                        print('click');
                        value.fans[index].isFollowed=!value.fans[index].isFollowed;
                        value.notify();
                      },
                      child: Text(value.fans[index].isFollowed?'Follow':'Following',style: TextStyle(color: Colors.black),),
                      style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.all(
                            value.fans[index].isFollowed?Color.fromRGBO(216, 216, 216, 1):Color.fromRGBO(78, 255, 187, 1)
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
                      child: Image.asset(fan.image)),
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
                            image: DecorationImage(
                              image: AssetImage(fan.teamImage),
                            )),
                      ),
                    ),
                  )
                ],
              )),
        ],
      ),
    );
  }
}
