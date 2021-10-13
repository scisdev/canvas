import 'dart:ui';

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
          /*onPointerMove: (details) {
            BlocProvider.of<DrawLayerCubit>(ctx)
                .addPoint(details.localPosition);
          },*/
          onPointerDown: (details) {
            BlocProvider.of<DrawLayerCubit>(ctx).addPoint(
              details.localPosition,
            );
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
    final path = Path();
    for (final t in data.beziers) {
      path.addPath(t.getDrawPath(), const Offset(0, 0));
    }

    canvas.drawPath(path, Paint()..color = Colors.red);

    canvas.drawPoints(
      PointMode.points,
      data.points.map((e) => e.coords).toList(),
      Paint()
        ..color = Colors.blue
        ..strokeWidth = 10,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
