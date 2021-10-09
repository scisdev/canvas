import 'package:canvas/canvas/logic/cubit.dart';
import 'package:canvas/canvas/view/canvas_element.dart';
import 'package:canvas/models/element_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DrawCanvas extends StatefulWidget {
  const DrawCanvas({Key? key}) : super(key: key);

  @override
  _CanvasState createState() => _CanvasState();
}

class _CanvasState extends State<DrawCanvas> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            FocusScope.of(context).unfocus();
            BlocProvider.of<CanvasCubit>(context).setTextEditMode(false);
          },
          child: BlocConsumer<CanvasCubit, CanvasEmitState>(
            listener: (ctx, state) {},
            builder: (ctx, state) {
              //todo focused stuff
              return Stack(
                alignment: Alignment.center,
                children: state.elements.map<Widget>(
                  (e) {
                    if (e.type == ElementType.text) {
                      return TextCanvasElement(id: e.id);
                    }

                    if (e.type == ElementType.image) {
                      return ImageCanvasElement(id: e.id);
                    }

                    return Container();
                  },
                ).toList()
                  ..add(
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        color: Colors.blue.withAlpha(60),
                        width: double.infinity,
                        height: 50,
                        child: TextButton(
                          child: const Text('create new element'),
                          onPressed: () {
                            BlocProvider.of<CanvasCubit>(ctx).addElement(
                              ElementType.text,
                            );
                          },
                        ),
                      ),
                    ),
                  )
                /*..add(AnimatedOpacity(
                    duration: Duration(milliseconds: 450),
                    opacity: state,
                  ))*/
                ,
              );
            },
          ),
        ),
      ),
    );
  }
}
