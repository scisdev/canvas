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

  String toSvg(Size canvasSize) {
    StringBuffer sb = StringBuffer();

    sb.write(
        '<path stroke-linecap="round" fill="none" d="M ${lines[0].begin.dx}, ${lines[0].begin.dy} " stroke-width="${lines[0].strokeWidth}" stroke="#${lines[0].color.toSvgValue}">');

    for (final line in lines) {
      sb.write('<path fill="none" stroke-linecap="round" '
          'd="M ${line.begin.dx}, ${line.begin.dy} L ${line.end.dx}, ${line.end.dy} " '
          'stroke-width="${line.strokeWidth}" '
          'stroke="#${line.color.toSvgValue}">');
    }

    return '''<svg width="${canvasSize.width}" height="${canvasSize.height}" viewBox="0 0 ${canvasSize.width} ${canvasSize.height}" fill="none" xmlns="http://www.w3.org/2000/svg">
${sb.toString()}
</svg>''';
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    if (oldDelegate is! LinesPainter) return true;

    return lines.length != oldDelegate.lines.length;
  }
}

extension ColorX on Color {
  String get toSvgValue {
    return value.toRadixString(16).toUpperCase();
  }
}
