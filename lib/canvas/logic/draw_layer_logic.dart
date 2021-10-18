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
    return Path()
      ..moveTo(start.dx, start.dy)
      ..quadraticBezierTo(
        control.dx,
        control.dy,
        end.dx,
        end.dy,
      );
  }
}

extension OffsetX on Offset {
  Offset rounded(int precision) {
    final mult = math.pow(10, precision);
    return Offset((dx * mult).toInt() / mult, (dy * mult).toInt() / mult);
  }
}
