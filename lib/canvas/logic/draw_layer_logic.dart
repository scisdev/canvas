import 'dart:math' as math;

import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DrawLayerCubit extends Cubit<Data> {
  DrawLayerCubit(Size canvasDimensions)
      : super(
          Data(gen: 0, points: [], beziers: []),
        );

  Color selectedColor = const Color(0xffff0000);
  int strokeWidth = 5;

  void addPoint(Offset coords) {
    state.addPoint(Point(color: selectedColor, coords: coords));
    emit(state.next());
  }
}

class Point {
  final Offset coords;
  final Color color;

  Point({
    required this.coords,
    required this.color,
  });
}

class Data {
  final int gen;
  List<Point> points = [];
  List<Bezier> beziers = [];

  Data({
    required this.gen,
    required this.points,
    required this.beziers,
  });

  Data next() {
    return Data(points: points, beziers: beziers, gen: gen + 1);
  }

  void addPoint(Point point) {
    points.add(point);
    if (points.length == 3) {
      beziers.add(Bezier(
        points[0].coords,
        points[1].coords,
        points[2].coords,
        15,
        15,
      ));
    } else if (points.length > 3) {
      points.insert(
        points.length - 2,
        Point(
          coords: Offset(
              (points[points.length - 2].coords.dx +
                      points[points.length - 3].coords.dx) /
                  2,
              (points[points.length - 2].coords.dy +
                      points[points.length - 3].coords.dy) /
                  2),
          color: const Color(0xffff0000),
        ),
      );

      beziers[beziers.length - 1] = Bezier(
        points[points.length - 5].coords,
        points[points.length - 4].coords,
        points[points.length - 3].coords,
        15,
        15,
      );

      beziers.add(Bezier(
        points[points.length - 3].coords,
        points[points.length - 2].coords,
        points[points.length - 1].coords,
        15,
        15,
      ));
    }
  }
}

abstract class CanvasDrawElement {
  Path getDrawPath();
}

class Line extends CanvasDrawElement {
  @override
  Path getDrawPath() {
    return Path();
  }
}

class Bezier extends CanvasDrawElement {
  final Offset start;
  final Offset control;
  final Offset end;
  final int startThickness;
  final int endThickness;

  Bezier(
    this.start,
    this.control,
    this.end,
    this.startThickness,
    this.endThickness,
  );

  @override
  Path getDrawPath() {
    //let f1(x) be normal of bezier at t=0
    //let f2(x) be normal of bezier at t=1

    //find (f1(x) = a1*x + b1) and (f2(x) = a2*x+b2)
    final a1 = -(control.dx - start.dx) / (control.dy - start.dy);
    final a2 = -(end.dx - control.dx) / (end.dy - control.dy);
    final b1 = start.dy - a1 * start.dx;
    final b2 = end.dy - a2 * end.dx;

    if (a1.isNaN || a2.isNaN || a1.isInfinite || a2.isInfinite || a1 == a2) {
      //this bezier has degraded to some straight line

      if (a1 == 0.0) {}

      //todo return a straight line with varying thickness
    }

    //find end points of 'thickness'
    final deltaX1 =
        math.sqrt(startThickness * startThickness / (4 * (1 + a1 * a1)));
    final deltaX2 =
        math.sqrt(endThickness * endThickness / (4 * (1 + a2 * a2)));
    final y1Plus = a1 * (start.dx + deltaX1) + b1;
    final y2Plus = a2 * (end.dx + deltaX2) + b2;
    final y1Minus = a1 * (start.dx - deltaX1) + b1;
    final y2Minus = a2 * (end.dx - deltaX2) + b2;

    //find intersection of f1 and f2
    final xCross = (b2 - b1) / (a1 - a2);
    final yCross = a1 * xCross + b1;

    //find control points of 'thickness'
    final ac = (control.dy - yCross) / (control.dx - xCross);
    final bc = control.dy - ac * control.dx;

    final averageThickness = (endThickness + startThickness) >> 1;

    final deltaXc =
        math.sqrt(averageThickness * averageThickness / (4 * (1 + ac * ac)));
    final ycPlus = ac * (control.dx + deltaXc) + bc;
    final ycMinus = ac * (control.dx - deltaXc) + bc;

    return Path()
      ..moveTo(start.dx - deltaX1, y1Minus)
      ..lineTo(start.dx + deltaX1, y1Plus)
      ..quadraticBezierTo(
        control.dx + deltaXc,
        ycPlus,
        end.dx + deltaX2,
        y2Plus,
      )
      ..lineTo(end.dx - deltaX2, y2Minus)
      ..quadraticBezierTo(
        control.dx - deltaXc,
        ycMinus,
        start.dx - deltaX1,
        y1Minus,
      )
      ..close();
  }
}

extension OffsetX on Offset {
  Offset rounded(int precision) {
    final mult = math.pow(10, precision);
    return Offset((dx * mult).toInt() / mult, (dy * mult).toInt() / mult);
  }
}
