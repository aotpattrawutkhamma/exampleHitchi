import 'package:flutter/material.dart';
import 'package:hitachi/helper/background/bg_white.dart';
import 'package:hitachi/helper/colors/colors.dart';
import 'package:hitachi/screens/lineElement/treatmentFinish/hold/treatmentFinish_hold.dart';
import 'package:hitachi/screens/lineElement/treatmentFinish/scan/treatmentFinish_scan_screen.dart';

class TreatmentFinishControlPage extends StatefulWidget {
  const TreatmentFinishControlPage({super.key});

  @override
  State<TreatmentFinishControlPage> createState() =>
      _TreatmentFinishControlPageState();
}

class _TreatmentFinishControlPageState
    extends State<TreatmentFinishControlPage> {
  @override
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<Widget> widgetOptions = [
    TreatmentFinishScanScreen(),
    TreatmentFinishHoldScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return BgWhite(
      textTitle: "TreatmentFinish",
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
