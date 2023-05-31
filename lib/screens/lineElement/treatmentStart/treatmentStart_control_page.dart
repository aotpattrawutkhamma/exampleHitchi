import 'package:flutter/material.dart';
import 'package:hitachi/helper/background/bg_white.dart';
import 'package:hitachi/helper/colors/colors.dart';
import 'package:hitachi/helper/text/label.dart';
import 'package:hitachi/screens/lineElement/treatmentStart/hold/treatmentStartHold_screen.dart';
import 'package:hitachi/screens/lineElement/treatmentStart/scan/treatmentStart_scan_screen.dart';

import '../../../config.dart';
import '../../../services/databaseHelper.dart';

class TreatmentStartControlPage extends StatefulWidget {
  const TreatmentStartControlPage({super.key});

  @override
  State<TreatmentStartControlPage> createState() =>
      _TreatmentStartControlPageState();
}

class _TreatmentStartControlPageState extends State<TreatmentStartControlPage> {
  List<Map<String, dynamic>> listHoldTreatmentStart = [];
  @override
  int _selectedIndex = 0;
  DatabaseHelper databaseHelper = DatabaseHelper();
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
      TreatMentStartScanScreen(
        onChange: (value) {
          setState(() {
            listHoldTreatmentStart = value;
          });
        },
      ),
      TreatmentStartHoldScreen(
        onChange: (value) {
          setState(() {
            listHoldTreatmentStart = value;
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
            Label("Treatment Start"),
            SizedBox(
              width: 10,
            ),
            Label(
              "-${listHoldTreatmentStart.length ?? 0}-",
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
