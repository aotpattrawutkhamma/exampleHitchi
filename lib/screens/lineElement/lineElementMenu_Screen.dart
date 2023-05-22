import 'package:flutter/material.dart';
import 'package:hitachi/helper/background/bg_white.dart';
import 'package:hitachi/helper/button/cardButton2.dart';
import 'package:hitachi/helper/text/label.dart';
import 'package:hitachi/route/router_list.dart';

class LineElementScreen extends StatefulWidget {
  const LineElementScreen({super.key});

  @override
  State<LineElementScreen> createState() => _LineElementScreenState();
}

class _LineElementScreenState extends State<LineElementScreen> {
  @override
  Widget build(BuildContext context) {
    return BgWhite(
      isHideTitle: false,
      textTitle: "Line Element : Menu",
      body: GridView.count(
        primary: false,
        padding: const EdgeInsets.all(20),
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        crossAxisCount: 2,
        children: <Widget>[
          CardButton2(
            text: "Winding\nStart",
            onPress: () => Navigator.pushNamed(
                context, RouterList.WindingJobStart_Control_Screen),
          ),
          CardButton2(
            text: "Winding\nFinish",
            onPress: () => Navigator.pushNamed(
                context, RouterList.WindingJobFinish_Control_Screen),
          ),
          CardButton2(
            text: "Process\nStart",
            onPress: () => Navigator.pushNamed(
                context, RouterList.ProcessStart_Control_Screen),
          ),
          CardButton2(
            text: "Process\nFinish",
            onPress: () => Navigator.pushNamed(
                context, RouterList.ProcessFinish_control_Screen),
          ),
          CardButton2(
            text: "Treatment\nStart",
            onPress: () => Navigator.pushNamed(
                context, RouterList.TreatMentStart_control_Screen),
          ),
          CardButton2(
            text: "Treatment\nFinish",
            onPress: () => Navigator.pushNamed(
                context, RouterList.TreatmentFinish_control_Screen),
          ),
          CardButton2(
            text: "Report Route Sheet",
            onPress: () => Navigator.pushNamed(
                context, RouterList.ReportRouteSheet_control_Screen),
          ),
          CardButton2(
            text: "Material\nInput",
            onPress: () => Navigator.pushNamed(
                context, RouterList.MaterialInput_control_Screen),
          ),
        ],
      ),
    );
  }
}
