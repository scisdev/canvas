import 'dart:math' as math;

import 'package:canvas/canvas/view/canvas_element.dart';
import 'package:canvas/models/element_type.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum CanvasAction {
  removeEmptyElements,
}

class TextEditModeDescription {
  final bool isInEditMode;
  final String? elementId;

  const TextEditModeDescription({
    required this.isInEditMode,
    required this.elementId,
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
  final String focusedId;
  final CanvasAction? action;
  final TextEditModeDescription textEditModeDescription;
  List<CanvasElementDescription> elements;

  CanvasEmitState._({
    required this.focusedId,
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
      ),
      focusedId: '',
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
      focusedId: focusedId ?? this.focusedId,
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

  void onElementTap(CanvasElementDescription desc) {
    onElementFocus(desc);
    if (desc.type == ElementType.text) {
      _setTextEditMode(true, elementId: desc.id);
    }
  }

  void onElementFocus(CanvasElementDescription desc) {
    final el = state.elements.firstWhere((f) => f.id == desc.id);
    emit(state.next(focusedId: el.id));
  }

  void onEmptyRegionTap() {
    if (state.textEditModeDescription.isInEditMode) {
      _setTextEditMode(false);
    }
  }

  void _setTextEditMode(bool editMode, {String? elementId}) {
    emit(state.next(
      textEditModeDescription: TextEditModeDescription(
        isInEditMode: editMode,
        elementId: elementId,
      ),
      action: editMode ? null : CanvasAction.removeEmptyElements,
    ));
  }
}

class RandomIdGenerator {
  final math.Random _random = math.Random();

  String genElementId(ElementType type) {
    return '${type.toPrettyString()}#${_random.nextInt(0xffffff)}';
  }
}
