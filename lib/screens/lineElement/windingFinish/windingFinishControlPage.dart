import 'package:flutter/material.dart';
import 'package:hitachi/helper/background/bg_white.dart';
import 'package:hitachi/helper/colors/colors.dart';
import 'package:hitachi/helper/text/label.dart';
import 'package:hitachi/screens/lineElement/windingFinish/hold/windingJobFinish_hold_screen.dart';
import 'package:hitachi/screens/lineElement/windingFinish/scan/windingjobFinish_screen.dart';
import 'package:hitachi/services/databaseHelper.dart';

import '../../../config.dart';

class WindingFinishControlPage extends StatefulWidget {
  const WindingFinishControlPage({super.key});

  @override
  State<WindingFinishControlPage> createState() =>
      _WindingFinishControlPageState();
}

class _WindingFinishControlPageState extends State<WindingFinishControlPage> {
  List<Map<String, dynamic>> listHoldWindingFinish = [];
  int _selectedIndex = 0;
  DatabaseHelper databaseHelper = DatabaseHelper();

  @override
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetOptions = [
      WindingJobFinishScreen(
        onChange: (value) {
          setState(() {
            listHoldWindingFinish = value;
          });
        },
      ),
      WindingJobFinishHoldScreen(
        onChange: (value) {
          setState(() {
            listHoldWindingFinish = value;
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
            Label("Winding Finish"),
            SizedBox(
              width: 10,
            ),
            Label(
              "-${listHoldWindingFinish.length ?? 0}-",
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
