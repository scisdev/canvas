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
        child: BlocConsumer<CanvasCubit, CanvasEmitState>(
          listener: (ctx, state) {
            if (state.action == CanvasAction.addedTextElement) {
              final bp = BlocProvider.of<CanvasCubit>(ctx);
              final element = bp.elements[bp.elements.length - 1];
              Get.to(
                () => TextPseudoPage(
                  element.view,
                  heroTag: element.id,
                ),
                transition: tt.Transition.fade,
              );
            }
          },
          builder: (ctx, state) => GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              BlocProvider.of<CanvasCubit>(ctx).addTextElement();
            },
            child: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Stack(
                alignment: Alignment.topCenter,
                children: BlocProvider.of<CanvasCubit>(ctx)
                    .elements
                    .map(
                      (e) => Hero(
                        tag: e.id,
                        child: Material(
                          child: e.view,
                        ),
                      ),
                    )
                    .toList(growable: false),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
