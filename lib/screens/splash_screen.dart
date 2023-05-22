import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hitachi/helper/background/bg_white.dart';
import 'package:hitachi/helper/colors/colors.dart';
import 'package:hitachi/helper/text/label.dart';
import 'package:hitachi/route/router_list.dart';
import 'package:hitachi/services/databaseHelper.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final spinkit = SpinKitDualRing(
    color: COLOR_WHITE,
    size: 100,
  );
  DatabaseHelper databaseHelper = DatabaseHelper();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    CreateDatabase();
  }

  void CreateDatabase() async {
    // สร้างฐานข้อมูล SQLite และตาราง my_table
    try {
      Timer(Duration(seconds: 5), () {
        Navigator.pushNamed(context, RouterList.MAIN_MENU);
      });
      await databaseHelper.initializeDatabase();
    } catch (e, s) {
      EasyLoading.showError("Please Call Oga");
    }
  }

  @override
  Widget build(BuildContext context) {
    return BgWhite(
      isHideAppBar: true,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: COLOR_BLUE_DARK,
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Label(
              "Document Control",
              fontSize: 30,
              color: COLOR_WHITE,
            ),
            SizedBox(
              height: 50,
            ),
            spinkit
          ],
        )),
      ),
    );
  }
}
