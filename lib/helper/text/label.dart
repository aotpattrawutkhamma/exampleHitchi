import 'package:flutter/material.dart';
import 'package:hitachi/helper/colors/colors.dart';

class Label extends StatelessWidget {
  Label(
    this.text, {
    super.key,
    this.color = COLOR_BLACK,
    this.fontSize = 16,
    this.fontWeight,
    this.textAlign,
    this.fontStyle,
  });

  final String text;
  final Color color;
  final double fontSize;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final FontStyle? fontStyle;

  @override
  Widget build(BuildContext context) {
    return Text(
      text ?? "",
      textAlign: textAlign,
      style:
          TextStyle(color: color, fontSize: fontSize, fontWeight: fontWeight),
    );
  }
}
