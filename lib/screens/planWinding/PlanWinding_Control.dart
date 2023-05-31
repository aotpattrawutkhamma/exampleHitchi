import 'package:flutter/material.dart';
import 'package:hitachi/helper/background/bg_white.dart';
import 'package:hitachi/helper/colors/colors.dart';
import 'package:hitachi/helper/text/label.dart';
import 'package:hitachi/screens/planWinding/scan/planwinding_Screen.dart';
import 'package:hitachi/screens/zincthickness/hold/zincthicknessHold.dart';
import 'package:hitachi/screens/PMDaily/Scan/PMDaily_Scan_Sereen.dart';
import 'package:hitachi/screens/PMDaily/hold/PMDaily_Hold_Screen.dart';

class PlanWindingControl extends StatefulWidget {
  const PlanWindingControl({super.key});

  @override
  State<PlanWindingControl> createState() => _PlanWindingControlState();
}

class _PlanWindingControlState extends State<PlanWindingControl> {
  @override
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    Future.delayed(Duration(microseconds: 10), () {
      setState(() {
        setState(() {
          _selectedIndex = index;
        });
      });
    });
  }

  List<Widget> widgetOptions = [PlanWinding_Screen()];

  @override
  Widget build(BuildContext context) {
    return BgWhite(
      textTitle: Label(
        "PlanWinding",
      ),
      body: Center(
        child: widgetOptions.elementAt(_selectedIndex),
      ),
    );
  }
}
