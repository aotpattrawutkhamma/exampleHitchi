import 'package:flutter/material.dart';
import 'package:hitachi/helper/background/bg_white.dart';
import 'package:hitachi/helper/colors/colors.dart';
import 'package:hitachi/helper/text/label.dart';
import 'package:hitachi/screens/lineElement/treatmentFinish/hold/treatmentFinish_hold.dart';
import 'package:hitachi/screens/lineElement/treatmentFinish/scan/treatmentFinish_scan_screen.dart';
import 'package:hitachi/services/databaseHelper.dart';

import '../../../config.dart';

class TreatmentFinishControlPage extends StatefulWidget {
  const TreatmentFinishControlPage({super.key});

  @override
  State<TreatmentFinishControlPage> createState() =>
      _TreatmentFinishControlPageState();
}

class _TreatmentFinishControlPageState
    extends State<TreatmentFinishControlPage> {
  List<Map<String, dynamic>> listHoldTreatmentFinish = [];
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
      TreatmentFinishScanScreen(
        onChange: (value) {
          setState(() {
            listHoldTreatmentFinish = value;
          });
        },
      ),
      TreatmentFinishHoldScreen(
        onChange: (value) {
          setState(() {
            listHoldTreatmentFinish = value;
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
            Label("Treatment Finish"),
            SizedBox(
              width: 10,
            ),
            Label(
              "-${listHoldTreatmentFinish.length ?? 0}-",
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
