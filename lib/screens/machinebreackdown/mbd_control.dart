import 'package:flutter/material.dart';
import 'package:hitachi/helper/background/bg_white.dart';
import 'package:hitachi/helper/colors/colors.dart';
import 'package:hitachi/screens/machinebreackdown/hold/mbd_hold.dart';
import 'package:hitachi/screens/machinebreackdown/scan/mbd_scan.dart';

class MachineBreackDownControl extends StatefulWidget {
  const MachineBreackDownControl({super.key});

  @override
  State<MachineBreackDownControl> createState() =>
      _MachineBreackDownControlState();
}

class _MachineBreackDownControlState extends State<MachineBreackDownControl> {
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

  List<Widget> widgetOptions = [
    MachineBreakDownScanScreen(),
    MachineBreakDownHoldScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return BgWhite(
      textTitle: "Machine BreakDown",
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
