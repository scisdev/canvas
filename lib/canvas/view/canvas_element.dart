import 'package:canvas/canvas/logic/logic.dart';
import 'package:canvas/models/element_type.dart';
import 'package:fitted_text_field_container/fitted_text_field_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CanvasElementDescription {
  final String id;
  final ElementType type;

  CanvasElementDescription({
    required this.id,
    required this.type,
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
    return BlocProvider<TransformMathCubit>(
      create: (ctx) => TransformMathCubit(MediaQuery.of(context).size),
      child: BlocBuilder<TransformMathCubit, TransformState>(
        builder: (ctx, state) {
          print('building with state $state');
          return Transform(
            transform: Matrix4.identity()
              ..translate(state.translation.dx, state.translation.dy)
              ..rotateZ(state.rotationAngle)
              ..scale(state.scale),
            alignment: Alignment.center,
            child: Listener(
              behavior: HitTestBehavior.opaque,
              onPointerDown: (details) {
                BlocProvider.of<TransformMathCubit>(ctx).onPointerDown(details);
              },
              onPointerUp: (details) {
                BlocProvider.of<TransformMathCubit>(ctx).onPointerUp(details);
              },
              onPointerMove: (details) {
                BlocProvider.of<TransformMathCubit>(ctx).onPointerMove(details);
              },
              child: getChild(),
            ),
          );
        },
      ),
    );
  }

  Widget getChild() {
    if (description.type == ElementType.text) {
      return _TextCanvasElementView(
        id: description.id,
        unselectable: false,
      );
    }

    return Container();
  }
}

class _TextCanvasElementView extends StatefulWidget {
  final String id;
  final bool unselectable;

  const _TextCanvasElementView({
    Key? key,
    required this.id,
    required this.unselectable,
  }) : super(key: key);

  @override
  _TextCanvasElementViewState createState() => _TextCanvasElementViewState();
}

class _TextCanvasElementViewState extends State<_TextCanvasElementView> {
  final c = TextEditingController();
  final node = FocusNode();

  @override
  void dispose() {
    node.dispose();
    c.dispose();
    super.dispose();
  }

  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      node.requestFocus();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CanvasCubit, CanvasEmitState>(
      listener: (ctx, state) {
        if (state.action == CanvasAction.removeEmptyElements &&
            c.text.isEmpty) {
          BlocProvider.of<CanvasCubit>(ctx).removeElement(widget.id);
        }
      },
      child: AbsorbPointer(
        absorbing: widget.unselectable,
        child: GestureDetector(
          onTap: () {
            node.requestFocus();
          },
          child: Container(
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
              growCurve: Curves.linear,
              shrinkCurve: Curves.linear,*/
              child: TextField(
                onTap: () {
                  print('tapping');
                },
                focusNode: node,
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
          ),
        ),
      ),
    );
  }
}
