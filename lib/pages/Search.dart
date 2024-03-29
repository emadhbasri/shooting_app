import 'package:flutter/material.dart';
import 'package:shooting_app/classes/services/my_service.dart';
import 'package:shooting_app/classes/services/shots_service.dart';

import '../classes/functions.dart';
import '../classes/models.dart';
import '../classes/dataTypes.dart';
import '../main.dart';
import '../ui_items/shots/post_from_shot.dart';
import 'profile/profile.dart';

class Search extends StatefulWidget {
  final String? search;
  const Search({Key? key, this.search}) : super(key: key);
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  // List<String> hashtags = ['YNWA', 'Salah', 'Watfold', 'Anfield', 'EPL'];
  late final TextEditingController controller;
  List<DataPost>? posts;
  String search='';
  getData() async {
    setState(() {
      posts = null;
    });
    MyService service = getIt<MyService>();
    posts = await ShotsService.search(service, search: controller.value.text.replaceAll('#', ''));
    setState(() {});
  }

  @override
  void initState() {
    statusSet(mainBlue);
    controller = TextEditingController(text: widget.search ?? '')
      ..addListener(() {
        setState(() {});
      });
    if (widget.search != null) {
      getData();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        style: TextStyle(
                            color: Colors.black
                        ),
                        enableSuggestions: true,
                        controller: controller,
                        onChanged: (e) {
                          if(search!=e) {
                            search = e;
                            getData();
                          }
                        },
                        autofocus: true,
                        cursorColor: mainBlue,
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


          if (controller.value.text == '')
            return Center(child: Text(
              AppLocalizations.of(context)!.please_search_in_shots
              // 'Please Search In Shots.'
              ));
          if (posts == null) {
              return circle();
            } else if (posts!.isEmpty) {
              return Center(child: Text(
                AppLocalizations.of(context)!.no_shots
                // 'No Shots'
                ));
            } else {
              return ListView(

                  padding: EdgeInsets.symmetric(
                      horizontal: doubleWidth(5), vertical: doubleHeight(2)),
                  children: posts!
                      .map((e) => PostFromShot(
                    key: UniqueKey(),
                    delete: (){
                      setState(() {
                        posts!.remove(e);
                      });
                    },
                          post: e,
                          onTapTag:
                              (BuildContext context, String str, bool isUser) {
                            if (isUser) {
                              Go.pushSlideAnim(
                                  context, ProfileBuilder(username: str));
                            } else {
                              controller.value = TextEditingValue(text: str);
                            }
                          }))
                      .toList());
            }
          // }
        }),
      ),
    );
  }
}
