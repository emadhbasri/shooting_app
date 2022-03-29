import 'dart:math';
import 'package:flutter/widgets.dart';

class DashPainter extends CustomPainter {
  DashPainter({
    required this.dashes,
    required this.emptyColor,
    required this.filledColor,
    required this.gapSize,
    required this.strokeWidth,
    required this.fillCount,
    required this.strokeCap,
  });

  final int dashes;
  final Color emptyColor;
  final Color filledColor;
  final double gapSize;
  final double strokeWidth;
  final int fillCount;
  final StrokeCap strokeCap;

  @override
  void paint(Canvas canvas, Size size) {
    final double gap = pi / 180 * gapSize;
    final double singleAngle = (pi * 2) / dashes;

    for (int i = 0; i < dashes; i++) {
      final Paint paint = Paint()
        ..color = i + 1 > fillCount.toDouble() ? emptyColor : filledColor
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke
        ..strokeCap = strokeCap;

      canvas.drawArc(
        Offset.zero & size,
        gap + singleAngle * i,
        singleAngle - gap * 2,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(DashPainter oldDelegate) {
    return dashes != oldDelegate.dashes || emptyColor != oldDelegate.emptyColor;
  }
}