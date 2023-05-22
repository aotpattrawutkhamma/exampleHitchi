import 'package:flutter/material.dart';
import 'package:hitachi/helper/background/bg_white.dart';
import 'package:hitachi/helper/colors/colors.dart';
import 'package:hitachi/screens/zincthickness/hold/zincthicknessHold.dart';
import 'package:hitachi/screens/zincthickness/scan/zincthicknessScan.dart';

class ZincThicknessControl extends StatefulWidget {
  const ZincThicknessControl({super.key});

  @override
  State<ZincThicknessControl> createState() => _ZincThicknessControlState();
}

class _ZincThicknessControlState extends State<ZincThicknessControl> {
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

  List<Widget> widgetOptions = [ZincThickNessScanScreen(), ZincThickNessHold()];

  @override
  Widget build(BuildContext context) {
    return BgWhite(
      textTitle: "Zinc Thickness",
      body: Center(
        child: widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.aod),
            label: 'Scan',
            backgroundColor: Colors.red,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work),
            label: 'Hold',
            backgroundColor: Colors.green,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: COLOR_BLUE_DARK,
        onTap: _onItemTapped,
      ),
    );
  }
}
