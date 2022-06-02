import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

import '../../classes/functions.dart';

class ChooseMediaDialog extends StatelessWidget {
  const ChooseMediaDialog({Key? key,this.video=true,this.title='Please Pick Media'}) : super(key: key);
  final bool video;
  final String title;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),

      child: Container(
        margin: EdgeInsets.all(doubleWidth(4)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            Center(
              child: Text(title,style: Theme.of(context).textTheme.titleLarge ),
            ),
            SizedBox(height: doubleHeight(2)),

            Container(
              decoration: BoxDecoration(
                border: Border.all(width: 1,color: Colors.black),
                borderRadius: BorderRadius.circular(5),
              ),
              child: ListTile(
                onTap: ()async{
                  XFile? out =
                  await ImagePicker().pickImage(source: ImageSource.camera);
                  return Go.pop(context,out);
                },
                title: Text('Camera Image'),
                trailing: Icon(
                  Icons.camera_alt,
                  color: Color.fromRGBO(107, 79, 187, 1),
                ),
              ),
            ),SizedBox(height: doubleHeight(1)),
            Container(
              decoration: BoxDecoration(
                border: Border.all(width: 1,color: Colors.black),
                borderRadius: BorderRadius.circular(5),
              ),
              child: ListTile(
                onTap: ()async{
                  XFile? out =
                  await ImagePicker().pickImage(source: ImageSource.gallery);
                  print('emad $out');
                  return Go.pop(context,out);
                },
                title: Text('Library Image'),
                trailing: Icon(
                  Icons.image,
                  color: Color.fromRGBO(107, 79, 187, 1),
                ),
              ),
            ),

            SizedBox(height: doubleHeight(1)),
            if(video)
            Container(
              decoration: BoxDecoration(
                border: Border.all(width: 1,color: Colors.black),
                borderRadius: BorderRadius.circular(5),
              ),
              child: ListTile(
                onTap: ()async{
                  final XFile? video = await ImagePicker()
                      .pickVideo(source: ImageSource.gallery);

                  if (video != null) {
                    print('video.mimeType ${video.name}');

                    if (!video.name.endsWith('.mp4')) {
                      toast('The video format should be mp4');
                      return;
                    }

                    if (await video.length() > 20000000) {
                      print(
                          'await video.length() ${await video.length()}');
                      toast('The video should be less than 20M.',
                          isLong: true);
                      return;
                    }
                    VideoPlayerController _controller =
                    VideoPlayerController.file(
                        File(video.path));
                    await _controller.initialize();
                    Duration duration = _controller.value.duration;
                    if (duration.inSeconds <= 121) {
                      return Go.pop(context,video);
                    } else {
                      toast(
                          'The video should be less than 60 seconds.',
                          isLong: true);
                    }
                  }

                },
                title: Text('Library Video'),
                trailing: Icon(
                  Icons.video_library_outlined,
                  color: Color.fromRGBO(107, 79, 187, 1),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
