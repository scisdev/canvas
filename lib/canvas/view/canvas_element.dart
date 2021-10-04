import 'package:canvas/models/element_type.dart';
import 'package:fitted_text_field_container/fitted_text_field_container.dart';
import 'package:flutter/material.dart';

class CanvasElement {
  final Widget view;
  final ElementType type;
  final String id;
  final Matrix4? transform;

  CanvasElement({
    required this.view,
    required this.type,
    required this.id,
    this.transform,
  });
}

class TextCanvasElement extends CanvasElement {
  TextCanvasElement({
    required ElementType type,
    required String id,
    Matrix4? transform,
  }) : super(
            id: id,
            type: type,
            view: TextCanvasElementView(
              controller: TextEditingController(),
              id: id,
            ),
            transform: transform);
}

class TextCanvasElementView extends StatefulWidget {
  final TextEditingController controller;
  final String id;

  const TextCanvasElementView({
    Key? key,
    required this.id,
    required this.controller,
  }) : super(key: key);

  @override
  _TextCanvasElementViewState createState() => _TextCanvasElementViewState();
}

class _TextCanvasElementViewState extends State<TextCanvasElementView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: const BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.all(Radius.circular(7)),
      ),
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width - 2 * 40,
      ),
      child: FittedTextFieldContainer(
        /*growDuration: const Duration(milliseconds: 90),
        shrinkDuration: const Duration(milliseconds: 90),
        growCurve: Curves.easeInOut,
        shrinkCurve: Curves.easeInOut,*/
        child: TextField(
          minLines: 1,
          maxLines: 5,
          autofocus: true,
          style: const TextStyle(fontSize: 24, color: Colors.white),
          controller: widget.controller,
          decoration: const InputDecoration(
            focusedErrorBorder: InputBorder.none,
            border: InputBorder.none,
            errorBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            contentPadding: EdgeInsets.zero,
          ),
        ),
      ),
    );
  }
}
