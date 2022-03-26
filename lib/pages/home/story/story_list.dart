// SizedBox(
//   width: max,
//   height: doubleHeight(9),
//   child: SingleChildScrollView(
//     scrollDirection: Axis.horizontal,
//     child: Row(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: <Widget>[
//         Container(
//           width: doubleHeight(9),
//           height: doubleHeight(9),
//           padding: EdgeInsets.all(doubleWidth(2)),
//           child: Container(
//             decoration: BoxDecoration(
//                 color: white,
//                 borderRadius: BorderRadius.circular(100),
//                 image: DecorationImage(
//                   image: AssetImage('images/158023.png'),
//                 )),
//             child: Container(
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(100),
//                 color: mainBlue.withOpacity(0.6),
//               ),
//               child: Center(
//                 child: Icon(
//                   Icons.add,
//                   color: white,
//                   size: doubleWidth(9),
//                 ),
//               ),
//             ),
//           ),
//         ),
//         ...List.generate(15, (index) {
//           return index;
//         })
//             .map(
//               (e) => Container(
//                 width: doubleHeight(9),
//                 height: doubleHeight(9),
//                 padding: EdgeInsets.all(doubleWidth(2)),
//                 child: Container(
//                   decoration: BoxDecoration(
//                       color: white,
//                       border: Border.all(color: mainGreen),
//                       borderRadius: BorderRadius.circular(100),
//                       image: DecorationImage(
//                           image: AssetImage('images/158023.png'))),
//                 ),
//               ),
//             )
//             .toList()
//       ],
//     ),
//   ),
// ),
import 'package:provider/provider.dart';
import 'package:dashed_circle/dashed_circle.dart';
import 'package:shooting_app/pages/home/story/story_view.dart';

import '../../../classes/states/main_state.dart';
import '../../../package/dashed_color_circle/dashed_color_circle.dart';
import '../../../package/stories_editor.dart';
import '../../../ui_items/shots/index.dart';

class StoryList extends StatefulWidget {
  const StoryList({Key? key}) : super(key: key);

  @override
  State<StoryList> createState() => _StoryListState();
}

class _StoryListState extends State<StoryList> {

  @override
  void initState() {
    super.initState();
    MainState state = Provider.of(context,listen: false);
    state.getStories();
  }

  @override
  Widget build(BuildContext context) {
    final String url =
        'https://upload.wikimedia.org/wikipedia/commons/thumb/7/71/Bill_Gates_Buys_Skype_%285707954468%29.jpg/2560px-Bill_Gates_Buys_Skype_%285707954468%29.jpg';

    return Consumer<MainState>(
      builder: (context, state, child) {
        return RefreshIndicator(
          onRefresh: () async {
            // await state.getFanFeed();
          },
          child: Scaffold(
            body: ListView(
              children: [
                ListTile(
                  onTap: () {
                    Go.push(
                        context,
                        StoriesEditor(
                          giphyKey: 'story 1',
                          onDone: (uri) {
                            debugPrint(uri);
                            // Share.shareFiles([uri]);
                          },
                        ));
                  },
                  leading:
                  //teams[index].logo==null?null:
                  SizedBox(
                      width: doubleWidth(15),
                      height: doubleWidth(15),
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 70.0,
                            backgroundImage: networkImage(url),
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Container(
                              padding: EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: white,
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Icon(Icons.add,size: 15,color: black,),
                            ),
                          )
                        ],
                      )),
                  title: Text('My stories'),
                  subtitle: Text('Tap to add story'),
                  trailing: AbsorbPointer(
                    absorbing: true,
                    child: FloatingActionButton(
                      mini: true,
                      onPressed: () {},
                      heroTag: 'story add top',
                      child: Icon(Icons.edit),
                    ),
                  ),
                ),
                // Divider(color: grayCall,indent: doubleWidth(24)),
                if(state.newStories.isNotEmpty)
                  ExpansionTile(
                  trailing: const SizedBox(),
                  initiallyExpanded: true,
                  title: Text('Recent Stories'),
                children: state.newStories.map((e) => StoryListItem(storyUser: e)).toList()),
                if(state.storyViewed.isNotEmpty)
                  ExpansionTile(
                  trailing: const SizedBox(),
                  initiallyExpanded: true,
                  title: Text('Viewed Stories'),
                  children: state.storyViewed.map((e) => StoryListItem(storyUser: e)).toList()),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Go.push(
                    context,
                    StoriesEditor(

                      giphyKey: 'story 1',
                      onDone: (uri) {
                        debugPrint(uri);
                        // Share.shareFiles([uri]);
                      },
                    ));
              },
              heroTag: 'story add',
              child: Icon(Icons.add_circle),
            ),
          ),
        );
      },
    );
  }
}
class StoryListItem extends StatelessWidget {
  const StoryListItem({Key? key,required this.storyUser}) : super(key: key);
  final DataStoryUser storyUser;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Go.pushSlideAnim(context, StoryPage());
      },
      leading: SizedBox(
          width: doubleWidth(15),
          height: doubleWidth(15),
          child: DashedColorCircle(
            dashes: storyUser.notSeen.length + storyUser.seen.length,
            emptyColor: Colors.grey,
            filledColor: mainBlue,
            fillCount: 3,//storyUser.seen.length
            gapSize: 5,
            strokeWidth: 4,
            child: Padding(
              padding: EdgeInsets.all(6.0),
              child:
              storyUser.person.profilePhoto!=null?CircleAvatar(
                radius: 70.0,
                backgroundImage: networkImage(storyUser.person.profilePhoto!),
              ):null,
            ),
          )),
      title: Text(storyUser.person.fullName??''),
      subtitle: Text(storyUser.person.userName??'')
      // Text('${getMonString(DateTime.now())} ${DateTime.now().day}, ${DateTime.now().year}'),
    );
  }
}



//StoriesEditor(
//     giphyKey: '[YOUR GIPHY API KEY]', /// (String) required param
//     onDone: (String uri){
//       /// uri is the local path of final render Uint8List
//       /// here your code
//     },
//     colorList: [] /// (List<Color>[]) optional param
//     gradientColors: [] /// (List<List<Color>>[]) optional param
//     middleBottomWidget: Container() /// (Widget) optional param, you can add your own logo or text in the bottom tool
//     fontFamilyList: [] /// (List<String>) optional param
//     isCustomFontList: '' /// (bool) if you use a own font list set value to "true"
//     onDoneButtonStyle: Container() /// (Widget) optional param, you can create your own button style
//                 onBackPress: /// (Future<bool>) optional param, here you can add yor own style dialog
//                 editorBackgroundColor: /// (Color) optional param, you can define your own background editor color
//                 galleryThumbnailQuality: /// (int = 200) optional param, you can set the gallery thumbnail quality (higher is better but reduce the performance)
//                 )
