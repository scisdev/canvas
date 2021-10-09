import 'package:bezier/bezier.dart';
import 'package:vector_math/vector_math.dart';

import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DrawLayerCubit extends Cubit<Data> {
  DrawLayerCubit(Size canvasDimensions)
      : super(
          Data(gen: 0, points: [], beziers: []),
        );

  Color selectedColor = const Color(0xffff0000);

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
      beziers.add(QuadraticBezier(
        [
          points[0].coords.toVec(),
          points[1].coords.toVec(),
          points[2].coords.toVec(),
        ],
      ));
    } else if (points.length > 3) {
      final vec = Vector2(
          (points[points.length - 2].coords.dx +
                  points[points.length - 3].coords.dx) /
              2,
          (points[points.length - 2].coords.dy +
                  points[points.length - 3].coords.dy) /
              2);
      beziers[beziers.length - 1] = (QuadraticBezier(
        [
          points[points.length - 4].coords.toVec(),
          points[points.length - 3].coords.toVec(),
          vec
        ],
      ));
      beziers.add(QuadraticBezier(
        [
          vec,
          points[points.length - 2].coords.toVec(),
          points[points.length - 1].coords.toVec(),
        ],
      ));
    }
  }
}

extension OffsetX on Offset {
  Vector2 toVec() {
    return Vector2(dx, dy);
  }
}

extension Vec2X on Vector2 {
  Offset toOffset() {
    return Offset(x, y);
  }
}
