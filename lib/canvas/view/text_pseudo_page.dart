import 'package:fitted_text_field_container/fitted_text_field_container.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class TextPseudoPage extends StatefulWidget {
  final String text;
  final String heroTag;

  const TextPseudoPage(
    this.text, {
    Key? key,
    required this.heroTag,
  }) : super(key: key);

  @override
  _TextPseudoPageState createState() => _TextPseudoPageState();
}

class _TextPseudoPageState extends State<TextPseudoPage> {
  late final TextEditingController controller;
  bool canGetBack = false;

  @override
  void initState() {
    controller = TextEditingController(text: widget.text);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return canGetBack;
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            canGetBack = true;
            Get.back(result: controller.text);
          },
          child: SizedBox.expand(
            child: Center(
              child: Hero(
                tag: widget.heroTag,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.all(
                      Radius.circular(7),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: AnimatedFittedTextFieldContainer(
                    calculator: FittedTextFieldCalculator.fitVisible,
                    growDuration: const Duration(milliseconds: 90),
                    shrinkDuration: const Duration(milliseconds: 90),
                    child: TextField(
                      controller: controller,
                      style: const TextStyle(color: Colors.white, fontSize: 30),
                      scrollPadding: EdgeInsets.zero,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        focusedErrorBorder: InputBorder.none,
                      ),
                      autofocus: true,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
