import 'package:canvas/canvas/logic/logic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:hand_signature/signature.dart';

import 'canvas/view/draw_layer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  final control = HandSignatureControl(
    threshold: 10.0,
    smoothRatio: 1,
    velocityRange: 1.0,
  );

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CanvasCubit>(
      create: (ctx) => CanvasCubit(),
      child: const DrawLayer(),
    );
  }

  Widget libCanvas() {
    return Material(
      child: Column(
        children: [
          Expanded(
            child: SizedBox.expand(
              child: HandSignaturePainterView(
                control: control,
                color: Colors.red,
                width: 1.0,
                maxWidth: 30.0,
                type: SignatureDrawType.shape,
              ),
            ),
          ),
          SizedBox(
            height: 80,
            width: double.infinity,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                control.stepBack();
              },
              child: const Center(
                child: Text('Step back'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
