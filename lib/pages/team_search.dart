import 'package:flutter/material.dart';
import 'package:shooting_app/classes/live_match_model.dart';

import '../classes/functions.dart';
import '../classes/services/live_match_service.dart';
import '../classes/dataTypes.dart';

class TeamSearch extends StatefulWidget {
  const TeamSearch({Key? key}) : super(key: key);
  @override
  _TeamSearchState createState() => _TeamSearchState();
}

class _TeamSearchState extends State<TeamSearch> {
  LiveMatchService service = LiveMatchService();
  late final TextEditingController controller;
  List<DataMatchTeam>? teams;
  bool loading=false;
  @override
  void initState() {
    statusSet(mainBlue);
    controller = TextEditingController()
      ..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
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
                          onChanged: (e)async{
                            if (controller.value.text.length < 3) return;
                            setState(() {
                              loading=true;
                            });
                            teams = [];
                            teams = await service.teams(
                                search: controller.value.text);
                            setState(() {loading=false;});
                          },
                          autofocus: true,
                          enableSuggestions: true,
                          cursorColor: mainBlue,
                          style: TextStyle(
                            color: Colors.black
                          ),
                          decoration: InputDecoration(

                              prefixIcon: Icon(Icons.search),
                              border: InputBorder.none,
                              hintText: AppLocalizations.of(context)!.search),
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
          child: Builder(builder: (context) {
            if(loading)
              return circle();
            else if (controller.value.text == '' && teams == null)
              return Center(child: Text(AppLocalizations.of(context)!.waiting_for_user_search));
            else if(teams == null && controller.value.text.length<3)
              return Center(child: Text(AppLocalizations.of(context)!.characters_required));
            else
              return teams==null || teams!.isEmpty
                  ? Center(child: Text(AppLocalizations.of(context)!.no_results))
                  : ListView.builder(
                      itemCount: teams!.length,
                      itemBuilder: (context, index) => ListTile(
                        onTap: () {
                          Go.pop(context, teams![index]);
                        },
                        leading: teams![index].logo == null
                            ? null
                            : SizedBox(
                                width: doubleWidth(15),
                                height: doubleWidth(15),
                                child: imageNetwork(teams![index].logo!)),
                        title: Text(teams![index].name),
                      ),
                      physics: BouncingScrollPhysics(),
                      padding: EdgeInsets.symmetric(
                          horizontal: doubleWidth(5),
                          vertical: doubleHeight(2)),
                    );
          }),
        ),
      ),
    );
  }
}
