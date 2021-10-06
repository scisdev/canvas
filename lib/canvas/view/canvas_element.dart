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
                print('sending pointer down');
                BlocProvider.of<TransformMathCubit>(ctx).onPointerDown(details);
              },
              onPointerUp: (details) {
                print('sending pointer up');
                BlocProvider.of<TransformMathCubit>(ctx).onPointerUp(details);
              },
              onPointerMove: (details) {
                print('sending pointer move');
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
    return BlocListener<CanvasCubit, CanvasEmitState>(
      listener: (ctx, state) {
        if (state.action == CanvasAction.removeEmptyElements) {}
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
            autofocus: true,
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
    );
  }
}
