import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shooting_app/classes/dataTypes.dart';
import 'package:video_player/video_player.dart';

import '../classes/functions.dart';



class MyVideoPlayer extends StatefulWidget {
  const MyVideoPlayer({Key? key, required this.url}) : super(key: key);
  final String url;
  @override
  MyVideoPlayerState createState() => MyVideoPlayerState();
}

class MyVideoPlayerState extends State<MyVideoPlayer> {
  late VideoPlayerController _controller;
  bool playing = false;
  bool loading = true;
  bool isTop = true;
  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.network(widget.url)
      ..addListener(() {
        setState(() {});

      });
    init();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future init() async {
    await Future.delayed(const Duration(seconds: 2));
    await _controller.initialize();
    setState(() {
      loading = false;
      playing = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Builder(
        builder: (context) {
          if (loading) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children:  [
                  simpleCircle(color: mainGreen),
                  SizedBox(height: doubleHeight(1)),
                 const Text('loading ...',
                 style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)
                ],
              ),
            );
          } else {
            return SafeArea(
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          isTop = !isTop;
                        });
                      },
                      child: AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: VideoPlayer(_controller),
                      ),
                    ),
                  ),
                  if(isTop)
                  Align(
                      alignment: Alignment.topCenter,
                      child: Row(
                        textDirection: TextDirection.ltr,
                        children: [
                          const SizedBox(
                            width: 16,
                          ),
                          IconButton(
                              onPressed: () {
                                WidgetsFlutterBinding.ensureInitialized();
                                SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp,]);
                                Navigator.pop(context);
                              },
                              icon: const Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                              )),
                          const SizedBox(
                            width: 16,
                          ),
                          // Expanded(
                          //   child: Text(
                          //     widget.video.name,
                          //           textDirection: TextDirection.rtl,
                          //           textAlign: TextAlign.right,
                          //     style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          //   ),
                          // ),
                          IconButton(
                              onPressed: () {
                                WidgetsFlutterBinding.ensureInitialized();
                                debugPrint('orientation ${MediaQuery.of(context).orientation}');
                                if (Orientation.portrait == MediaQuery.of(context).orientation) {
                                  SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeRight,
                                  DeviceOrientation.landscapeLeft]);
                                } else {
                                  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
                                }
                              },
                              icon: const Icon(
                                Icons.screen_rotation_rounded,
                                color: Colors.white,
                              ))
                        ],
                      )),
                  if(isTop)
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                      width: double.maxFinite,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Slider(
                            value: _controller.value.position.inSeconds.toDouble(),
                            onChanged: (double e) {
                              _controller.seekTo(Duration(seconds: e.toInt()));
                            },
                            min: 0,
                            max: _controller.value.duration.inSeconds.toDouble(),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextButton(
                                  onPressed: () {
                                    setState(() {
                                      _controller.seekTo(Duration(seconds: _controller.value.position.inSeconds - _controller.value.duration.inSeconds>30?10:2));
                                    });
                                  },
                                  child: const Text('-10',
                                      style:
                                          TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20))),
                              IconButton(
                                  padding: EdgeInsets.zero,
                                  onPressed: () {
                                    setState(() {
                                      _controller.value.isPlaying ? _controller.pause() : _controller.play();
                                    });
                                  },
                                  icon: Icon(
                                    _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                                    color: Colors.white,
                                    size: 40,
                                  )),
                              TextButton(
                                  onPressed: () {
                                    setState(() {
                                      _controller.seekTo(Duration(seconds: _controller.value.position.inSeconds + _controller.value.duration.inSeconds>30?10:2));
                                    });
                                  },
                                  child: const Text('+10',
                                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)))
                            ],
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
