import 'package:flutter/material.dart';
import 'package:shooting_app/classes/data.dart';

import '../classes/functions.dart';
import '../dataTypes.dart';
import 'home/fan_feeds.dart';

class Search extends StatefulWidget {
  final String? search;
  const Search({Key? key, this.search}) : super(key: key);
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  List<String> hashtags = ['YNWA', 'Salah', 'Watfold', 'Anfield', 'EPL'];
  late final TextEditingController controller;
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
                          onChanged: (e){
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
              if(controller.value.text=='')
              return ListView(
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: doubleWidth(5),vertical: doubleHeight(2)),
                children:
                [
                  Text(
                    'Trending Tags',
                    style: TextStyle(
                        color: black,
                        fontWeight: FontWeight.bold,
                        fontSize: doubleWidth(6)),
                  ),
                  ...hashtags
                      .map((e) => Container(
                            decoration: BoxDecoration(
                                border:
                                    Border(bottom: BorderSide(color: grayCall))),
                            child: ListTile(onTap: (){
                                // controller.text=e;
                                controller.value=TextEditingValue(text: e);
                            },

                              dense: true,
                              contentPadding: EdgeInsets.zero,
                              leading: Text(
                                ' # $e',
                                style: TextStyle(
                                    color: black, fontSize: doubleWidth(4)),
                              ),
                              trailing: Icon(
                                Icons.arrow_forward_ios,
                                color: grayCall,
                              ),
                            ),
                          ))
                      .toList()
                ]
              );
              else
                return ListView(
                    physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: doubleWidth(5),vertical: doubleHeight(2)),
                    children:posts.map((e) => PostItem(post: e,onTapTag: (f){
                      controller.value=TextEditingValue(text: f);
                    },)).toList()
                );

            }
          ),
        ),
      ),
    );
  }
}
