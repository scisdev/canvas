import 'dart:ui';

import 'package:canvas/canvas/canvas.dart';
import 'package:flutter/material.dart';

class LinesPainter extends CustomPainter {
  final List<Line> lines;

  LinesPainter(this.lines);

  @override
  void paint(Canvas canvas, Size size) {
    print('painting ${lines.length} lines');

    for (final line in lines) {
      final paint = Paint()
        ..color = line.color
        ..strokeWidth = line.strokeWidth
        ..strokeCap = StrokeCap.round;

      if (line.begin == line.end) {
        canvas.drawPoints(
          PointMode.points,
          [line.begin],
          paint,
        );
      }
      canvas.drawLine(
        line.begin,
        line.end,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    if (oldDelegate is! LinesPainter) return true;

    return lines.length != oldDelegate.lines.length;
  }
}
