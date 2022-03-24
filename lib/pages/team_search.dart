import 'package:flutter/material.dart';
import 'package:shooting_app/classes/live_match_model.dart';

import '../classes/functions.dart';
import '../classes/services/live_match_service.dart';
import '../dataTypes.dart';

class TeamSearch extends StatefulWidget {
  final String? search;
  const TeamSearch({Key? key, this.search}) : super(key: key);
  @override
  _TeamSearchState createState() => _TeamSearchState();
}

class _TeamSearchState extends State<TeamSearch> {
  LiveMatchService service = LiveMatchService();
  late final TextEditingController controller;
  List<DataMatchTeam> teams=[];
  @override
  void initState() {
    statusSet(mainBlue);
    controller = TextEditingController(
      text: widget.search??''
    )..addListener(() {
      setState(() {

      });
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    print('controller.value.text ${controller.value.text}');
    return WillPopScope(
      onWillPop: () async {
        // statusSet(trans);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              IconButton(
                padding: EdgeInsets.zero,
                icon: Icon(
                  Icons.arrow_back,
                  color: white,
                ),
                onPressed: () {
                  Go.pop(context, false);
                },
              ),
              Expanded(
                child: Container(
                  height: doubleHeight(7),
                  padding: EdgeInsets.symmetric(vertical: doubleHeight(1)),
                  child: ClipRRect(
                    child: Container(
                      width: max,
                      height: doubleHeight(7),
                      color: white,
                      child: Center(
                        child: TextField(
                          controller: controller,
                          onSubmitted: (e)async{
                            if(controller.value.text.length<3)return;
                            teams=await service.teams(search: controller.value.text);
                            setState(() {});
                          },
                          autofocus: true,
                          cursorColor: mainBlue,
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.search),
                              border: InputBorder.none,
                              hintText: 'Search'),
                        ),
                      ),
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ),
        body: SizedBox.expand(
          child: Builder(
            builder: (context) {
              print('team ${teams.length}');
              if(controller.value.text=='')
              return Text('waiting for user search');
              else
                // return Text('no results');
                return teams.isEmpty?Text('no results'):
                  ListView.builder(
                    itemCount: teams.length,
                    itemBuilder: (context, index) =>
                        ListTile(
                          onTap: (){
                            Go.pop(context,teams[index]);
                          },
                          leading: teams[index].logo==null?null:SizedBox(
                              width: doubleWidth(15),
                              height: doubleWidth(15),
                              child: imageNetwork(teams[index].logo!)),
                          title: Text(teams[index].name),
                        ),
                    physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: doubleWidth(5),vertical: doubleHeight(2)),

                );

            }
          ),
        ),
      ),
    );
  }
}
