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
  double currentThickness = 10.0;
  Color currentColor = Colors.cyanAccent;
  int? currentPointerId;
  LineType currentLineType = LineType.marker;
  Line tmpLine = Line.marker();

  String text = 'LINE';
  final thicknessDelta = .01;
  final points = <Offset>[];
  final lines = <Line>[];

  Paint get currentPaint {
    return Paint()
      ..color = currentColor
      ..strokeWidth = currentThickness
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
  }

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
                              color: currentLineType == LineType.marker
                                  ? Colors.red
                                  : Colors.black,
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              currentLineType = LineType.marker;
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
                              color: currentLineType == LineType.eraser
                                  ? Colors.red
                                  : Colors.black,
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              currentLineType = LineType.eraser;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(text),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Listener(
              behavior: HitTestBehavior.opaque,
              onPointerDown: onDown,
              onPointerMove: onMove,
              onPointerUp: onUp,
              child: SizedBox.expand(
                child: CustomPaint(
                  isComplex: true,
                  painter: TestPainter(lines, tmpLine),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void onDown(PointerDownEvent event) {
    if (currentPointerId != null) return;

    currentPointerId = event.pointer;
    points.add(event.localPosition);
    lines.add(
      Line(
        path: Path()..moveTo(event.localPosition.dx, event.localPosition.dy),
        paint: currentPaint,
        type: currentLineType,
      ),
    );

    setState(() {});
  }

  void onMove(PointerMoveEvent event) {
    if (event.pointer != currentPointerId) return;

    points.add(event.localPosition);

    final dst = (points[points.length - 2] - event.localPosition).distance;

    if (dst > 2.5) {
      addBezier();
      text = 'BEZIER';
    } else {
      addLine();
      text = 'LINE';
    }

    setState(() {});
  }

  void addLine() {
    lines[lines.length - 1].path.lineTo(
          points[points.length - 1].dx,
          points[points.length - 1].dy,
        );

    tmpLine = Line(path: Path(), paint: currentPaint, type: currentLineType);
  }

  void addBezier() {
    if (points.length < 3) return;

    if (points.length == 3) {
      tmpLine = Line(
        path: Path()
          ..moveTo(points[0].dx, points[0].dy)
          ..quadraticBezierTo(
            points[1].dx,
            points[1].dy,
            points[2].dx,
            points[2].dy,
          ),
        paint: currentPaint,
      );
      return;
    }

    points.insert(
      points.length - 2,
      Offset(
        (points[points.length - 2].dx + points[points.length - 3].dx) / 2,
        (points[points.length - 2].dy + points[points.length - 3].dy) / 2,
      ),
    );

    //lines[lines.length - 1].path.addPath(tmpLine.path, Offset.zero);
    lines[lines.length - 1].path.moveTo(
          points[points.length - 5].dx,
          points[points.length - 5].dy,
        );
    lines[lines.length - 1].path.quadraticBezierTo(
          points[points.length - 4].dx,
          points[points.length - 4].dy,
          points[points.length - 3].dx,
          points[points.length - 3].dy,
        );

    tmpLine = Line(
      path: Path()
        ..moveTo(
          points[points.length - 3].dx,
          points[points.length - 3].dy,
        )
        ..quadraticBezierTo(
          points[points.length - 2].dx,
          points[points.length - 2].dy,
          points[points.length - 1].dx,
          points[points.length - 1].dy,
        ),
      paint: currentPaint,
      type: currentLineType,
    );
  }

  void onUp(PointerUpEvent event) {
    if (currentPointerId != event.pointer) return;

    lines[lines.length - 1].path.addPath(tmpLine.path, Offset.zero);
    tmpLine = Line.marker();
    currentPointerId = null;
    points.clear();
    setState(() {});
    //lines.clear();
  }
}

class TestPainter extends CustomPainter {
  final List<Line> lines;
  final Line tmpLine;

  TestPainter(this.lines, this.tmpLine);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPath(tmpLine.path, tmpLine.paint);
    for (final l in lines) {
      canvas.drawPath(l.path, l.paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class Line {
  final Path path;
  final Paint paint;
  final LineType? type;

  Line({
    required this.path,
    required this.paint,
    this.type,
  });

  factory Line.empty() {
    return Line(path: Path(), paint: Paint());
  }

  factory Line.marker() {
    return Line(path: Path(), paint: Paint(), type: LineType.marker);
  }

  factory Line.eraser() {
    return Line(path: Path(), paint: Paint(), type: LineType.eraser);
  }
}

enum LineType { marker, eraser }
