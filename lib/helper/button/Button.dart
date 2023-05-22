import 'package:flutter/material.dart';
import 'package:hitachi/helper/colors/colors.dart';
import 'package:hitachi/helper/text/label.dart';

class Button extends StatefulWidget {
  const Button(
      {super.key,
      this.bgColor = COLOR_BLUE_DARK,
      this.height = 40,
      this.onPress,
      this.text});

  final Function? onPress;
  final Color bgColor;
  final double height;
  final Widget? text;

  @override
  State<Button> createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.onPress?.call(),
      child: Container(
        height: widget.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: widget.bgColor, borderRadius: BorderRadius.circular(12)),
        child: Center(child: widget.text),
      ),
    );
  }
}

// class Button extends StatelessWidget {
//   const Button(
//       {super.key,
//       this.bgColor = COLOR_BLUE,
//       this.text,
//       this.onPress,
//       this.height = 40});

//   final Color bgColor;
//   final Widget? text;
//   final Function? onPress;
//   final double height;

//   @override
//   Widget build(BuildContext context) {
  //   return GestureDetector(
  //     onTap: () => onPress?.call(),
  //     child: Container(
  //       height: height,
  //       width: MediaQuery.of(context).size.width,
  //       decoration: BoxDecoration(
  //           color: bgColor, borderRadius: BorderRadius.circular(12)),
  //       child: Center(child: text),
  //     ),
  //   );
  // }
// }
