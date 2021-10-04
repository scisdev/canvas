import 'package:canvas/canvas/view/canvas.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class TextPseudoPage extends StatefulWidget {
  final Widget element;
  final String heroTag;

  const TextPseudoPage(
    this.element, {
    Key? key,
    required this.heroTag,
  }) : super(key: key);

  @override
  _TextPseudoPageState createState() => _TextPseudoPageState();
}

class _TextPseudoPageState extends State<TextPseudoPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          Get.offAll(() => const DrawCanvas());
        },
        child: SizedBox.expand(
          child: Center(
            child: Hero(
              tag: widget.heroTag,
              child: widget.element,
            ),
          ),
        ),
      ),
    );
  }
}
