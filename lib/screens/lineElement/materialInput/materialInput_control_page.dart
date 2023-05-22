import 'package:flutter/material.dart';
import 'package:hitachi/helper/background/bg_white.dart';
import 'package:hitachi/helper/colors/colors.dart';
import 'package:hitachi/screens/lineElement/materialInput/scan/materialInput_Screen.dart';
import 'package:hitachi/screens/lineElement/materialInput/hold/materialInput_hold_Screen.dart';

class MaterialInputControlPage extends StatefulWidget {
  const MaterialInputControlPage({super.key});

  @override
  State<MaterialInputControlPage> createState() =>
      _MaterialInputControlPageState();
}

class _MaterialInputControlPageState extends State<MaterialInputControlPage> {
  @override
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<Widget> widgetOptions = [
    MaterialInputScreen(),
    MaterialInputHoldScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return BgWhite(
      textTitle: "MaterialInput",
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
