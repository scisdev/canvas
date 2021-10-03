import 'package:canvas/canvas/canvas.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CanvasGestureHandler extends StatelessWidget {
  final Widget child;

  const CanvasGestureHandler({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.opaque,
      onPointerDown: (details) {
        if (BlocProvider.of<ControlCubit>(context).state == ControlState.draw) {
          return;
        }

        BlocProvider.of<CameraCubit>(context).onPointerDown(details);
      },
      onPointerUp: (details) {
        if (BlocProvider.of<ControlCubit>(context).state == ControlState.draw) {
          return;
        }

        BlocProvider.of<CameraCubit>(context).onPointerUp(details);
      },
      onPointerMove: (details) {
        if (BlocProvider.of<ControlCubit>(context).state == ControlState.draw) {
          return;
        }

        BlocProvider.of<CameraCubit>(context).onPointerMove(details);
      },
      child: child,
    );
  }
}
