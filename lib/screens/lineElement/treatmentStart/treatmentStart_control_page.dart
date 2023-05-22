import 'package:flutter/material.dart';
import 'package:hitachi/helper/background/bg_white.dart';
import 'package:hitachi/helper/colors/colors.dart';
import 'package:hitachi/screens/lineElement/treatmentStart/hold/treatmentStartHold_screen.dart';
import 'package:hitachi/screens/lineElement/treatmentStart/scan/treatmentStart_scan_screen.dart';

class TreatmentStartControlPage extends StatefulWidget {
  const TreatmentStartControlPage({super.key});

  @override
  State<TreatmentStartControlPage> createState() =>
      _TreatmentStartControlPageState();
}

class _TreatmentStartControlPageState extends State<TreatmentStartControlPage> {
  @override
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<Widget> widgetOptions = [
    TreatMentStartScanScreen(),
    TreatmentStartHoldScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return BgWhite(
      textTitle: "TreatmentStart",
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
