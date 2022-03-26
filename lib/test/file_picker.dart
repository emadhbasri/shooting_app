import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class FilePickerDemo extends StatefulWidget {
  @override
  _FilePickerDemoState createState() => _FilePickerDemoState();
}

class _FilePickerDemoState extends State<FilePickerDemo> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  List<XFile> _paths = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: _scaffoldMessengerKey,
      home: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text('File Picker example app'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 50.0, bottom: 20.0),
                    child: Column(
                      children: <Widget>[
                        ElevatedButton(
                          onPressed: () async {
                            final XFile? video = await ImagePicker()
                                .pickVideo(source: ImageSource.gallery);
                            if (video != null) {
                              _paths = [];
                              _paths.add(video);
                              print('video.path ${video.path}');
                              setState(() {

                              });
                            }
                          },
                          // onPressed: () => _pickFiles(),
                          child: Text('Pick file'),
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                  if (_paths.isNotEmpty)
                    ElevatedButton(
                      onPressed: () => init(),
                      child: Text('go to video ${_paths.first.name}'),
                    ),
                  if (show)
                    Builder(
                      builder: (context) {
                        Duration duration = _controller.value.duration;

                        return Text('asd ${duration.inSeconds}');
                      },
                    )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool show = false;
  init() async {
    _controller = VideoPlayerController.file(File(_paths.first.path));
    await _controller.initialize();
    setState(() {
      show = true;
    });
  }

  late VideoPlayerController _controller;
}
