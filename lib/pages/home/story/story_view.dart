import 'package:shooting_app/ui_items/shots/index.dart';

import '../../../package/story/story_page_view.dart';


class StoryPage extends StatefulWidget {
  const StoryPage({Key? key, required this.storyUsers,this.index=0}) : super(key: key);
  final List<DataStoryUser> storyUsers;
  final int index;
  @override
  _StoryPageState createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage> {
  late ValueNotifier<IndicatorAnimationCommand> indicatorAnimationController;

  @override
  void initState() {
    super.initState();

    indicatorAnimationController = ValueNotifier<IndicatorAnimationCommand>(
        IndicatorAnimationCommand.resume);

  }

  @override
  void dispose() {
    indicatorAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StoryPageView(
        indicatorDuration: Duration(seconds: 35),
        storyUsers: widget.storyUsers,
        initialPage: widget.index,
        gestureItemBuilder: (context, pageIndex, storyIndex) {
          return Stack(children: [
            // SizedBox.expand(
            //   child: GestureDetector(
            //       onTapDown: (e){
            //         indicatorAnimationController.value=IndicatorAnimationCommand.pause;
            //       },
            //     onTapCancel: (){
            //       indicatorAnimationController.value=IndicatorAnimationCommand.resume;
            //     },
            //   ),
            // ),
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 32),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  color: Colors.white,
                  icon: Icon(Icons.close),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ),


          ]);
        },
        indicatorAnimationController: indicatorAnimationController,
        initialStoryIndex: (pageIndex) {
          DataStoryUser user = widget.storyUsers[pageIndex];
          if(user.notSeen.length==0){
            return 0;
          }else{
            return user.seen.length;
          }
        },
        pageLength: widget.storyUsers.length,
        storyLength: (int pageIndex) {
          DataStoryUser user = widget.storyUsers[pageIndex];
          return user.seen.length + user.notSeen.length;
        },
        onPageLimitReached: () {
          Go.pop(context);
        },

      ),
    );
  }
}

// class StoryView extends StatelessWidget {
//   const StoryView({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: StoryPageView(
//         itemBuilder: (context, pageIndex, storyIndex) {
//           final user = sampleUsers[pageIndex];
//           final story = user.stories[storyIndex];
//           return Stack(
//             children: [
//               Positioned.fill(
//                 child: Container(color: Colors.black),
//               ),
//               Positioned.fill(
//                 child: Image.network(
//                   story.imageUrl,
//                   fit: BoxFit.cover,
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(top: 44, left: 8),
//                 child: Row(
//                   children: [
//                     Container(
//                       height: 32,
//                       width: 32,
//                       decoration: BoxDecoration(
//                         image: DecorationImage(
//                           image: NetworkImage(user.imageUrl),
//                           fit: BoxFit.cover,
//                         ),
//                         shape: BoxShape.circle,
//                       ),
//                     ),
//                     const SizedBox(
//                       width: 8,
//                     ),
//                     Text(
//                       user.userName,
//                       style: TextStyle(
//                         fontSize: 17,
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           );
//         },
//         gestureItemBuilder: (context, pageIndex, storyIndex) {
//           return Align(
//             alignment: Alignment.topRight,
//             child: Padding(
//               padding: const EdgeInsets.only(top: 32),
//               child: IconButton(
//                 padding: EdgeInsets.zero,
//                 color: Colors.white,
//                 icon: Icon(Icons.close),
//                 onPressed: () {
//                   Navigator.pop(context);
//                 },
//               ),
//             ),
//           );
//         },
//         pageLength: sampleUsers.length,
//         storyLength: (int pageIndex) {
//           return sampleUsers[pageIndex].stories.length;
//         },
//         onPageLimitReached: () {
//           Navigator.pop(context);
//         },
//       ),
//     );
//   }
// }
