import 'package:flutter/material.dart';
import 'dash_painter.dart';

class DashedColorCircle extends StatelessWidget {
  /// Adding [dashes] will increase the dash count, but
  /// if you add too many, you might have to change the
  /// [gapSize] which would move the dashes further away from
  /// each other.
  /// [emptyColor] represents the default color of the dashes.
  /// If you declare [fillCount] together with [filledColor]
  /// you would get the amount of dashes with [fillColor] in the
  /// specified color.
  const DashedColorCircle({
    Key? key,
    required this.child,
    this.dashes = 3,
    this.emptyColor = Colors.grey,
    this.filledColor = Colors.black,
    this.gapSize = 24.0,
    this.strokeWidth = 8.0,
    this.size = 24.0,
    this.fillCount = 0.0,
    this.strokeCap = StrokeCap.round,
  }) : super(key: key);
  final Widget child;
  /// The count of dashes to be displayed
  final int dashes;

  /// The default color of the dashes
  final Color emptyColor;

  /// The color of the filled dashes. This will be equivalent to the [fillCount]
  final Color filledColor;

  /// Distance between two dashes
  final double gapSize;

  /// Width of the dashes
  final double strokeWidth;

  /// Total size of the circle (width, height together)
  final double size;

  /// Count of dashes to be colored with [filledColor]
  final double fillCount;

  /// [StrokeCap] for the dash style
  final StrokeCap strokeCap;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: DashPainter(
        dashes: dashes,
        emptyColor: emptyColor,
        filledColor: filledColor,
        gapSize: gapSize,
        strokeWidth: strokeWidth,
        fillCount: fillCount,
        strokeCap: strokeCap,
      ),
      child: child,
    );
  }
}