import 'package:flutter/material.dart';
import 'package:hitachi/config.dart';
import 'package:hitachi/helper/background/bg_white.dart';
import 'package:hitachi/helper/colors/colors.dart';
import 'package:hitachi/helper/text/label.dart';
import 'package:hitachi/screens/lineElement/windingStart/Scan/windingjobstart_Scan_Screen.dart';
import 'package:hitachi/screens/lineElement/windingStart/hold/windingjobstart_Hold_Screen.dart';
import 'package:hitachi/services/databaseHelper.dart';

class WindingJobStartControlPage extends StatefulWidget {
  const WindingJobStartControlPage({super.key});

  @override
  State<WindingJobStartControlPage> createState() =>
      _WindingJobStartControlPageState();
}

class _WindingJobStartControlPageState
    extends State<WindingJobStartControlPage> {
  List<Map<String, dynamic>> listHoldWindingStart = [];
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
      WindingJobStartScanScreen(
        onChange: (value) {
          setState(() {
            listHoldWindingStart = value;
          });
        },
      ),
      WindingJobStartHoldScreen(
        onChange: (value) {
          setState(() {
            listHoldWindingStart = value;
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
            Label("Winding Start"),
            SizedBox(
              width: 10,
            ),
            Label(
              "-${listHoldWindingStart.length ?? 0}-",
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
