import 'package:canvas/canvas/logic/cubit.dart';
import 'package:canvas/canvas/view/text_pseudo_page.dart';
import 'package:canvas/models/element_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/route_manager.dart';

class CanvasElement extends StatefulWidget {
  final Widget view;
  final ElementType type;
  final String id;
  final Matrix4? initialTransform;

  const CanvasElement({
    Key? key,
    required this.type,
    required this.view,
    required this.id,
    this.initialTransform,
  }) : super(key: key);

  @override
  _CanvasElementState createState() => _CanvasElementState();
}

class _CanvasElementState extends State<CanvasElement> {
  late Matrix4 transform;

  @override
  void initState() {
    transform = widget.initialTransform ?? Matrix4.identity();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: widget.id,
      child: GestureDetector(
        onScaleStart: (details) {},
        onScaleUpdate: (details) {
          print('$details');
        },
        onTap: () {
          if (widget.type == ElementType.text) {
            Get.to(
              () => TextPseudoPage(
                (widget.view as Text).data!,
                heroTag: widget.id,
              ),
            )?.then((newText) {
              if (newText != null) {
                BlocProvider.of<CanvasCubit>(context).replaceText(
                  widget.id,
                  newText,
                );
              }
            });
          }
        },
        child: widget.view,
      ),
    );
  }
}
