import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hitachi/helper/background/bg_white.dart';
import 'package:hitachi/helper/button/Button.dart';
import 'package:hitachi/helper/colors/colors.dart';
import 'package:hitachi/helper/input/rowBoxInputField.dart';
import 'package:hitachi/helper/text/label.dart';
import 'package:hitachi/services/databaseHelper.dart';

class ProcessFinishScanScreen extends StatefulWidget {
  const ProcessFinishScanScreen({super.key});

  @override
  State<ProcessFinishScanScreen> createState() =>
      _ProcessFinishScanScreenState();
}

class _ProcessFinishScanScreenState extends State<ProcessFinishScanScreen> {
  DatabaseHelper databaseHelper = DatabaseHelper();

  final TextEditingController MachineNoController = TextEditingController();
  final TextEditingController operatorNameController = TextEditingController();
  final TextEditingController batchNoController = TextEditingController();
  final TextEditingController rejectQtyController = TextEditingController();
  Color? bgChange;

  @override
  Widget build(BuildContext context) {
    return BgWhite(
        isHideAppBar: true,
        textTitle: "ProcessFinish",
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                RowBoxInputField(
                  labelText: "Machine No : ",
                  maxLength: 3,
                  controller: MachineNoController,
                  type: TextInputType.number,
                ),
                SizedBox(
                  height: 5,
                ),
                RowBoxInputField(
                  labelText: "Operator Name : ",
                  controller: operatorNameController,
                ),
                SizedBox(
                  height: 5,
                ),
                RowBoxInputField(
                  labelText: "Batch No : ",
                  controller: batchNoController,
                  type: TextInputType.number,
                  textInputFormatter: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  ],
                  onChanged: (value) {
                    if (MachineNoController.text.isNotEmpty &&
                        operatorNameController.text.isNotEmpty) {
                      setState(() {
                        bgChange = COLOR_RED;
                      });
                    } else {
                      setState(() {
                        bgChange = Colors.grey;
                      });
                    }
                  },
                ),
                SizedBox(
                  height: 5,
                ),
                RowBoxInputField(
                  labelText: "Reject Qty : ",
                  controller: rejectQtyController,
                  // type: TextInputType.number,
                ),
                SizedBox(
                  height: 15,
                ),
                Button(
                  height: 40,
                  bgColor: COLOR_RED,
                  text: Label(
                    "Send",
                    color: COLOR_WHITE,
                  ),
                  // onPress: () => _btnSend(),
                ),
              ],
            ),
          ),
        ));
  }

  void _testSendSqlite() async {
    try {
      await databaseHelper.insertSqlite('PROCESS_SHEET', {
        'Machine': MachineNoController.text.trim(),
        'OperatorName1': rejectQtyController.text.trim(),
        'BatchNo': int.tryParse(batchNoController.text.trim()),
        // 'RejectQty': ,
        'StartEnd': DateTime.now().toString(),
      });
      print("ok");
    } catch (e) {
      print(e);
    }
  }
}
