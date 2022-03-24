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

import '../../../classes/states/main_state.dart';
import '../../../package/dashed_color_circle/dashed_color_circle.dart';
import '../../../package/stories_editor.dart';
import '../../../ui_items/shots/index.dart';

class StoryList extends StatelessWidget {
  const StoryList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String url = 'https://upload.wikimedia.org/wikipedia/commons/thumb/7/71/Bill_Gates_Buys_Skype_%285707954468%29.jpg/2560px-Bill_Gates_Buys_Skype_%285707954468%29.jpg';

    return Consumer<MainState>(
      builder: (context, state, child) {
        return RefreshIndicator(
          onRefresh: () async {
            await state.getFanFeed();
          },
          child: Scaffold(
            body: ListView(
              children: [
                ListTile(
                  onTap: (){
                    // Go.pop(context,teams[index]);
                  },
                  leading:
                  //teams[index].logo==null?null:
                  SizedBox(
                      width: doubleWidth(15),
                      height: doubleWidth(15),
                      child: DashedCircle(
                        dashes: 4,
                        color: mainBlue,
                        child: Padding(padding: EdgeInsets.all(6.0),
                          child: CircleAvatar(
                            radius: 70.0,
                            backgroundImage: NetworkImage(url),
                          ),
                        ),
                      )),
                  title: Text('title'),
                  subtitle: Text('subtitle'),
                ),
                ListTile(
                  onTap: (){
                    // Go.pop(context,teams[index]);
                  },
                  leading:
                  //teams[index].logo==null?null:
                  SizedBox(
                      width: doubleWidth(15),
                      height: doubleWidth(15),
                      child: DashedColorCircle(
                        dashes: 4,
                        emptyColor: Colors.grey,
                        filledColor: mainBlue,
                        fillCount: 2,
                        gapSize: 5,
                        strokeWidth: 4,
                        child: Padding(padding: EdgeInsets.all(6.0),
                          child: CircleAvatar(
                            radius: 70.0,
                            backgroundImage: networkImage(url),
                          ),
                        ),
                      )),
                  title: Text('title'),
                  subtitle: Text('subtitle'),
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: (){
Go.push(context, StoriesEditor(
  giphyKey: 'story 1',

  onDone: (uri){
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