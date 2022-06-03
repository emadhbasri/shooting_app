import 'package:gallery_media_picker/gallery_media_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shooting_app/classes/services/my_service.dart';
import 'package:shooting_app/ui_items/shots/index.dart';
import '../../../../main.dart';
import '../../domain/providers/notifiers/draggable_widget_notifier.dart';
import '../../domain/providers/notifiers/scroll_notifier.dart';

import '../../domain/providers/notifiers/control_provider.dart';
import '../../domain/sevices/save_as_image.dart';
import '../widgets/animated_onTap_button.dart';

class BottomTools extends StatelessWidget {
  final GlobalKey contentKey;
  final Function(String imageUri) onDone;
  final Widget? onDoneButtonStyle;

  /// editor background color
  final Color? editorBackgroundColor;
  const BottomTools(
      {Key? key,
      required this.contentKey,
      required this.onDone,
      this.onDoneButtonStyle,
      this.editorBackgroundColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;
    return Consumer3<ControlNotifier, ScrollNotifier, DraggableWidgetNotifier>(
      builder: (_, controlNotifier, scrollNotifier, itemNotifier, __) {
        return Container(
          height: 95,
          decoration: const BoxDecoration(color: Colors.transparent),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              /// preview gallery
              Container(
                width: _size.width / 3,
                height: _size.width / 3,
                padding: const EdgeInsets.only(left: 15),
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  child: _preViewContainer(
                    /// if [model.imagePath] is null/empty return preview image
                    child: controlNotifier.mediaPath.isEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: GestureDetector(
                              onTap: () {
                                /// scroll to gridView page
                                if (controlNotifier.mediaPath.isEmpty) {
                                  scrollNotifier.pageController.animateToPage(1,
                                      duration:
                                          const Duration(milliseconds: 300),
                                      curve: Curves.ease);
                                }
                              },
                              child: const CoverThumbnail(
                                thumbnailQuality: 150,
                              ),
                            ))

                        /// return clear [imagePath] provider
                        : GestureDetector(
                            onTap: () {
                              /// clear image url variable
                              controlNotifier.mediaPath = '';
                              itemNotifier.draggableWidget.removeAt(0);
                            },
                            child: Container(
                              height: 45,
                              width: 45,
                              color: Colors.transparent,
                              child: Transform.scale(
                                scale: 0.7,
                                child: const Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                  ),
                ),
              ),

              /// center logo
              controlNotifier.middleBottomWidget != null
                  ? Center(
                      child: Container(
                          width: _size.width / 3,
                          height: 80,
                          alignment: Alignment.bottomCenter,
                          child: controlNotifier.middleBottomWidget),
                    )
                  : Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Stories Creator',
                            style: TextStyle(
                                color: Colors.white38,
                                letterSpacing: 1.5,
                                fontSize: 9.2,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),

              /// save final image to gallery
              Container(
                width: _size.width / 3,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 15),
                child: Transform.scale(
                  scale: 0.9,
                  child: AnimatedOnTapButton(
                      onTap: () async {
                        debugPrint('creating image');
                        await takePicture(
                                contentKey: contentKey,
                                context: context,
                                saveToGallery: false)
                            .then((pngUri) async {
                          if (pngUri != null) {
                            MyService service = getIt<MyService>();
                            DataShortVideoStory? back =
                                await service.createStory(
                                    mediaURI: XFile(pngUri),mimeType: '.png');
                            if (back != null) {
                              Go.pop(context);
                            }
                          }
                        });

                      },
                      child: AbsorbPointer(
                        absorbing: true,
                        child: FloatingActionButton(
                          onPressed: () {},
                          heroTag: 'add story to server',
                          child: Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white,
                            // size: 15,
                          ),
                        ),
                      )),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _preViewContainer({child}) {
    return Container(
      height: 45,
      width: 45,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: 1.4, color: Colors.white)),
      child: child,
    );
  }
}
