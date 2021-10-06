import 'dart:math' as math;

import 'package:canvas/canvas/view/canvas_element.dart';
import 'package:canvas/models/element_type.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum CanvasAction {
  updateElement,
  createElement,
  enterTextEditMode,
  exitTextEditMode,
  removeEmptyElements,
}

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

  @override
  Future<void> close() async {
    await super.close();
  }

  void addElement(ElementType type) {
    emit(
      CanvasEmitState(
        generation: state.generation + 1,
        action: CanvasAction.enterTextEditMode,
        elements: state.elements
          ..add(
            CanvasElementDescription(
              type: type,
              id: _idGen.genElementId(type),
            ),
          ),
      ),
    );
  }

  void removeElement(String id) {
    final ind = state.elements.indexWhere((element) => element.id == id);
    if (ind == -1) return;

    emit(
      CanvasEmitState(
        generation: state.generation + 1,
        action: CanvasAction.enterTextEditMode,
        elements: state.elements..removeAt(ind),
      ),
    );
  }

  void onElementTap(String id) {}

  void onEmptyRegionTap() {
    emit(CanvasEmitState(
      generation: state.generation + 1,
      action: CanvasAction.removeEmptyElements,
      elements: state.elements,
    ));
  }
}

class RandomIdGenerator {
  final math.Random _random = math.Random();

  String genElementId(ElementType type) {
    return '${type.toPrettyString()}#${_random.nextInt(0xffffff)}';
  }
}
