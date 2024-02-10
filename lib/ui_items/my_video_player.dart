import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shooting_app/classes/dataTypes.dart';
import 'package:video_player/video_player.dart';

import '../classes/functions.dart';

class MyVideoPlayer extends StatefulWidget {
  const MyVideoPlayer({Key? key, required this.controller}) : super(key: key);
  final VideoPlayerController controller;
  @override
  MyVideoPlayerState createState() => MyVideoPlayerState();
}

class MyVideoPlayerState extends State<MyVideoPlayer> {
  bool isTop = true;
  @override
  void initState() {
    super.initState();

    widget.controller.addListener(() {
      print('asd');
      if (widget.controller.value.isInitialized) {
        setState(() {
          // widget.controller.play();
        });
      }
    });
    init();
  }

  Future<void> init() async {
    if (widget.controller.value.isInitialized) {
      await widget.controller.play();
      setState(() {});
    } else {
      await widget.controller.initialize();
      await widget.controller.play();
      setState(() {});
    }

    // await Future.delayed(const Duration(seconds: 2));
    // await _controller.initialize();
    // setState(() {
    //   playing = true;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // await widget.controller.pause();
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Builder(
          builder: (context) {
            if (!widget.controller.value.isInitialized) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    simpleCircle(color: mainGreen),
                    SizedBox(height: doubleHeight(1)),
                     Text(
                      AppLocalizations.of(context)!.loading,
                      // 'loading ...',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    )
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
                          aspectRatio: widget.controller.value.aspectRatio,
                          child: VideoPlayer(widget.controller),
                        ),
                      ),
                    ),
                    if (isTop)
                      Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            color: Colors.black.withOpacity(.2),
                            child: Row(
                              textDirection: TextDirection.ltr,
                              children: [
                                const SizedBox(
                                  width: 16,
                                ),
                                IconButton(
                                    onPressed: () async {

                                      Navigator.pop(context);
                                    },
                                    icon: const Icon(
                                      Icons.arrow_back,
                                      color: Colors.white,
                                    )),
                                const SizedBox(
                                  width: 16,
                                ),

                                IconButton(
                                    onPressed: () {
                                      WidgetsFlutterBinding.ensureInitialized();
                                      debugPrint(
                                          'orientation ${MediaQuery.of(context).orientation}');
                                      if (Orientation.portrait ==
                                          MediaQuery.of(context).orientation) {
                                        SystemChrome.setPreferredOrientations([
                                          DeviceOrientation.landscapeRight,
                                          DeviceOrientation.landscapeLeft
                                        ]);
                                      } else {
                                        SystemChrome.setPreferredOrientations(
                                            [DeviceOrientation.portraitUp]);
                                      }
                                    },
                                    icon: const Icon(
                                      Icons.screen_rotation_rounded,
                                      color: Colors.white,
                                    ))
                              ],
                            ),
                          )),
                    if (isTop)
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          color: Colors.black.withOpacity(.2),
                          width: double.maxFinite,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Slider(
                                value: widget
                                    .controller.value.position.inSeconds
                                    .toDouble(),
                                onChanged: (double e) {
                                  widget.controller
                                      .seekTo(Duration(seconds: e.toInt()));
                                },
                                min: 0,
                                max: widget.controller.value.duration.inSeconds
                                    .toDouble(),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextButton(
                                      onPressed: () {
                                        setState(() {
                                          widget.controller.seekTo(Duration(
                                              seconds: widget
                                                              .controller
                                                              .value
                                                              .position
                                                              .inSeconds -
                                                          widget
                                                              .controller
                                                              .value
                                                              .duration
                                                              .inSeconds >
                                                      30
                                                  ? widget.controller.value.position.inSeconds-10
                                                  : widget.controller.value.position.inSeconds-2));
                                        });
                                      },
                                      child: const Text('-10',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20))),
                                  IconButton(
                                      padding: EdgeInsets.zero,
                                      onPressed: () {
                                        setState(() {
                                          widget.controller.value.isPlaying
                                              ? widget.controller.pause()
                                              : widget.controller.play();
                                        });
                                      },
                                      icon: Icon(
                                        widget.controller.value.isPlaying
                                            ? Icons.pause
                                            : Icons.play_arrow,
                                        color: Colors.white,
                                        size: 40,
                                      )),
                                  TextButton(
                                      onPressed: () {
                                        setState(() {
                                          widget.controller.seekTo(Duration(
                                              seconds: widget.controller.value.position.inSeconds +
                                                          widget.controller.value.duration.inSeconds > 30 ?
                                              widget.controller.value.position.inSeconds+10 :
                                              widget.controller.value.position.inSeconds+2));
                                        });
                                      },
                                      child: const Text('+10',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20)))
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
      ),
    );
  }
}

class MyVideoPlayer1 extends StatefulWidget {
  const MyVideoPlayer1({Key? key, required this.url}) : super(key: key);
  final String url;
  @override
  MyVideoPlayer1State createState() => MyVideoPlayer1State();
}

class MyVideoPlayer1State extends State<MyVideoPlayer1> {
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
                children: [
                  simpleCircle(color: mainGreen),
                  SizedBox(height: doubleHeight(1)),
                  Text(
                    AppLocalizations.of(context)!.loading,
                    // 'loading ...',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  )
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
                  if (isTop)
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
                                  SystemChrome.setPreferredOrientations([
                                    DeviceOrientation.portraitUp,
                                  ]);
                                  Navigator.pop(context);
                                },
                                icon: const Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                )),
                            const SizedBox(
                              width: 16,
                            ),

                            IconButton(
                                onPressed: () {
                                  WidgetsFlutterBinding.ensureInitialized();
                                  debugPrint(
                                      'orientation ${MediaQuery.of(context).orientation}');
                                  if (Orientation.portrait ==
                                      MediaQuery.of(context).orientation) {
                                    SystemChrome.setPreferredOrientations([
                                      DeviceOrientation.landscapeRight,
                                      DeviceOrientation.landscapeLeft
                                    ]);
                                  } else {
                                    SystemChrome.setPreferredOrientations(
                                        [DeviceOrientation.portraitUp]);
                                  }
                                },
                                icon: const Icon(
                                  Icons.screen_rotation_rounded,
                                  color: Colors.white,
                                ))
                          ],
                        )),
                  if (isTop)
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: SizedBox(
                        width: double.maxFinite,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Slider(
                              value: _controller.value.position.inSeconds
                                  .toDouble(),
                              onChanged: (double e) {
                                _controller
                                    .seekTo(Duration(seconds: e.toInt()));
                              },
                              min: 0,
                              max: _controller.value.duration.inSeconds
                                  .toDouble(),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextButton(
                                    onPressed: () {
                                      setState(() {
                                        _controller.seekTo(Duration(
                                            seconds: _controller.value.position
                                                            .inSeconds -
                                                        _controller
                                                            .value
                                                            .duration
                                                            .inSeconds >
                                                    30
                                                ? 10
                                                : 2));
                                      });
                                    },
                                    child: const Text('-10',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20))),
                                IconButton(
                                    padding: EdgeInsets.zero,
                                    onPressed: () {
                                      setState(() {
                                        _controller.value.isPlaying
                                            ? _controller.pause()
                                            : _controller.play();
                                      });
                                    },
                                    icon: Icon(
                                      _controller.value.isPlaying
                                          ? Icons.pause
                                          : Icons.play_arrow,
                                      color: Colors.white,
                                      size: 40,
                                    )),
                                TextButton(
                                    onPressed: () {
                                      setState(() {
                                        _controller.seekTo(Duration(
                                            seconds: _controller.value.position
                                                            .inSeconds +
                                                        _controller
                                                            .value
                                                            .duration
                                                            .inSeconds >
                                                    30
                                                ? 10
                                                : 2));
                                      });
                                    },
                                    child: const Text('+10',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20)))
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
