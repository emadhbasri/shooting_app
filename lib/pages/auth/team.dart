
import 'package:flutter/material.dart';

import '../../classes/functions.dart';
import '../../dataTypes.dart';
import '../AppPage.dart';

class Team extends StatefulWidget {
  @override
  _TeamState createState() => _TeamState();
}

class _TeamState extends State<Team> {
  String? countrie;
  List<DropdownMenuItem<String>> countries = [
    DropdownMenuItem(child:
      Text(
        'country 1'
      ),
      value: 'country 1',
    ),
    DropdownMenuItem(child:
    Text(
        'country 2'
    ),
      value: 'country 2',
    ),
    DropdownMenuItem(child:
    Text(
        'country 3'
    ),
      value: 'country 3',
    ),
  ];

  String? legue;
  List<DropdownMenuItem<String>> legues = [
    DropdownMenuItem(child:
    Text(
        'legue 1'
    ),
      value: 'legue 1',
    ),
    DropdownMenuItem(child:
    Text(
        'legue 2'
    ),
      value: 'legue 2',
    ),
    DropdownMenuItem(child:
    Text(
        'legue 3'
    ),
      value: 'legue 3',
    ),
  ];
  String? team;
  List<DropdownMenuItem<String>> teams = [
    DropdownMenuItem(child:
    Text(
        'team 1'
    ),
      value: 'team 1',
    ),
    DropdownMenuItem(child:
    Text(
        'team 2'
    ),
      value: 'team 2',
    ),
    DropdownMenuItem(child:
    Text(
        'team 3'
    ),
      value: 'team 3',
    ),
  ];

String search = '';

  @override
  void initState() {
    statusSet(trans);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: decorImage(img: 'images/stadium.jpg'),
      child: Scaffold(
        backgroundColor: trans,
        body: Stack(
          children: <Widget>[
            Container(
              width: max,
              height: max,
              padding: EdgeInsets.symmetric(horizontal: doubleWidth(4.5)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[

                  ClipRRect(
                    child: Container(
                      width: max,
                      height: doubleHeight(7),
                      color: Color.fromRGBO(216, 216, 216, 1),
                      child: Center(
                        child: TextField(
                          decoration: InputDecoration(
                              prefixText: '        ',
                              border: InputBorder.none,
                              hintText: 'Search for teams...'
                          ),
                        ),
                      ),
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  sizeh(doubleHeight(3)),
                  Container(
                    width: max,
                    height: doubleHeight(3),
                    padding: EdgeInsets.symmetric(horizontal: doubleWidth(5)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: doubleWidth(28),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                              gray.withOpacity(0.1),
                              gray.withOpacity(0.2),
                              gray.withOpacity(0.4),
                              gray.withOpacity(0.6),
                              gray.withOpacity(0.8),
                              gray,white
                            ])
                          ),
                          height: doubleHeight(0.2),
                        ),
                        Text(
                          'OR',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: doubleWidth(4.5),
                              color: white),
                        ),
                        Container(
                          width: doubleWidth(28),
                          decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [
                                white,
                                  gray,
                                  gray.withOpacity(0.8),
                                  gray.withOpacity(0.6),
                                  gray.withOpacity(0.4),
                                  gray.withOpacity(0.2),
                                  gray.withOpacity(0.1),
                              ])
                          ),
                          height: doubleHeight(0.2),
                        ),
                      ],
                    ),
                  ),
                  sizeh(doubleHeight(4)),
                  Text(
                    'Search by country',
                    style: TextStyle(
                        fontSize: doubleWidth(4),
                        color: white),
                  ),
                  sizeh(doubleHeight(3)),
                  ClipRRect(
                    child: Container(
                      width: max,
                      height: doubleHeight(7),
                      padding: EdgeInsets.symmetric(horizontal: doubleWidth(5)),
                      color: Color.fromRGBO(216, 216, 216, 1),
                      child: Center(
                        child: DropdownButton<String>(
                          underline: non,isDense: true,
                          value: countrie,
                          isExpanded: true,
                          hint: Text('Countries'),
                          icon: Icon(Icons.keyboard_arrow_down),
                          onChanged: (val){
                            setState(() {
                              countrie=val;
                            });
                          },
                          items: countries,
                        ),
                      ),
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  sizeh(doubleHeight(1.3)),
                  ClipRRect(
                    child: Container(
                      width: max,
                      height: doubleHeight(7),
                      padding: EdgeInsets.symmetric(horizontal: doubleWidth(5)),
                      color: Color.fromRGBO(216, 216, 216, 1),
                      child: Center(
                        child: DropdownButton<String>(
                          underline: non,isDense: true,
                          value: legue,
                          isExpanded: true,
                          hint: Text('League'),
                          icon: Icon(Icons.keyboard_arrow_down),
                          onChanged: (val){
                            setState(() {
                              legue=val;
                            });
                          },
                          items: legues,
                        ),
                      ),
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  sizeh(doubleHeight(1.3)),
                  ClipRRect(
                    child: Container(
                      width: max,
                      height: doubleHeight(7),
                      padding: EdgeInsets.symmetric(horizontal: doubleWidth(5)),
                      color: Color.fromRGBO(216, 216, 216, 1),
                      child: Center(
                        child: DropdownButton<String>(
                          underline: non,isDense: true,
                          value: team,
                          isExpanded: true,
                          hint: Text('Team'),
                          icon: Icon(Icons.keyboard_arrow_down),
                          onChanged: (val){
                            setState(() {
                              team=val;
                            });
                          },
                          items: teams,
                        ),
                      ),
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  sizeh(doubleHeight(1.3)),
                  Container(
                    width: max,
                    height: doubleHeight(8),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10)),
                      child: RaisedButton(
                        onPressed: () {
                          Go.pushSlideAnim(context, AppPageBuilder());
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        color: mainBlue,
                        child: Text(
                          'Join the line up',
                          style: TextStyle(fontSize: doubleWidth(5), color: white),
                        ),
                      ),
                    ),
                  ),
                  sizeh(doubleHeight(17)),

                ],
              ),
            ),
            Align(
              alignment: Alignment(0, -0.7),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    'Choose your team',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                        fontSize: doubleWidth(5),
                        color: white),
                  ),
                  sizeh(doubleHeight(3)),
                  Text(
                    'What\s yout favorite team?',
                    style: TextStyle(
                        fontSize: doubleWidth(4),
                        color: white),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
