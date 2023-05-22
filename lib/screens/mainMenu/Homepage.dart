import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hitachi/blocs/lineElement/line_element_bloc.dart';

import 'package:hitachi/helper/background/bg_white.dart';
import 'package:hitachi/helper/button/cardButton.dart';
import 'package:hitachi/helper/colors/colors.dart';
import 'package:hitachi/helper/text/label.dart';
import 'package:hitachi/models/checkPackNo_Model.dart';
import 'package:hitachi/models/materialInput/materialOutputModel.dart';
import 'package:hitachi/models/reportRouteSheet/reportRouteSheetModel.dart';
import 'package:hitachi/route/router_list.dart';
import 'package:hitachi/services/databaseHelper.dart';

class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({super.key});

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  int batch = 100136982104;
  ReportRouteSheetModel? items;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: BgWhite(
        isHidePreviour: true,
        textTitle: "Element : Main Menu",
        body: Padding(
          padding:
              const EdgeInsets.only(top: 0, bottom: 10, right: 10, left: 10),
          child: SingleChildScrollView(
            child: Container(
              child: Column(
                children: <Widget>[
                  CardButton(
                    text: "1.Line Element",
                    onPress: () => Navigator.pushNamed(
                        context, RouterList.LINE_ELEMENT_SCREEN),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  CardButton(
                    text: "2.Plan Winding",
                    onPress: () =>
                        Navigator.pushNamed(context, RouterList.Plan_winding),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  CardButton(
                    text: "3.Machine Breakdown",
                    onPress: () => Navigator.pushNamed(
                        context, RouterList.MachineBreakDown_control_Screen),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  CardButton(
                    text: "4.PM Daily",
                    onPress: () => print("test2"),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  CardButton(
                    text: "5.Film Receive",
                    onPress: () => Navigator.pushNamed(
                        context, RouterList.FilmReceive_control_Screen),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  CardButton(
                    text: "6.Zinc Thickness",
                    onPress: () => Navigator.pushNamed(
                        context, RouterList.ZincThickness_control),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  CardButton(
                    color: COLOR_SUCESS,
                    textAlign: TextAlign.center,
                    text: "Setting Web",
                    colortext: COLOR_BLUE_DARK,
                    fontWeight: FontWeight.bold,
                    onPress: () =>
                        Navigator.pushNamed(context, RouterList.Setting_web),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  CardButton(
                    color: COLOR_RED,
                    text: "ExitApp",
                    onPress: () => showExitPopup(context),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> showExitPopup(context) async {
    return await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Container(
              height: 90,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Do you want to exit?"),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            print('yes selected');
                            exit(0);
                          },
                          child: Text("Yes"),
                          style: ElevatedButton.styleFrom(
                              primary: Colors.red.shade800),
                        ),
                      ),
                      SizedBox(width: 15),
                      Expanded(
                          child: ElevatedButton(
                        onPressed: () {
                          print('no selected');
                          Navigator.of(context).pop();
                        },
                        child:
                            Text("No", style: TextStyle(color: Colors.black)),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                        ),
                      ))
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }
}
