import 'package:canvas/canvas/logic/cubit.dart';
import 'package:canvas/models/element_type.dart';
import 'package:fitted_text_field_container/fitted_text_field_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CanvasElementDescription {
  final String id;
  final ElementType type;
  Offset translation;
  double scale;
  double rotation;

  CanvasElementDescription({
    required this.id,
    required this.type,
    required this.translation,
    required this.rotation,
    required this.scale,
  });
}

class CanvasElementView extends StatelessWidget {
  final CanvasElementDescription description;

  const CanvasElementView(
    this.description, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print('on element tap');
        BlocProvider.of<CanvasCubit>(context).onElementTap(
          description.id,
        );
      },
      onScaleUpdate: (details) {
        print('on element scale');
        BlocProvider.of<CanvasCubit>(context).transformElement(
          description,
          details: details,
        );
      },
      /*onPanUpdate: (details) {
        BlocProvider.of<CanvasCubit>(context).translateElement(
          description,
          details: details,
        );
      },*/
      child: Transform(
        transform: Matrix4.identity()
          ..translate(description.translation.dx, description.translation.dy)
          ..rotateZ(description.rotation)
          ..scale(description.scale),
        child: getChild(),
      ),
    );
  }

  Widget getChild() {
    if (description.type == ElementType.text) {
      return _TextCanvasElementView(id: description.id);
    }

    return Container();
  }
}

class _TextCanvasElementView extends StatefulWidget {
  final String id;

  const _TextCanvasElementView({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  _TextCanvasElementViewState createState() => _TextCanvasElementViewState();
}

class _TextCanvasElementViewState extends State<_TextCanvasElementView> {
  final c = TextEditingController();

  @override
  void dispose() {
    print('disposing');
    c.dispose();
    super.dispose();
  }

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
          controller: c,
          minLines: 1,
          maxLines: 5,
          style: const TextStyle(fontSize: 24, color: Colors.white),
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
