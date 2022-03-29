import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../story_limit_controller.dart';
import '../story_stack_controller.dart';

class Indicators extends StatefulWidget {
  const Indicators({
    Key? key,
    required this.animationController,
    required this.storyLength,
    required this.isCurrentPage,
    required this.isPaging,
    required this.padding,
  }) : super(key: key);
  final int storyLength;

  final AnimationController animationController;
  final EdgeInsetsGeometry padding;
  final bool isCurrentPage;
  final bool isPaging;

  @override
  _IndicatorsState createState() => _IndicatorsState();
}

class _IndicatorsState extends State<Indicators> {
  Animation<double>? indicatorAnimation;

  @override
  void initState() {
    super.initState();
    print('widget.animationController ${widget.animationController}');
    widget.animationController.value=0;
      widget.animationController.forward();
      indicatorAnimation =
      Tween(begin: 0.0, end: 1.0).animate(widget.animationController)
        ..addListener(() {
          setState(() {});
        });

  }

  @override
  Widget build(BuildContext context) {
    final int currentStoryIndex = context.watch<StoryStackController>().value;
    final bool isStoryEnded = context.watch<StoryLimitController>().value;
    if (!widget.isCurrentPage && widget.isPaging) {
      widget.animationController.stop();
    }
    if (!widget.isCurrentPage &&
        !widget.isPaging &&
        widget.animationController.value != 0) {
      widget.animationController.value = 0;
    }
    if (widget.isCurrentPage &&
        !widget.animationController.isAnimating &&
        !isStoryEnded) {
      widget.animationController.forward(from: 0);
    }

    return Padding(
      padding: widget.padding,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(
          widget.storyLength,
          (index) => _Indicator(
            index: index,
            value: (index == currentStoryIndex && indicatorAnimation!=null)
                ? indicatorAnimation!.value
                : (index > currentStoryIndex)
                    ? 0
                    : 1,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    widget.animationController.dispose();
  }
}
class Indicators1 extends StatefulWidget {
  const Indicators1({
    Key? key,
    required this.animationController,
    required this.storyLength,
    required this.isCurrentPage,
    required this.isPaging,
    required this.padding,
  }) : super(key: key);
  final int storyLength;

  final AnimationController animationController;
  final EdgeInsetsGeometry padding;
  final bool isCurrentPage;
  final bool isPaging;

  @override
  _Indicators1State createState() => _Indicators1State();
}

class _Indicators1State extends State<Indicators1> {
  Animation<double>? indicatorAnimation;

  @override
  void initState() {
    super.initState();
    print('widget.animationController ${widget.animationController}');
    widget.animationController.value=0;
    widget.animationController.forward();
    indicatorAnimation =
    Tween(begin: 0.0, end: 1.0).animate(widget.animationController)
      ..addListener(() {
        setState(() {});
      });

  }

  @override
  Widget build(BuildContext context) {
    final int currentStoryIndex = context.watch<StoryStackController>().value;
    final bool isStoryEnded = context.watch<StoryLimitController>().value;
    if (!widget.isCurrentPage && widget.isPaging) {
      widget.animationController.stop();
    }
    if (!widget.isCurrentPage &&
        !widget.isPaging &&
        widget.animationController.value != 0) {
      widget.animationController.value = 0;
    }
    if (widget.isCurrentPage &&
        !widget.animationController.isAnimating &&
        !isStoryEnded) {
      widget.animationController.forward(from: 0);
    }

    return Padding(
      padding: widget.padding,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(
          widget.storyLength,
              (index) => _Indicator(
            index: index,
            value: (index == currentStoryIndex && indicatorAnimation!=null)
                ? indicatorAnimation!.value
                : (index > currentStoryIndex)
                ? 0
                : 1,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    widget.animationController.dispose();
  }
}
class _Indicator extends StatelessWidget {
  const _Indicator({
    Key? key,
    required this.index,
    required this.value,
  }) : super(key: key);
  final int index;
  final double value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(left: (index == 0) ? 0 : 4),
        child: LinearProgressIndicator(
          value: value,
          backgroundColor: Colors.black.withOpacity(0.08),
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          minHeight: 2,
        ),
      ),
    );
  }
}
