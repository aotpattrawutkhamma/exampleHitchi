import 'package:flutter/material.dart';
import 'package:hitachi/helper/background/bg_white.dart';
import 'package:hitachi/helper/colors/colors.dart';
import 'package:hitachi/helper/text/label.dart';
import 'package:hitachi/screens/machinebreackdown/hold/mbd_hold.dart';
import 'package:hitachi/screens/machinebreackdown/scan/mbd_scan.dart';

import '../../config.dart';
import '../../services/databaseHelper.dart';

class MachineBreackDownControl extends StatefulWidget {
  const MachineBreackDownControl({super.key});

  @override
  State<MachineBreackDownControl> createState() =>
      _MachineBreackDownControlState();
}

class _MachineBreackDownControlState extends State<MachineBreackDownControl> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Map<String, dynamic>> listHoldMachineBreakdown = [];
  @override
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    Future.delayed(Duration(microseconds: 10), () {
      setState(() {
        setState(() {
          _selectedIndex = index;
          _getHold();
        });
      });
    });
  }

  Future _getHold() async {
    List<Map<String, dynamic>> sql =
        await databaseHelper.queryAllRows('BREAKDOWN_SHEET');
    setState(() {
      listHoldMachineBreakdown = sql;
    });
  }

  @override
  void initState() {
    _getHold().then((value) => null);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetOptions = [
      MachineBreakDownScanScreen(
        onChange: (value) {
          setState(() {
            listHoldMachineBreakdown = value;
          });
        },
      ),
      MachineBreakDownHoldScreen(
        onChange: (value) {
          setState(() {
            listHoldMachineBreakdown = value;
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
            Label("Machine BreakDown"),
            SizedBox(
              width: 10,
            ),
            Label(
              "-${listHoldMachineBreakdown.length ?? 0}-",
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
