import 'dart:math' as math;

import 'package:canvas/canvas/view/canvas_element.dart';
import 'package:canvas/models/element_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum CanvasAction { updatedElement, createdElement }

class CanvasEmitState {
  final CanvasAction? action;
  final int generation;
  List<CanvasElementDescription> elements;

  CanvasEmitState({
    required this.generation,
    required this.elements,
    this.action,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CanvasEmitState &&
          runtimeType == other.runtimeType &&
          action == other.action &&
          generation == other.generation &&
          elements == other.elements;

  @override
  int get hashCode => action.hashCode ^ generation.hashCode ^ elements.hashCode;
}

class CanvasCubit extends Cubit<CanvasEmitState> {
  CanvasCubit() : super(CanvasEmitState(generation: 0, elements: []));

  final _idGen = RandomIdGenerator();

  void createNewElement(ElementType type) {
    emit(
      CanvasEmitState(
        generation: state.generation + 1,
        action: CanvasAction.updatedElement,
        elements: state.elements
          ..add(
            CanvasElementDescription(
              type: type,
              id: _idGen.genElementId(type),
              scale: 1.0,
              translation: Offset.zero,
              rotation: 0.0,
            ),
          ),
      ),
    );
  }

  void translateElement(
    CanvasElementDescription description, {
    required DragUpdateDetails details,
  }) {
    final el = state.elements.firstWhere(
      (t) => t.id == description.id,
    );

    el.translation = el.translation + details.delta;

    emit(
      CanvasEmitState(
        generation: state.generation + 1,
        action: CanvasAction.updatedElement,
        elements: state.elements,
      ),
    );
  }

  void transformElement(CanvasElementDescription description,
      {required ScaleUpdateDetails details}) {
    final el = state.elements.firstWhere(
      (t) => t.id == description.id,
    );

    el.translation += details.focalPointDelta;
    el.scale *= details.scale;
    el.rotation += details.rotation;

    emit(
      CanvasEmitState(
        generation: state.generation + 1,
        action: CanvasAction.updatedElement,
        elements: state.elements,
      ),
    );
  }

  /*double _getDeltaRotationAngle(ScaleUpdateDetails details) {

  }*/

  void onElementTap(String id) {}
}

class RandomIdGenerator {
  final math.Random _random = math.Random();

  String genElementId(ElementType type) {
    return '${type.toPrettyString()}#${_random.nextInt(0xffffff)}';
  }
}
