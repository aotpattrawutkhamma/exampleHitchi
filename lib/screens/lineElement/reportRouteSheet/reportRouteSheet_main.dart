import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hitachi/blocs/lineElement/line_element_bloc.dart';
import 'package:hitachi/helper/background/bg_white.dart';
import 'package:hitachi/helper/colors/colors.dart';
import 'package:hitachi/helper/input/boxInputField.dart';
import 'package:hitachi/helper/text/label.dart';
import 'package:hitachi/models/reportRouteSheet/reportRouteSheetModel.dart';
import 'package:hitachi/screens/lineElement/reportRouteSheet/page/problemPage.dart';
import 'package:hitachi/screens/lineElement/reportRouteSheet/page/processPage.dart';

import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class ReportRouteSheetScreen extends StatefulWidget {
  const ReportRouteSheetScreen({super.key});

  @override
  State<ReportRouteSheetScreen> createState() => _ReportRouteSheetScreenState();
}

class _ReportRouteSheetScreenState extends State<ReportRouteSheetScreen> {
  String sendValueController = '';
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetOptions = [
      ProcessPage(
        onChange: (value) {
          setState(() {
            sendValueController = value;
          });
        },
        receiveValue: sendValueController,
      ),
      ProblemPage(
        valueString: sendValueController,
      ),
    ];

    return BgWhite(
      textTitle: Label("ReportRouteSheet"),
      body: Center(
        child: widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.aod),
            label: 'Process',
            backgroundColor: Colors.red,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work),
            label: 'Problem',
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
