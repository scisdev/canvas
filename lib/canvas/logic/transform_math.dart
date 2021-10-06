import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TransformState {
  final Offset translation;
  final double rotationAngle;
  final double scale;

  TransformState({
    required this.translation,
    required this.rotationAngle,
    required this.scale,
  });

  TransformState copyWith({
    double? rotationAngle,
    Offset? translation,
    double? scale,
  }) {
    return TransformState(
      rotationAngle: rotationAngle ?? this.rotationAngle,
      translation: translation ?? this.translation,
      scale: scale ?? this.scale,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is TransformState &&
      runtimeType == other.runtimeType &&
      translation == other.translation &&
      rotationAngle == other.rotationAngle &&
      scale == other.scale;

  @override
  int get hashCode =>
      translation.hashCode ^ rotationAngle.hashCode ^ scale.hashCode;

  @override
  String toString() {
    return 'TransformState{translation: $translation, rotationAngle: $rotationAngle, scale: $scale}';
  }
}

class TransformMathCubit extends Cubit<TransformState> {
  final Size _canvasDimensions;

  TransformMathCubit(this._canvasDimensions)
      : super(
          TransformState(
            rotationAngle: 0.0,
            translation: Offset.zero,
            scale: 1.0,
          ),
        );

  PointerTracker? tracker1;
  PointerTracker? tracker2;

  bool get onePointer {
    return tracker1 == null && tracker2 != null ||
        tracker1 != null && tracker2 == null;
  }

  bool get twoPointers {
    return tracker1 != null && tracker2 != null;
  }

  void updateCanvas(PointerMoveEvent details) {
    if (onePointer) {
      final prev = tracker1?.position ?? tracker2!.position;
      translate(
        (details.position.dx - prev.dx),
        (details.position.dy - prev.dy),
      );
    } else if (twoPointers) {
      final pos1 = tracker1!.position;
      final pos2 = tracker2!.position;
      final orig = pos2 - pos1;

      if (tracker1?.id == details.pointer) {
        final curr = (pos2 - details.position);
        scale(
          math.sqrt(
            (curr.dx * curr.dx + curr.dy * curr.dy) /
                (orig.dx * orig.dx + orig.dy * orig.dy),
          ),
        );

        rotate(
          orig.dx,
          orig.dy,
          pos2.dx - details.position.dx,
          pos2.dy - details.position.dy,
          (pos2 + details.position) / 2,
        );
      } else {
        final curr = (details.position - pos1);
        scale(
          math.sqrt(
            (curr.dx * curr.dx + curr.dy * curr.dy) /
                (orig.dx * orig.dx + orig.dy * orig.dy),
          ),
        );

        rotate(
          orig.dx,
          orig.dy,
          details.position.dx - pos1.dx,
          details.position.dy - pos1.dy,
          (details.position + pos1) / 2,
        );
      }
      translate(
        details.delta.dx / (2),
        details.delta.dy / (2),
      );
    }
  }

  void rotate(double x1, double y1, double x2, double y2, Offset center) {
    emit(
      state.copyWith(
        rotationAngle: state.rotationAngle +
            math.atan((x1 * y2 - x2 * y1) / (x1 * x2 + y1 * y2)),
      ),
    );
  }

  void translate(double x, double y) {
    final halfCanvas = _canvasDimensions / 2;

    emit(
      state.copyWith(
        translation: Offset(
          (state.translation.dx + x).clamp(
            -halfCanvas.width,
            halfCanvas.height,
          ),
          (state.translation.dy + y).clamp(
            -halfCanvas.width,
            halfCanvas.height,
          ),
        ),
      ),
    );
  }

  void scale(double multiplier) {
    emit(
      state.copyWith(
        scale: (state.scale * multiplier).clamp(0.25, 4.0),
      ),
    );
  }

  void onPointerDown(PointerDownEvent details) {
    if (tracker1 == null) {
      tracker1 = PointerTracker(
        details.pointer,
        details.position,
      );
    } else {
      tracker2 ??= PointerTracker(
        details.pointer,
        details.position,
      );
    }
  }

  void onPointerMove(PointerMoveEvent details) {
    updateCanvas(details);

    if (tracker1?.id == details.pointer) {
      tracker1!.position = details.position;
    }
    if (tracker2?.id == details.pointer) {
      tracker2!.position = details.position;
    }
  }

  void onPointerUp(PointerUpEvent details) {
    if (tracker1?.id == details.pointer) {
      tracker1 = null;
    }
    if (tracker2?.id == details.pointer) {
      tracker2 = null;
    }
  }
}

class PointerTracker {
  final int id;
  Offset position;

  PointerTracker(this.id, this.position);

  factory PointerTracker.copy(PointerTracker other) {
    return PointerTracker(other.id, other.position);
  }
}
