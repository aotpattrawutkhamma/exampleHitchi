import 'package:flutter/material.dart';
import 'package:hitachi/helper/colors/colors.dart';
import 'package:hitachi/helper/text/label.dart';

class CardButton extends StatelessWidget {
  const CardButton(
      {Key? key,
      this.text,
      this.onPress,
      this.color = COLOR_BLUE_DARK,
      this.textAlign,
      this.colortext = COLOR_WHITE,
      this.fontWeight})
      : super(key: key);
  final String? text;
  final Function? onPress;
  final Color color;
  final Color colortext;
  final TextAlign? textAlign;
  final FontWeight? fontWeight;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onPress?.call(),
      child: Container(
          height: 60,
          width: MediaQuery.of(context).size.width,
          child: Card(
            color: color,
            elevation: 10,
            shadowColor: COLOR_BLACK,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Label(
                    text ?? "",
                    color: colortext,
                    textAlign: textAlign,
                    fontWeight: fontWeight,
                    fontSize: 25,
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
