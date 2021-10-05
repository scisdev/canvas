import 'package:flutter/material.dart';

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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {},
        child: SizedBox.expand(
          child: Center(
            child: widget.element,
          ),
        ),
      ),
    );
  }
}
