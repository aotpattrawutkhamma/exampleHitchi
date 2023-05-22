import 'package:flutter/material.dart';
import 'package:hitachi/helper/background/bg_white.dart';
import 'package:hitachi/helper/colors/colors.dart';
import 'package:hitachi/screens/filmreceive/hold/filmReceive_hold_screen.dart';
import 'package:hitachi/screens/filmreceive/scan/filmReceive_scan_screen.dart';

class FilmReceiveControlPage extends StatefulWidget {
  const FilmReceiveControlPage({super.key});

  @override
  State<FilmReceiveControlPage> createState() => _FilmReceiveControlPageState();
}

class _FilmReceiveControlPageState extends State<FilmReceiveControlPage> {
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
    FilmReceiveScanScreen(),
    FilmReceiveHoldScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return BgWhite(
      textTitle: "Film Receive",
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
