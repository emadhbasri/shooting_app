import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shooting_app/classes/functions.dart';
import 'package:video_player/video_player.dart';

import '../../../../classes/models.dart';
import '../../../../classes/services/my_service.dart';
import '../../../../main.dart';
import '../../domain/providers/notifiers/control_provider.dart';
import '../../domain/providers/notifiers/draggable_widget_notifier.dart';
import '../../domain/providers/notifiers/painting_notifier.dart';
import '../../domain/sevices/save_as_image.dart';
import '../utils/modal_sheets.dart';
import '../widgets/animated_onTap_button.dart';
import '../widgets/tool_button.dart';


class TopTools extends StatefulWidget {
  final GlobalKey contentKey;
  final BuildContext context;
  const TopTools({Key? key, required this.contentKey, required this.context})
      : super(key: key);

  @override
  _TopToolsState createState() => _TopToolsState();
}

class _TopToolsState extends State<TopTools> {
  bool loading=false;
  @override
  Widget build(BuildContext context) {
    return Consumer3<ControlNotifier, PaintingNotifier,
        DraggableWidgetNotifier>(
      builder: (_, controlNotifier, paintingNotifier, itemNotifier, __) {
        return SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: const BoxDecoration(color: Colors.transparent),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                /// close button
                ToolButton(
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                    backGroundColor: Colors.black12,
                    onTap: () async {
                      var res = await exitDialog(
                          context: widget.context,
                          contentKey: widget.contentKey);
                      if (res) {
                        Navigator.pop(context);
                      }
                    }),
                if (controlNotifier.mediaPath.isEmpty)
                  _selectColor(
                      controlProvider: controlNotifier,
                      onTap: () {
                        if (controlNotifier.gradientIndex >=
                            controlNotifier.gradientColors!.length - 1) {
                          setState(() {
                            controlNotifier.gradientIndex = 0;
                          });
                        } else {
                          setState(() {
                            controlNotifier.gradientIndex += 1;
                          });
                        }
                      }),
                ToolButton(
                    child: const ImageIcon(
                      AssetImage('assets/icons/download.png'),
                      color: Colors.white,
                      size: 20,
                    ),
                    backGroundColor: Colors.black12,
                    onTap: () async {
                      if (paintingNotifier.lines.isNotEmpty ||
                          itemNotifier.draggableWidget.isNotEmpty) {
                        var response = await takePicture(
                            contentKey: widget.contentKey,
                            context: context,
                            saveToGallery: true);
                        if (response) {
                          Fluttertoast.showToast(msg: 'Successfully saved');
                        } else {
                          Fluttertoast.showToast(msg: 'Error');
                        }
                      }
                    }),
                ToolButton(
                    child: Icon(Icons.share,color: Colors.white,size: 20,),
                    backGroundColor: Colors.black12,
                    onTap: () async{
                      String pngUri;
                      await takePicture(
                          contentKey: widget.contentKey,
                          context: context,
                          saveToGallery: false)
                          .then((bytes) {
                        if (bytes != null) {
                          pngUri = bytes;
                          print('emad $pngUri');
                          Share.shareFiles(
                            [pngUri],
                            mimeTypes: ['image/png'],
                          );
                        } else {}
                      });
                    }
                ),
                // ToolButton(
                //     child: const ImageIcon(
                //       AssetImage('assets/icons/stickers.png',
                //           ),
                //       color: Colors.white,
                //       size: 20,
                //     ),
                //     backGroundColor: Colors.black12,
                //     onTap: () => createGiphyItem(
                //         context: context, giphyKey: controlNotifier.giphyKey)),
                ToolButton(
                    child: const ImageIcon(
                      AssetImage('assets/icons/draw.png',
                          ),
                      color: Colors.white,
                      size: 20,
                    ),
                    backGroundColor: Colors.black12,
                    onTap: () {
                      controlNotifier.isPainting = true;
                      //createLinePainting(context: context);
                    }),
                // ToolButton(
                //   child: ImageIcon(
                //     const AssetImage('assets/icons/photo_filter.png',
                //         ),
                //     color: controlNotifier.isPhotoFilter ? Colors.black : Colors.white,
                //     size: 20,
                //   ),
                //   backGroundColor:  controlNotifier.isPhotoFilter ? Colors.white70 : Colors.black12,
                //   onTap: () => controlNotifier.isPhotoFilter =
                //   !controlNotifier.isPhotoFilter,
                // ),
                ToolButton(
                  child: const ImageIcon(
                    AssetImage('assets/icons/text.png',
                        ),
                    color: Colors.white,
                    size: 20,
                  ),
                  backGroundColor: Colors.black12,
                  onTap: () => controlNotifier.isTextEditing =
                      !controlNotifier.isTextEditing,
                ),
                if(loading)
                  SizedBox(
                      width: doubleWidth(7),
                      height: doubleWidth(7),
                      child: CircularProgressIndicator())
                else
                ToolButton(
                    child: Icon(Icons.video_library_outlined,color: Colors.white,size: 20,),
                    backGroundColor: Colors.black12,
                    onTap: () async{
                      if(loading)return;
                      final XFile? video = await ImagePicker()
                          .pickVideo(source: ImageSource.gallery);

                      if (video != null) {
                        setState(() {
                          loading=true;
                        });
                        print('video.mimeType ${video.name}');

                        if(!video.name.endsWith('.mp4')){
                          toast('The video format should be mp4');
                          setState(() {
                            loading=false;
                          });
                          return;
                        }
                        VideoPlayerController _controller=VideoPlayerController.file(File(video.path));
                        await _controller.initialize();
                        Duration duration = _controller.value.duration;
                        if(duration.inSeconds<=30){
                          MyService service = getIt<MyService>();
                          DataShortVideoStory? back =
                          await service.createStory(mimeType: '.mp4',
                              mediaURI: video);
                          setState(() {
                            loading=false;
                          });
                          if (back != null) {
                            Go.pop(context);
                          }
                        }else{
                          setState(() {
                            loading=false;
                          });
                          toast('The video should be less than 10 seconds.',duration: Toast.LENGTH_LONG);
                        }
                      }
                    }
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// gradient color selector
  Widget _selectColor({onTap, controlProvider}) {
    return Padding(
      padding: const EdgeInsets.only(left: 5, right: 5, top: 8),
      child: AnimatedOnTapButton(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(2),
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: controlProvider
                      .gradientColors![controlProvider.gradientIndex]),
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}
