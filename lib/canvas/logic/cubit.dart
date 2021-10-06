import 'dart:math' as math;

import 'package:canvas/canvas/view/canvas_element.dart';
import 'package:canvas/models/element_type.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum CanvasAction {
  removeEmptyElements,
}

class TextEditModeDescription {
  final bool isInEditMode;
  final String? elementId;
  final Matrix4? originalPosition;

  const TextEditModeDescription({
    required this.isInEditMode,
    required this.elementId,
    required this.originalPosition,
  });

  @override
  bool operator ==(Object other) =>
      other is TextEditModeDescription &&
      isInEditMode == other.isInEditMode &&
      elementId == other.elementId;

  @override
  int get hashCode => isInEditMode.hashCode ^ elementId.hashCode;
}

class CanvasEmitState {
  final int gen;
  final CanvasAction? action;
  final TextEditModeDescription textEditModeDescription;
  List<CanvasElementDescription> elements;

  CanvasEmitState._({
    required this.gen,
    required this.elements,
    required this.textEditModeDescription,
    this.action,
  });

  factory CanvasEmitState.initial() {
    return CanvasEmitState._(
      gen: 0,
      elements: [],
      textEditModeDescription: const TextEditModeDescription(
        isInEditMode: false,
        elementId: null,
        originalPosition: null,
      ),
      action: null,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is CanvasEmitState && gen == other.gen;

  @override
  int get hashCode =>
      action.hashCode ^
      textEditModeDescription.hashCode ^
      elements.hashCode ^
      gen.hashCode;

  CanvasEmitState next({
    CanvasAction? action,
    TextEditModeDescription? textEditModeDescription,
    List<CanvasElementDescription>? elements,
    String? focusedId,
  }) {
    return CanvasEmitState._(
      gen: gen + 1,
      elements: elements ?? this.elements,
      action: action ?? this.action,
      textEditModeDescription:
          textEditModeDescription ?? this.textEditModeDescription,
    );
  }
}

class CanvasCubit extends Cubit<CanvasEmitState> {
  CanvasCubit() : super(CanvasEmitState.initial());

  final _idGen = RandomIdGenerator();

  @override
  Future<void> close() async {
    await super.close();
  }

  void addElement(ElementType type) {
    emit(state.next(
      elements: state.elements
        ..add(
          CanvasElementDescription(
            type: type,
            id: _idGen.genElementId(type),
          ),
        ),
    ));
  }

  void removeElement(String id) {
    final ind = state.elements.indexWhere((element) => element.id == id);
    if (ind == -1) return;

    emit(state.next(
      elements: state.elements..removeAt(ind),
    ));
  }

  void setTextEditMode(
    bool textEditMode, {
    String? id,
    Matrix4? originalPosition,
  }) {
    emit(
      state.next(
        textEditModeDescription: TextEditModeDescription(
          originalPosition: originalPosition,
          isInEditMode: textEditMode,
          elementId: id,
        ),
      ),
    );
  }
}

class RandomIdGenerator {
  final math.Random _random = math.Random();

  String genElementId(ElementType type) {
    return '${type.toPrettyString()}#${_random.nextInt(0xffffff)}';
  }
}
