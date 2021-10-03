import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Line {
  final Offset begin;
  final Offset end;
  final Color color;
  final double strokeWidth;

  Line({
    required this.begin,
    required this.end,
    required this.color,
    required this.strokeWidth,
  });
}

class LinesState {
  final List<Line> lines;

  LinesState(this.lines);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LinesState &&
          runtimeType == other.runtimeType &&
          lines == other.lines;

  @override
  int get hashCode => lines.hashCode;
}

class LinePainterCubit extends Cubit<LinesState> {
  Color chosenColor = Colors.black;
  double chosenStrokeWidth = 7;

  LinePainterCubit() : super(LinesState([]));

  void addLine(Offset begin, Offset end) {
    emit(
      LinesState(
        [
          ...state.lines,
          Line(
            color: chosenColor,
            strokeWidth: chosenStrokeWidth,
            begin: begin,
            end: end,
          ),
        ],
      ),
    );
  }

  void addPoint(Offset point) {
    emit(
      LinesState(
        [
          ...state.lines,
          Line(
            color: chosenColor,
            strokeWidth: chosenStrokeWidth,
            begin: point,
            end: point,
          ),
        ],
      ),
    );
  }
}
