import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../story_stack_controller.dart';

class Gestures extends StatelessWidget {
  const Gestures({
    Key? key,
    required this.animationController,
    this.videoPlayerController
  }) : super(key: key);
  final VideoPlayerController? videoPlayerController;
  final AnimationController animationController;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            color: Colors.transparent,
            child: GestureDetector(
              onTap: () {
                animationController.forward(from: 0);
                context.read<StoryStackController>().decrement();
              },
              onLongPress: () {
                animationController.stop();
                if(videoPlayerController!=null)
                  videoPlayerController!.pause();
              },
              onLongPressUp: () {
                animationController.forward();
                if(videoPlayerController!=null)
                  videoPlayerController!.play();
              },
            ),
          ),
        ),
        Expanded(
          child: Container(
            color: Colors.transparent,
            child: GestureDetector(
              onTap: () {
                context.read<StoryStackController>().increment(
                      restartAnimation: () =>
                          animationController.forward(from: 0),
                      completeAnimation: () => animationController.value = 1,
                    );
              },
              onLongPress: () {
                animationController.stop();
                print('videoPlayerControllersss $videoPlayerController');
                if(videoPlayerController!=null)
                  videoPlayerController!.pause();
              },
              onLongPressUp: () {
                animationController.forward();
                if(videoPlayerController!=null)
                  videoPlayerController!.play();
              },
            ),
          ),
        ),
      ],
    );
  }
}
