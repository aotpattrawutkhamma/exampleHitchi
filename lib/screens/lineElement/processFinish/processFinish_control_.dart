import 'package:flutter/material.dart';
import 'package:hitachi/helper/background/bg_white.dart';
import 'package:hitachi/helper/colors/colors.dart';
import 'package:hitachi/screens/lineElement/processFinish/hold/processFinish_hold_screen.dart';
import 'package:hitachi/screens/lineElement/processFinish/scan/processFinish_scan_screen.dart';

class ProcessFinishControlPage extends StatefulWidget {
  const ProcessFinishControlPage({super.key});

  @override
  State<ProcessFinishControlPage> createState() =>
      _ProcessFinishControlPageState();
}

class _ProcessFinishControlPageState extends State<ProcessFinishControlPage> {
  @override
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<Widget> widgetOptions = [
    ProcessFinishScanScreen(),
    ProcessFinishHoldScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return BgWhite(
      textTitle: "ProcessFinish",
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
