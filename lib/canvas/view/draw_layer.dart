import 'dart:ui';

import 'package:bezier/bezier.dart';
import 'package:canvas/canvas/logic/draw_layer_logic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DrawLayer extends StatelessWidget {
  const DrawLayer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) => DrawLayerCubit(
        MediaQuery.of(context).size,
      ),
      child: BlocBuilder<DrawLayerCubit, Data>(
        builder: (ctx, state) => Listener(
          behavior: HitTestBehavior.opaque,
          child: SizedBox.expand(
            child: CustomPaint(
              painter: TestPainter(state),
            ),
          ),
          onPointerMove: (details) {
            BlocProvider.of<DrawLayerCubit>(ctx)
                .addPoint(details.localPosition);
          },
          onPointerDown: (details) {
            BlocProvider.of<DrawLayerCubit>(ctx)
                .addPoint(details.localPosition);
          },
        ),
      ),
    );
  }
}

class TestPainter extends CustomPainter {
  final Data data;

  TestPainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    if (data.beziers.isEmpty) return;

    var start = data.beziers[0].points;
    var path = Path();
    path.moveTo(start[0].x, start[0].y);
    for (var element in data.beziers) {
      path.quadraticBezierTo(
        element.points[1].x,
        element.points[1].y,
        element.points[2].x,
        element.points[2].y,
      );
    }
    canvas.drawPath(
        path,
        Paint()
          ..color = Colors.red
          ..strokeWidth = 10);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
