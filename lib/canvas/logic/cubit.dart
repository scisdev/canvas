import 'dart:math';

import 'package:canvas/canvas/view/canvas_element.dart';
import 'package:canvas/models/element_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum CanvasAction { addedTextElement, updatedTextElement }

class CanvasEmitState {
  final CanvasAction? action;
  final int generation;

  CanvasEmitState({
    required this.generation,
    this.action,
  });
}

class CanvasCubit extends Cubit<CanvasEmitState> {
  CanvasCubit() : super(CanvasEmitState(generation: 0));

  final idGen = RandomIdGenerator();

  List<CanvasElement> elements = [];

  void onElementTap(CanvasElement element) {
    if (element.view is Text) {}
  }

  String addTextElement() {
    elements.add(TextCanvasElement(
      id: idGen.genElementId(ElementType.text),
      type: ElementType.text,
    ));

    emit(
      CanvasEmitState(
        generation: state.generation + 1,
        action: CanvasAction.addedTextElement,
      ),
    );

    return elements[elements.length - 1].id;
  }

  void replaceText(String elementId, String newText) {
    final ind = elements.indexWhere((f) => f.id == elementId);

    elements[ind] = CanvasElement(
      id: idGen.genElementId(ElementType.text),
      type: ElementType.text,
      view: Text(newText),
    );

    emit(
      CanvasEmitState(
        generation: state.generation + 1,
        action: CanvasAction.updatedTextElement,
      ),
    );
  }
}

class RandomIdGenerator {
  final Random _random = Random();

  String genElementId(ElementType type) {
    return '${type.toPrettyString()}#${_random.nextInt(0xffffff)}';
  }
}
