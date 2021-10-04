import 'package:canvas/canvas/canvas.dart';
import 'package:canvas/canvas/logic/logic.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TextLayer extends StatelessWidget {
  const TextLayer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class ImageLayer extends StatelessWidget {
  const ImageLayer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
    /*SizedBox.expand(
      child: SvgPicture.asset(
        'assets/test.svg',
        fit: BoxFit.cover,
      ),
    )*/
  }
}

abstract class Note extends StatelessWidget {
  final Widget child;
  final Matrix4 transform;

  bool isLineInsideBoundary(Offset lineStart, Offset lineEnd);

  const Note({Key? key, required this.child, required this.transform})
      : super(key: key);

  @override
  @nonVirtual
  Widget build(BuildContext context) {
    return Transform(
      transform: transform,
      alignment: Alignment.center,
      child: Listener(
        onPointerDown: (details) {
          if (isLineInsideBoundary(
              details.localPosition, details.localPosition)) {
            BlocProvider.of<LinePainterCubit>(context).addPoint(
              details.localPosition,
            );
          }
        },
        onPointerMove: (details) {
          final prev = details.localPosition - details.localDelta;

          if (isLineInsideBoundary(prev, details.localPosition)) {
            BlocProvider.of<LinePainterCubit>(context).addLine(
              prev,
              details.localPosition,
            );
          }
        },
        behavior: HitTestBehavior.opaque,
        child: Container(
          width: 200,
          height: 200,
          color: Colors.red,
          child: Stack(
            children: [
              const ImageLayer(),
              const TextLayer(),
              BlocBuilder<ControlCubit, ControlState>(
                builder: (ctx, controlState) {
                  return BlocBuilder<LinePainterCubit, LinesState>(
                    builder: (ctx, state) {
                      if (controlState == ControlState.draw) {
                        return CustomPaint(
                          painter: LinesPainter(state.lines),
                        );
                      }

                      if (controlState == ControlState.camera) {
                        if (state.lines.isNotEmpty) {
                          return SvgPicture.string(
                            LinesPainter(state.lines).toSvg(
                              const Size(200, 200),
                            ),
                          );
                        }
                      }

                      return const SizedBox();
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DevelopmentSimpleNote extends Note {
  DevelopmentSimpleNote(Matrix4 transform, {Key? key})
      : super(
          key: key,
          child: Container(
            width: 200,
            height: 200,
            color: Colors.red,
          ),
          transform: transform,
        );

  @override
  bool isLineInsideBoundary(Offset lineStart, Offset lineEnd) {
    return lineStart.dx < 180 &&
        lineStart.dy < 180 &&
        lineStart.dx > 0 &&
        lineStart.dy > 0 &&
        lineEnd.dx < 180 &&
        lineEnd.dy < 180 &&
        lineEnd.dx > 0 &&
        lineEnd.dy > 0;
  }
}
