// import 'package:video_player/my_video_player.dart';
// import 'package:flutter/material.dart';
// class MyVideo extends StatefulWidget {
//   const MyVideo({Key? key}) : super(key: key);
//
//   @override
//   State<MyVideo> createState() => _MyVideoState();
// }
//
// class _MyVideoState extends State<MyVideo> {
//
//   late VideoPlayerController controller;
//   bool loadingVideo = true;
//   @override
//   void initState() {
//     super.initState();
//     person = widget.post.person;
//
//     init();
//   }
//   init()async{
//     if (widget.post.mediaTypes.isNotEmpty && widget.post.mediaTypes.first.media.contains('video/upload'))
//     {
//       controller = VideoPlayerController.network(widget.post.mediaTypes.first.media);
//       await controller.initialize();
//       setState(() {
//         loadingVideo=false;
//       });
//     }
//   }
//   @override
//   void dispose() {
//     super.dispose();
//     if (widget.post.mediaTypes.isNotEmpty && widget.post.mediaTypes.first.media.contains('video/upload'))
//       controller.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(10),
//       child: SizedBox(
//         width: max,
//         height: doubleWidth(70),
//         child: Builder(
//             builder: (context) {
//               if (widget.post.mediaTypes.isNotEmpty && widget.post.mediaTypes.first.media.contains('video/upload'))
//               {
//                 if (loadingVideo) {
//                   return Center(
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         const CircularProgressIndicator(),
//                         SizedBox(height: doubleHeight(1)),
//                         const Text(
//                           'loading ...',
//                           textDirection: TextDirection.ltr,
//                           style: TextStyle(
//                               color: mainBlue,
//                               fontWeight: FontWeight.bold),
//                         )
//                       ],
//                     ),
//                   );
//                 }
//                 return Center(
//                   child: GestureDetector(
//
//                     onTap: (){
//                       if(controller.value.isPlaying){
//                         controller.pause();
//
//                       }else{
//                         controller.play();
//                         controller.setLooping(true);
//                       }
//
//                     },
//                     child: AspectRatio(
//                       aspectRatio: controller.value.aspectRatio,
//                       child: VideoPlayer(controller),
//                     ),
//                   ),
//                 );
//               }
//               else
//                 return PageView.builder(
//                   controller:
//                   PageController(initialPage: 0, viewportFraction: 0.85),
//                   physics: BouncingScrollPhysics(),
//                   itemCount: widget.post.mediaTypes.length,
//                   itemBuilder: (_, index) => Padding(
//                     padding: EdgeInsets.only(
//                         right: widget.post.mediaTypes.length - 1 != index
//                             ? doubleHeight(2)
//                             : 0),
//                     child: GestureDetector(
//                       onTap: (){
//                         Go.push(context, Gal(images: widget.post.mediaTypes.map((e) => e.media).toList()));
//                       },
//                       child: ClipRRect(
//                           borderRadius: BorderRadius.circular(10),
//                           child: imageNetwork(
//                             widget.post.mediaTypes[index].media,
//                             fit: BoxFit.fill,
//                           )),
//                     ),
//                   ),
//                 );
//             }
//         ),
//       ),
//     );
//   }
//   @override
//   void dispose() {
//     super.dispose();
//     controller.dispose();
//   }
// }