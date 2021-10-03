import 'package:canvas/canvas/canvas.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BottomBar extends StatelessWidget {
  final ControlState controlState;

  const BottomBar({Key? key, required this.controlState}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        BlocProvider.of<ControlCubit>(context).toggleState();
      },
      child: Container(
        height: 80,
        width: double.infinity,
        color: Colors.green,
        child: Center(
          child: Text(
            controlState == ControlState.camera ? 'MOVING' : 'DRAWING',
          ),
        ),
      ),
    );
  }
}
