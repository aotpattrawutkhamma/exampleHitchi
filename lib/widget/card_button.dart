import 'package:flutter/material.dart';
import 'package:hitachi/helper/colors/colors.dart';
import 'package:hitachi/helper/text/label.dart';

class CardButton extends StatelessWidget {
  const CardButton({Key? key, this.text, this.onPress}) : super(key: key);
  final String? text;
  final Function? onPress;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onPress?.call(),
      child: Container(
          height: 50,
          width: MediaQuery.of(context).size.width,
          child: Card(
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
                    color: COLOR_WHITE,
                  ),
                ),
              ],
            ),
            color: COLOR_BLUE,
          )),
    );
  }
}
