import 'dart:ui';

import 'package:canvas/canvas/logic/draw_layer_logic.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DrawLayer extends StatefulWidget {
  const DrawLayer({Key? key}) : super(key: key);

  @override
  State<DrawLayer> createState() => _DrawLayerState();
}

class _DrawLayerState extends State<DrawLayer> {
  double currentThickness = 10.0;
  Color currentColor = Colors.cyanAccent;

  final thicknessDelta = .01;
  final points = <Offset>[];
  //final lines = <Line>[];
  final paths = <Path>[];

  Paint get currentPaint {
    return Paint()
      ..color = currentColor
      ..strokeWidth = currentThickness
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) => DrawLayerCubit(
        MediaQuery.of(context).size,
      ),
      child: BlocBuilder<DrawLayerCubit, Data>(
        builder: (ctx, state) => Listener(
          behavior: HitTestBehavior.opaque,
          child: SizedBox.expand(
            child: CustomPaint(
              isComplex: true,
              painter: TestPainter(paths),
            ),
          ),
          onPointerDown: onDown,
          onPointerMove: onMove,
          onPointerUp: onUp,
        ),
      ),
    );
  }

  void onDown(PointerDownEvent event) {
    /*lines.add(Line(
      bezier: Bezier.zero(),
      paint: currentPaint,
    ));*/

    points.add(event.localPosition);
    paths.add(Path()..moveTo(event.localPosition.dx, event.localPosition.dy));

    setState(() {});
  }

  void onMove(PointerMoveEvent event) {
    points.add(event.localPosition);

    if (points.length < 3) return;

    if (points.length == 3) {
      /*lines[lines.length - 1].bezier = Bezier(
        start: points[0],
        control: points[1],
        end: points[2],
      );*/
      paths[paths.length - 1].moveTo(points[0].dx, points[0].dy);
      paths[paths.length - 1].quadraticBezierTo(
        points[1].dx,
        points[1].dy,
        points[2].dx,
        points[2].dy,
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

    paths[paths.length - 1].moveTo(
      points[points.length - 5].dx,
      points[points.length - 5].dy,
    );
    paths[paths.length - 1].quadraticBezierTo(
      points[points.length - 4].dx,
      points[points.length - 4].dy,
      points[points.length - 3].dx,
      points[points.length - 3].dy,
    );

    paths[paths.length - 1].moveTo(
      points[points.length - 3].dx,
      points[points.length - 3].dy,
    );
    paths[paths.length - 1].quadraticBezierTo(
      points[points.length - 2].dx,
      points[points.length - 2].dy,
      points[points.length - 1].dx,
      points[points.length - 1].dy,
    );

    /*lines.removeLast();

    lines.add(
      Line(
        bezier: Bezier(
          start: points[points.length - 5],
          control: points[points.length - 4],
          end: points[points.length - 3],
        ),
        paint: currentPaint,
      ),
    );

    lines.add(
      Line(
        bezier: Bezier(
          start: points[points.length - 3],
          control: points[points.length - 2],
          end: points[points.length - 1],
        ),
        paint: currentPaint,
      ),
    );*/

    /*lines[lines.length - 1].bezier.moveTo(
          points[points.length - 5].dx,
          points[points.length - 5].dy,
        );

    lines[lines.length - 1].path.quadraticBezierTo(
          points[points.length - 4].dx,
          points[points.length - 4].dy,
          points[points.length - 3].dx,
          points[points.length - 3].dy,
        );

    lines[lines.length - 1].path.moveTo(
          points[points.length - 3].dx,
          points[points.length - 3].dy,
        );

    lines[lines.length - 1].path.quadraticBezierTo(
          points[points.length - 2].dx,
          points[points.length - 2].dy,
          points[points.length - 1].dx,
          points[points.length - 1].dy,
        );*/

    setState(() {});
  }

  void onUp(PointerUpEvent event) {
    points.clear();
    setState(() {});
    //lines.clear();
  }
}

class TestPainter extends CustomPainter {
  final List<Path> paths;

  TestPainter(this.paths);

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in paths) {
      canvas.drawPath(
        p,
        Paint()
          ..color = Colors.red
          ..style = PaintingStyle.stroke
          ..strokeWidth = 10,
      );
    }
    /*final p = Path();
    canvas.restore();
    for (final l in lines) {
      canvas.drawPath(l.bezier.getPath(), l.paint);
    }
    canvas.save();*/
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class Bezier {
  final Offset start;
  final Offset control;
  final Offset end;

  Bezier({
    required this.start,
    required this.control,
    required this.end,
  });

  factory Bezier.zero() {
    return Bezier(start: Offset.zero, control: Offset.zero, end: Offset.zero);
  }

  Path getPath() {
    return Path()
      ..moveTo(start.dx, start.dy)
      ..quadraticBezierTo(control.dx, control.dy, end.dx, end.dy);
  }
}

class Line {
  Bezier bezier;
  final Paint paint;

  Line({
    required this.bezier,
    required this.paint,
  });
}
