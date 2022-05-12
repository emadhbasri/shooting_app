import 'package:flutter/material.dart';
import 'package:shooting_app/classes/dataTypes.dart';
import 'package:video_player/video_player.dart';

class VideoItem extends StatefulWidget {
  const VideoItem({Key? key, required this.controller}) : super(key: key);
  final VideoPlayerController controller;
  @override
  State<VideoItem> createState() => _VideoItemState();
}

class _VideoItemState extends State<VideoItem> with SingleTickerProviderStateMixin{

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      setState((){});
    });
    _controller=AnimationController(
      vsync: this,
      value: 0,
      duration: Duration(seconds: 1)
    );
    _controller.forward();
    _controller.addStatusListener((status) {
      if(status==AnimationStatus.completed)
        _controller.reverse();
      else if(status==AnimationStatus.dismissed)
        _controller.forward();
    });
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        if(widget.controller.value.isPlaying){
          widget.controller.pause();
        }else{
          widget.controller.play();
          widget.controller.setLooping(true);

        }
      },
      child: AspectRatio(
        aspectRatio: 1,//widget.controller.value.aspectRatio
        child: Stack(
          children: [
            VideoPlayer(widget.controller),
            Positioned(
                top: 5,
                right: 5,
                child: FadeTransition(
                  opacity: Tween<double>(begin: 0.3,end: 1).animate(_controller),
                  child: SizedBox(
                      width: 24,
                      height: 24,
                      child: Builder(
                        builder: (context) {
                          if(widget.controller.value.isPlaying){
                            Duration vidDuration =widget.controller.value.duration;
                            int vidSec = vidDuration.inSeconds;
                            Duration position =widget.controller.value.position;
                            int positionSec = position.inSeconds;
                            return Text(
                                (vidSec-positionSec).toString(),style: TextStyle(color: white),
                            );
                          }else{
                            return Image.asset('assets/images/live-stream.png',color: white);
                          }
                        },
                      )
                      ),
                )
            )
          ],
        ),
      ),
    );
  }


}
