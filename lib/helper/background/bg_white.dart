import 'package:flutter/material.dart';
import 'package:hitachi/helper/colors/colors.dart';
import 'package:hitachi/helper/text/label.dart';

class BgWhite extends StatelessWidget {
  const BgWhite(
      {this.isHideAppBar = false,
      this.isHideTitle = false,
      required this.body,
      this.appbar,
      this.isHidePreviour = false,
      this.textTitle,
      this.bottomNavigationBar,
      this.onPressedBack,
      super.key});
  final Widget? body;
  final Widget? appbar;
  final bool isHideAppBar;
  final bool isHideTitle;
  final Widget? textTitle;
  final bool isHidePreviour;
  final Widget? bottomNavigationBar;
  final Function? onPressedBack;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: COLOR_WHITE,
        appBar: isHideAppBar
            ? null
            : AppBar(
                shape: Border(bottom: BorderSide(color: COLOR_BLACK)),
                elevation: 0,
                backgroundColor: COLOR_TRANSPARENT,
                centerTitle: true,
                title: isHideTitle ? null : textTitle,
                automaticallyImplyLeading: false,
                leading: isHidePreviour
                    ? null
                    : BackButton(
                        color: COLOR_BLACK,
                        onPressed: () =>
                            onPressedBack?.call() ?? Navigator.pop(context),
                      ),
              ),
        body: body,
        bottomNavigationBar: bottomNavigationBar,
      ),
    );
  }
}
