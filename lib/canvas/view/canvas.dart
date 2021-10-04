import 'package:canvas/canvas/logic/cubit.dart';
import 'package:canvas/canvas/view/text_pseudo_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/route_manager.dart';

import 'package:get/get_navigation/src/routes/transitions_type.dart' as tt;

class DrawCanvas extends StatefulWidget {
  const DrawCanvas({Key? key}) : super(key: key);

  @override
  _CanvasState createState() => _CanvasState();
}

class _CanvasState extends State<DrawCanvas> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<CanvasCubit, CanvasEmitState>(
          builder: (ctx, state) => GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              print('doing');
              Get.to(
                () => TextPseudoPage(
                  '',
                  heroTag: BlocProvider.of<CanvasCubit>(ctx).addTextElement(),
                ),
                transition: tt.Transition.fade,
              );
            },
            child: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Stack(
                alignment: Alignment.topCenter,
                children: BlocProvider.of<CanvasCubit>(ctx)
                    .elements
                    .toList(growable: false),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
