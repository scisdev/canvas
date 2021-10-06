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

class TextCanvasElement extends StatefulWidget {
  final String id;

  const TextCanvasElement({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  _TextCanvasElementState createState() => _TextCanvasElementState();
}

class _TextCanvasElementState extends State<TextCanvasElement>
    with SingleTickerProviderStateMixin {
  final c = TextEditingController();
  final node = FocusNode();

  Matrix4 matrix = Matrix4.identity();

  late AnimationController controller;
  bool lastEditState = false;

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
      value: 1.0,
    );
    super.initState();
  }

  @override
  void dispose() {
    node.dispose();
    c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TransformMathCubit>(
      create: (ctx) => TransformMathCubit(MediaQuery.of(context).size),
      child: BlocConsumer<TransformMathCubit, TransformState>(
        listener: (ctx, state) {
          //todo
        },
        builder: (ctx, transformState) {
          return Transform(
            transform: Matrix4.identity()
              ..translate(
                  transformState.translation.dx, transformState.translation.dy)
              ..rotateZ(transformState.rotationAngle)
              ..scale(transformState.scale),
            alignment: Alignment.center,
            child: BlocConsumer<CanvasCubit, CanvasEmitState>(
              listener: (ctx, state) {
                if (state.action == CanvasAction.removeEmptyElements &&
                    c.text.isEmpty) {
                  BlocProvider.of<CanvasCubit>(ctx).removeElement(widget.id);
                }
              },
              builder: (ctx, canvasState) {
                return GestureDetector(
                  onTap: () {
                    BlocProvider.of<CanvasCubit>(ctx).setTextEditMode(
                      true,
                      id: widget.id,
                      originalPosition: Matrix4.copy(matrix),
                    );
                  },
                  child: AbsorbPointer(
                    absorbing: canvasState.textEditModeDescription.isInEditMode,
                    child: Listener(
                      behavior: HitTestBehavior.opaque,
                      onPointerDown: (details) {
                        if (node.hasFocus) {
                          BlocProvider.of<TransformMathCubit>(ctx).cancelAll();
                        } else {
                          BlocProvider.of<TransformMathCubit>(ctx)
                              .onPointerDown(details);
                        }
                      },
                      onPointerUp: (details) {
                        if (node.hasFocus) {
                          BlocProvider.of<TransformMathCubit>(ctx).cancelAll();
                        } else {
                          BlocProvider.of<TransformMathCubit>(ctx)
                              .onPointerUp(details);
                        }
                      },
                      onPointerMove: (details) {
                        if (node.hasFocus) {
                          BlocProvider.of<TransformMathCubit>(ctx).cancelAll();
                        } else {
                          BlocProvider.of<TransformMathCubit>(ctx)
                              .onPointerMove(details);
                        }
                      },
                      child: textContainer(),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget textContainer() {
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
                growCurve: Curves.linear,
                shrinkCurve: Curves.linear,*/
        child: TextField(
          textAlign: TextAlign.center,
          autofocus: true,
          onTap: () {},
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
    );
  }
}

class ImageCanvasElement extends StatefulWidget {
  final String id;

  const ImageCanvasElement({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  _ImageCanvasElementState createState() => _ImageCanvasElementState();
}

class _ImageCanvasElementState extends State<ImageCanvasElement> {
  Matrix4 matrix = Matrix4.identity();

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class CanvasElementGestureListener extends StatelessWidget {
  final Widget child;
  final bool ignoring;

  const CanvasElementGestureListener({
    Key? key,
    required this.child,
    required this.ignoring,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: ignoring,
      child: Listener(
        behavior: HitTestBehavior.opaque,
        onPointerDown: (details) {
          BlocProvider.of<TransformMathCubit>(context).onPointerDown(details);
        },
        onPointerUp: (details) {
          BlocProvider.of<TransformMathCubit>(context).onPointerUp(details);
        },
        onPointerMove: (details) {
          BlocProvider.of<TransformMathCubit>(context).onPointerMove(details);
        },
        child: child,
      ),
    );
  }
}

extension DoubleX on double {
  double withCurve(Curve curve) {
    return curve.transform(this);
  }
}
