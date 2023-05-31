import 'package:flutter/material.dart';
import 'package:hitachi/config.dart';
import 'package:hitachi/helper/background/bg_white.dart';
import 'package:hitachi/helper/colors/colors.dart';
import 'package:hitachi/helper/text/label.dart';
import 'package:hitachi/screens/lineElement/materialInput/scan/materialInput_Screen.dart';
import 'package:hitachi/screens/lineElement/materialInput/hold/materialInput_hold_Screen.dart';
import 'package:hitachi/services/databaseHelper.dart';

class MaterialInputControlPage extends StatefulWidget {
  const MaterialInputControlPage({super.key});

  @override
  State<MaterialInputControlPage> createState() =>
      _MaterialInputControlPageState();
}

class _MaterialInputControlPageState extends State<MaterialInputControlPage> {
  List<Map<String, dynamic>> listHoldMaterialInput = [];
  DatabaseHelper databaseHelper = DatabaseHelper();
  @override
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetOptions = [
      MaterialInputScreen(
        onChange: (value) {
          setState(() {
            listHoldMaterialInput = value;
          });
        },
      ),
      MaterialInputHoldScreen(
        onChange: (value) {
          setState(() {
            listHoldMaterialInput = value;
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
            Label("MaterialInput"),
            SizedBox(
              width: 10,
            ),
            Label(
              "-${listHoldMaterialInput.length ?? 0}-",
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
