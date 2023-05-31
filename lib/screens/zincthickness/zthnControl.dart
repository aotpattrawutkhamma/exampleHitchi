import 'package:flutter/material.dart';
import 'package:hitachi/config.dart';
import 'package:hitachi/helper/background/bg_white.dart';
import 'package:hitachi/helper/colors/colors.dart';
import 'package:hitachi/helper/text/label.dart';
import 'package:hitachi/screens/zincthickness/hold/zincthicknessHold.dart';
import 'package:hitachi/screens/zincthickness/scan/zincthicknessScan.dart';
import 'package:hitachi/services/databaseHelper.dart';

class ZincThicknessControl extends StatefulWidget {
  const ZincThicknessControl({super.key});

  @override
  State<ZincThicknessControl> createState() => _ZincThicknessControlState();
}

class _ZincThicknessControlState extends State<ZincThicknessControl> {
  List<Map<String, dynamic>> listHoldZincThickness = [];
  DatabaseHelper databaseHelper = DatabaseHelper();
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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetOptions = [
      ZincThickNessScanScreen(
        onChange: (value) {
          setState(() {
            listHoldZincThickness = value;
          });
        },
      ),
      ZincThickNessHold(
        onChange: (value) {
          setState(() {
            listHoldZincThickness = value;
          });
        },
      )
    ];
    return BgWhite(
      textTitle: Padding(
        padding: const EdgeInsets.only(right: 45),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Label("Zinc Thickness"),
            SizedBox(
              width: 10,
            ),
            Label(
              "-${listHoldZincThickness.length ?? 0}-",
              color: COLOR_RED,
            )
          ],
        ),
      ),
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
