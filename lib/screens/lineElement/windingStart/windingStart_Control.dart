import 'package:flutter/material.dart';
import 'package:hitachi/helper/background/bg_white.dart';
import 'package:hitachi/helper/colors/colors.dart';
import 'package:hitachi/screens/lineElement/windingStart/Scan/windingjobstart_Scan_Screen.dart';
import 'package:hitachi/screens/lineElement/windingStart/hold/windingjobstart_Hold_Screen.dart';

class WindingJobStartControlPage extends StatefulWidget {
  const WindingJobStartControlPage({super.key});

  @override
  State<WindingJobStartControlPage> createState() =>
      _WindingJobStartControlPageState();
}

class _WindingJobStartControlPageState
    extends State<WindingJobStartControlPage> {
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<Widget> widgetOptions = [
    WindingJobStartScanScreen(),
    WindingJobStartHoldScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return BgWhite(
      textTitle: "WindingStart",
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
