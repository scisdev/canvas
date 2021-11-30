import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class DrawLayer extends StatefulWidget {
  const DrawLayer({Key? key}) : super(key: key);

  @override
  State<DrawLayer> createState() => _DrawLayerState();
}

class _DrawLayerState extends State<DrawLayer> {
  PaintDescription pd = const PaintDescription(
    widthBase: 10,
    maskFilter: MaskFilter.blur(BlurStyle.solid, 5.0),
    color: Colors.yellowAccent,
    type: LineType.marker,
  );
  final paint = Paint();

  bool skip = false;
  final lines = <Line>[];

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 50,
            child: Material(
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      child: SizedBox.expand(
                        child: IconButton(
                          icon: const Icon(Icons.settings_backup_restore),
                          onPressed: () {
                            if (lines.isNotEmpty) {
                              setState(() {
                                lines.removeLast();
                              });
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      child: SizedBox.expand(
                        child: IconButton(
                          icon: Text(
                            'MARKER',
                            style: TextStyle(
                              fontSize: 16,
                              color: pd.type == LineType.marker
                                  ? Colors.red
                                  : Colors.black,
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              pd = pd.copyWith(type: LineType.marker);
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      child: SizedBox.expand(
                        child: IconButton(
                          icon: Text(
                            'ERASER',
                            style: TextStyle(
                              fontSize: 16,
                              color: pd.type == LineType.eraser
                                  ? Colors.red
                                  : Colors.black,
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              pd = pd.copyWith(type: LineType.eraser);
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onPanStart: onDown,
              onPanUpdate: onMove,
              onPanEnd: onUp,
              child: SizedBox.expand(
                child: CustomPaint(
                  isComplex: true,
                  painter: TestPainter(paint, lines),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void onDown(DragStartDetails event) {
    lines.add(Line(
      pd: pd,
      points: [event.localPosition],
    ));

    setState(() {});
  }

  void onMove(DragUpdateDetails event) {
    if (skip) {
      skip = false;
      return;
    } else {
      skip = true;
    }

    lines[lines.length - 1].points.add(event.localPosition);
    setState(() {});
  }

  void onUp(DragEndDetails event) {
    setState(() {});
  }
}

class TestPainter extends CustomPainter {
  final List<Line> lines;
  final Paint p;

  TestPainter(this.p, this.lines);

  @override
  void paint(Canvas canvas, Size size) {
    for (final line in lines) {
      p
        ..strokeWidth = line.pd.widthBase
        ..maskFilter = line.pd.maskFilter
        ..color = line.pd.color
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..blendMode = line.pd.type == LineType.marker
            ? BlendMode.srcOver
            : BlendMode.dstOut;

      if (line.points.length == 1) {
        canvas.drawPoints(
          PointMode.points,
          [line.points[0]],
          p,
        );
        continue;
      }

      final path = Path();
      for (var i = 0; i < line.points.length - 2; i++) {
        final p1 = (line.points[i] + line.points[i + 1]) / 2;
        final p2 = (line.points[i + 1] + line.points[i + 2]) / 2;
        path.moveTo(p1.dx, p1.dy);
        path.quadraticBezierTo(
          line.points[i + 1].dx,
          line.points[i + 1].dy,
          p2.dx,
          p2.dy,
        );
      }

      canvas.drawPath(path, p);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class Line {
  final PaintDescription pd;
  final List<Offset> points;

  Line({
    required this.points,
    required this.pd,
  });
}

enum LineType { marker, eraser }

class PaintDescription {
  final LineType type;
  final Color color;
  final MaskFilter maskFilter;
  final double widthBase;

  const PaintDescription({
    required this.type,
    required this.color,
    required this.maskFilter,
    required this.widthBase,
  });

  PaintDescription copyWith({
    LineType? type,
    Color? color,
    MaskFilter? maskFilter,
    double? widthBase,
  }) {
    return PaintDescription(
      type: type ?? this.type,
      color: color ?? this.color,
      maskFilter: maskFilter ?? this.maskFilter,
      widthBase: widthBase ?? this.widthBase,
    );
  }
}
