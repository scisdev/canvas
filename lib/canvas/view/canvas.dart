import 'package:canvas/canvas/canvas.dart';
import 'package:canvas/note/note.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainCanvas extends StatelessWidget {
  final Note note;

  final ControlState controlState;
  final CameraState cameraState;

  const MainCanvas(
    this.note, {
    Key? key,
    required this.controlState,
    required this.cameraState,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
