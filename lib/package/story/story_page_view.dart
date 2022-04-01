import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shooting_app/classes/services/my_service.dart';
import 'package:shooting_app/pages/profile/profile.dart';
import 'package:shooting_app/ui_items/shots/index.dart';
import 'package:video_player/video_player.dart';

import '../../classes/functions.dart';
import '../../classes/models.dart';
import '../../main.dart';
import 'components/indicators.dart';
import 'story_limit_controller.dart';
import 'story_stack_controller.dart';

typedef _StoryItemBuilder = Widget Function(
  BuildContext context,
  int pageIndex,
  int storyIndex,
);

typedef _StoryConfigFunction = int Function(int pageIndex);

enum IndicatorAnimationCommand { pause, resume }

/// PageView to implement story like UI
///
/// [itemBuilder], [storyLength], [pageLength] are required.
class StoryPageView extends StatefulWidget {
  StoryPageView({
    Key? key,
    required this.storyUsers,
    required this.storyLength,
    required this.pageLength,
    this.gestureItemBuilder,
    this.initialStoryIndex,
    this.initialPage = 0,
    this.onPageLimitReached,
    this.indicatorDuration = const Duration(seconds: 5),
    this.indicatorPadding =
        const EdgeInsets.symmetric(vertical: 32, horizontal: 8),
    this.backgroundColor = Colors.black,
    this.indicatorAnimationController,
    this.onPageChanged,
  }) : super(key: key);
  final List<DataStoryUser> storyUsers;

  /// Function to build story content

  /// Function to build story content
  /// Components with gesture actions are expected
  /// Placed above the story gestures.
  final _StoryItemBuilder? gestureItemBuilder;

  /// decides length of story for each page
  final _StoryConfigFunction storyLength;

  /// length of [StoryPageView]
  final int pageLength;

  /// Initial index of story for each page
  final _StoryConfigFunction? initialStoryIndex;

  /// padding of [Indicators]
  final EdgeInsetsGeometry indicatorPadding;

  /// duration of [Indicators]
  final Duration indicatorDuration;

  /// Called when the very last story is finished.
  ///
  /// Functions like "Navigator.pop(context)" is expected.
  final VoidCallback? onPageLimitReached;

  /// Called whenever the page in the center of the viewport changes.
  final void Function(int)? onPageChanged;

  /// initial index for [StoryPageView]
  final int initialPage;

  /// Color under the Stories which is visible when the cube transition is in progress
  final Color backgroundColor;

  /// A stream with [IndicatorAnimationCommand] to force pause or continue inticator animation
  /// Useful when you need to show any popup over the story
  final ValueNotifier<IndicatorAnimationCommand>? indicatorAnimationController;

  @override
  _StoryPageViewState createState() => _StoryPageViewState();
}

class _StoryPageViewState extends State<StoryPageView> {
  PageController? pageController;

  var currentPageValue;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: widget.initialPage);

    currentPageValue = widget.initialPage.toDouble();

    pageController!.addListener(() {
      setState(() {
        currentPageValue = pageController!.page;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: widget.backgroundColor,
      child: PageView.builder(
        controller: pageController,
        itemCount: widget.pageLength,
        onPageChanged: widget.onPageChanged,
        itemBuilder: (context, index) {
          final isLeaving = (index - currentPageValue) <= 0;
          final t = (index - currentPageValue);
          final rotationY = lerpDouble(0, 30, t as double)!;
          final maxOpacity = 0.8;
          final num opacity =
              lerpDouble(0, maxOpacity, t.abs())!.clamp(0.0, maxOpacity);
          final isPaging = opacity != maxOpacity;
          final transform = Matrix4.identity();
          transform.setEntry(3, 2, 0.003);
          transform.rotateY(-rotationY * (pi / 180.0));
          return Transform(
            alignment: isLeaving ? Alignment.centerRight : Alignment.centerLeft,
            transform: transform,
            child: Stack(
              children: [
                _StoryPageFrame.wrapped(
                  storyUsers: widget.storyUsers,
                  pageLength: widget.pageLength,
                  storyLength: widget.storyLength(index),
                  initialStoryIndex: widget.initialStoryIndex?.call(index) ?? 0,
                  pageIndex: index,
                  animateToPage: (index) {
                    pageController!.animateToPage(index,
                        duration: Duration(milliseconds: 500),
                        curve: Curves.ease);
                  },
                  isCurrentPage: currentPageValue == index,
                  isPaging: isPaging,
                  onPageLimitReached: widget.onPageLimitReached,
                  gestureItemBuilder: widget.gestureItemBuilder,
                  indicatorDuration: widget.indicatorDuration,
                  indicatorPadding: widget.indicatorPadding,
                  indicatorAnimationController:
                      widget.indicatorAnimationController,
                ),
                if (isPaging && !isLeaving)
                  Positioned.fill(
                    child: Opacity(
                      opacity: opacity as double,
                      child: ColoredBox(
                        color: Colors.black87,
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _StoryPageFrame extends StatefulWidget {
  const _StoryPageFrame._({
    Key? key,
    required this.storyLength,
    required this.initialStoryIndex,
    required this.pageIndex,
    required this.isCurrentPage,
    required this.isPaging,
    required this.gestureItemBuilder,
    required this.indicatorDuration,
    required this.indicatorPadding,
    required this.indicatorAnimationController,
    required this.storyUsers,
  }) : super(key: key);
  final int storyLength;
  final int initialStoryIndex;
  final int pageIndex;
  final bool isCurrentPage;
  final bool isPaging;
  final _StoryItemBuilder? gestureItemBuilder;
  final Duration indicatorDuration;
  final EdgeInsetsGeometry indicatorPadding;
  final ValueNotifier<IndicatorAnimationCommand>? indicatorAnimationController;
  final List<DataStoryUser> storyUsers;
  static Widget wrapped({
    required int pageIndex,
    required int pageLength,
    required ValueChanged<int> animateToPage,
    required int storyLength,
    required int initialStoryIndex,
    required bool isCurrentPage,
    required List<DataStoryUser> storyUsers,
    required bool isPaging,
    required VoidCallback? onPageLimitReached,
    _StoryItemBuilder? gestureItemBuilder,
    required Duration indicatorDuration,
    required EdgeInsetsGeometry indicatorPadding,
    required ValueNotifier<IndicatorAnimationCommand>?
        indicatorAnimationController,
  }) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_context) => StoryLimitController(),
        ),
        ChangeNotifierProvider(
          create: (_context) => StoryStackController(
            storyLength: storyLength,
            onPageBack: () {
              if (pageIndex != 0) {
                animateToPage(pageIndex - 1);
              }
            },
            onPageForward: () {
              if (pageIndex == pageLength - 1) {
                _context
                    .read<StoryLimitController>()
                    .onPageLimitReached(onPageLimitReached);
              } else {
                animateToPage(pageIndex + 1);
              }
            },
            initialStoryIndex: initialStoryIndex,
          ),
        ),
      ],
      child: _StoryPageFrame._(
        storyUsers: storyUsers,
        storyLength: storyLength,
        initialStoryIndex: initialStoryIndex,
        pageIndex: pageIndex,
        isCurrentPage: isCurrentPage,
        isPaging: isPaging,
        gestureItemBuilder: gestureItemBuilder,
        indicatorDuration: indicatorDuration,
        indicatorPadding: indicatorPadding,
        indicatorAnimationController: indicatorAnimationController,
      ),
    );
  }

  @override
  _StoryPageFrameState createState() => _StoryPageFrameState();
}

class DataVideoId {
  VideoPlayerController video;
  String id;

  DataVideoId(this.video, this.id);
}

class _StoryPageFrameState extends State<_StoryPageFrame>
    with
        AutomaticKeepAliveClientMixin<_StoryPageFrame>,
        TickerProviderStateMixin {
  late AnimationController animationController;
  List<DataVideoId> videoList = [];
  late VoidCallback listener;
  bool loadingVideo = false;
  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: widget.indicatorDuration,
    )..addStatusListener(
        (status) {
          if (status == AnimationStatus.completed) {
            context.read<StoryStackController>().increment(
                restartAnimation: () => animationController.forward(from: 0));
          }
        },
      );
  }

  @override
  void dispose() {
    for (int j = 0; j < videoList.length; j++) {
      if (videoList[j].video.value.isInitialized) videoList[j].video.dispose();
    }

    super.dispose();
  }

  initializing(List allStories) async {
    for (int j = 0; j < allStories.length; j++) {
      if (allStories[j].mimeType == '.mp4') {
        print('allStories[j].mediaURL ${allStories[j].mediaURL}');
        VideoPlayerController vide = VideoPlayerController.network(
            allStories[j].mediaURL);
        await vide.initialize();
        videoList.add(DataVideoId(
            vide,allStories[j].id));
      }
    }
  }

  int storyIndex = 0;
  initVideo(VideoPlayerController videoPlayerController) async {
    await videoPlayerController.play();
  }
MyService service = getIt<MyService>();
  @override
  Widget build(BuildContext context) {
    super.build(context);
    DataStoryUser user = widget.storyUsers[widget.pageIndex];
    List<DataStory> allStories = [
      ...user.seen,
      ...user.notSeen,
    ];
    if (videoList.isEmpty) initializing(allStories);

    DataStory story = allStories[context.watch<StoryStackController>().value];
    service.reachStory(story.id);
    int index = -1;
    if (story.mimeType == '.mp4') {
      index = videoList.indexWhere((element) => element.id == story.id);
      if (index!=-1 && videoList[index].video.value.isPlaying == false)
        videoList[index].video.play();
    }
    return Stack(
      fit: StackFit.loose,
      alignment: Alignment.topLeft,
      children: [
        Positioned.fill(
          child: ColoredBox(
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
        ),
        Positioned.fill(
          child: Stack(
            children: [
              Positioned.fill(
                child: Container(color: Colors.black),
              ),
              Positioned.fill(
                child: Builder(
                  builder: (context) {
                    if (story.mimeType == '.mp4') {
                      if (loadingVideo) {
                        return Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const CircularProgressIndicator(
                                backgroundColor: Colors.red,
                              ),
                              SizedBox(height: doubleHeight(1)),
                              const Text(
                                'loading ...',
                                textDirection: TextDirection.ltr,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        );
                      }
                      if(index!=-1)
                      return Center(
                        child: AspectRatio(
                          aspectRatio: videoList[index].video.value.aspectRatio,
                          child: VideoPlayer(videoList[index].video),
                        ),
                      );
                      else return const SizedBox();
                    } else {
                      return imageNetwork(
                        story.mediaURL,
                        fit: BoxFit.contain,
                      );
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 44, left: 8),
                child: GestureDetector(
                  onTap: (){
                    Go.pushSlideAnim(context, ProfileBuilder(username: user.person.userName));
                  },
                  child: Row(
                    children: [
                      Container(
                        height: 32,
                        width: 32,
                        decoration: BoxDecoration(
                          image: user.person.profilePhoto == null
                              ? null
                              : DecorationImage(
                                  image: networkImage(user.person.profilePhoto!),
                                  fit: BoxFit.contain,
                                ),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(
                        user.person.fullName ?? '',
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 50,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 10,
                blurRadius: 20,
              ),
            ],
          ),
        ),
        // storyIndex RepaintBoundary
        Builder(builder: (context) {
          return Indicators(
            storyLength: widget.storyLength,
            animationController: animationController,
            isCurrentPage: widget.isCurrentPage,
            isPaging: widget.isPaging,
            padding: widget.indicatorPadding,
          );
        }),
        Builder(builder: (context) {
            return Padding(
              padding: EdgeInsets.only(top: doubleHeight(12)),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      color: Colors.transparent,
                      child: GestureDetector(
                        onTap: () {
                          animationController.forward(from: 0);
                          if(story.mimeType == '.mp4'){
                            videoList[index].video.pause();
                            videoList[index].video.seekTo(Duration(seconds: 0));
                            // int indN = index-1;
                            // int indV = context.watch<StoryStackController>().value-1;
                            // if(indV>=0 && allStories[indV].mimeType=='.mp4' && indN>=0){
                            //
                            // }
                          }

                          context.read<StoryStackController>().decrement();
                        },
                        onLongPress: () {
                          if (story.mimeType == '.mp4') {
                            videoList[index].video.pause();
                          }
                          animationController.stop();
                        },
                        onLongPressUp: () {
                          if (story.mimeType == '.mp4') {
                            videoList[index].video.play();
                          }
                          animationController.forward();
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
                            restartAnimation: (){
                              animationController
                                      .forward(from: 0);
                              if (story.mimeType == '.mp4'){
                                videoList[index].video.pause();
                                videoList[index].video.seekTo(Duration(seconds: 0));
                              }

                                },
                            completeAnimation: ()
                            {
                              animationController.value = 1;
                              if (story.mimeType == '.mp4'){
                                videoList[index].video.pause();
                                videoList[index].video.seekTo(Duration(seconds: videoList[index].video.value.duration.inSeconds));
                              }

                            },

                          );
                        },
                        onLongPress: () {
                          if (story.mimeType == '.mp4') {
                            videoList[index].video.pause();
                          }
                          animationController.stop();
                        },
                        onLongPressUp: () {
                          if (story.mimeType == '.mp4') {
                            videoList[index].video.play();
                          }
                          animationController.forward();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            );
        }),
        Positioned.fill(
          child: widget.gestureItemBuilder?.call(
                context,
                widget.pageIndex,
                context.watch<StoryStackController>().value,
              ) ??
              const SizedBox.shrink(),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
