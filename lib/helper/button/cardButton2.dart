import 'package:flutter/material.dart';
import 'package:hitachi/helper/colors/colors.dart';
import 'package:hitachi/helper/text/label.dart';

class CardButton2 extends StatelessWidget {
  const CardButton2({Key? key, this.text, this.onPress}) : super(key: key);
  final String? text;
  final Function? onPress;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onPress?.call(),
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Container(
            child: Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
          color: COLOR_BLUE_DARK,
          child: Center(
            child: Label(
              text ?? "",
              color: COLOR_WHITE,
              textAlign: TextAlign.center,
              fontSize: 25,
            ),
          ),
        )),
      ),
    );
  }
}
