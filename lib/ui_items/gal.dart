import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:shooting_app/classes/functions.dart';
// ...
class Gal extends StatefulWidget {
  const Gal({Key? key,required this.images}) : super(key: key);
  final List<String> images;
  @override
  _GalState createState() => _GalState();
}

class _GalState extends State<Gal> {
  @override
  Widget build(BuildContext context) {
    print('images ${widget.images}');
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: (){
            Go.pop(context);
          },
          icon: Icon(Icons.arrow_back,color: Colors.white,),
        ),
      ),
        body: PhotoViewGallery.builder(
          enableRotation: false,
          scrollPhysics: const BouncingScrollPhysics(),
          builder: (BuildContext context, int index) {
            return PhotoViewGalleryPageOptions(
minScale: 0.3,
              maxScale: 2.0,
              imageProvider: networkImage(widget.images[index]),
              initialScale: PhotoViewComputedScale.contained * 0.8,
              // heroAttributes: PhotoViewHeroAttributes(tag: galleryItems[index].id),
            );
          },
          itemCount: widget.images.length,
          loadingBuilder: (context, event) => Center(
            child: simpleCircle(),
          ),
          // backgroundDecoration: widget.backgroundDecoration,
          // pageController: widget.pageController,
          // onPageChanged: onPageChanged,
        )
    );
  }
}


