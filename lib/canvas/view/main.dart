import 'package:canvas/canvas/canvas.dart';
import 'package:canvas/canvas/logic/logic.dart';
import 'package:canvas/note/note.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DrawCanvas extends StatefulWidget {
  const DrawCanvas({Key? key}) : super(key: key);

  @override
  State<DrawCanvas> createState() => _DrawCanvasState();
}

class _DrawCanvasState extends State<DrawCanvas> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (ctx) {
            final cubit = CameraCubit();
            Future(() {
              final size = MediaQuery.of(ctx).size;
              cubit.setCanvasDimensions(Offset(size.width, size.height));
            });
            return cubit;
          },
        ),
        BlocProvider(
          create: (ctx) => ControlCubit(),
        ),
        BlocProvider<LinePainterCubit>(
          create: (ctx) => LinePainterCubit(),
        ),
      ],
      child: BlocBuilder<CameraCubit, CameraState>(
        builder: (ctx, cameraState) {
          return BlocBuilder<ControlCubit, ControlState>(
            builder: (ctx, controlState) {
              return CanvasGestureHandler(
                child: Container(
                  height: double.infinity,
                  width: double.infinity,
                  color: Colors.cyan,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      AbsorbPointer(
                        absorbing: controlState == ControlState.camera,
                        child: DevelopmentSimpleNote(
                          Matrix4.identity()
                            ..setTranslation(cameraState.translation)
                            ..rotateZ(cameraState.rotationAngle)
                            ..scale(
                              cameraState.scale,
                              cameraState.scale,
                              1.0,
                            ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: BottomBar(controlState: controlState),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
