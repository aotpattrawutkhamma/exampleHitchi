// ignore_for_file: unrelated_type_equality_checks

import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hitachi/blocs/lineElement/line_element_bloc.dart';
import 'package:hitachi/helper/background/bg_white.dart';
import 'package:hitachi/helper/button/Button.dart';
import 'package:hitachi/helper/colors/colors.dart';
import 'package:hitachi/helper/input/boxInputField.dart';
import 'package:hitachi/helper/input/rowBoxInputField.dart';
import 'package:hitachi/helper/text/label.dart';
import 'package:hitachi/models-Sqlite/processModel.dart';
import 'package:hitachi/models/processStart/processOutputModel.dart';
import 'package:hitachi/services/databaseHelper.dart';

class ProcessStartScanScreen extends StatefulWidget {
  const ProcessStartScanScreen({super.key});

  @override
  State<ProcessStartScanScreen> createState() => _ProcessStartScanScreenState();
}

class _ProcessStartScanScreenState extends State<ProcessStartScanScreen> {
  final TextEditingController MachineController = TextEditingController();
  final TextEditingController operatorNameController = TextEditingController();
  final TextEditingController operatorName1Controller = TextEditingController();
  final TextEditingController operatorName2Controller = TextEditingController();
  final TextEditingController operatorName3Controller = TextEditingController();
  final TextEditingController batchNoController = TextEditingController();
  Color? bgChange;

  final f1 = FocusNode();
  final f2 = FocusNode();
  final f3 = FocusNode();
  final f4 = FocusNode();
  final f5 = FocusNode();
  final f6 = FocusNode();

  DatabaseHelper databaseHelper = DatabaseHelper();
  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<LineElementBloc, LineElementState>(
          listener: (context, state) {
            if (state is ProcessStartLoadingState) {
              // EasyLoading.show();
              print("loading");
            }
            if (state is ProcessStartLoadedState) {
              print("ss");
              EasyLoading.show(status: "Loaded");
              // if (state.item.RESULT == true) {
              //   EasyLoading.showSuccess("SendComplete");
              // } else if (state.item.RESULT == false) {
              //   EasyLoading.showError("Can not send & save Data");
              //   _saveSendSqlite();
              // } else {
              //   EasyLoading.showError("Can not Call API");
              //   // _saveSendSqlite();
              // }
            } else if (state is ProcessStartErrorState) {
              print("ERROR");
              // EasyLoading.dismiss();
              // _saveSendSqlite();
              // EasyLoading.showError("Please Check Connection Internet");
            }
          },
        )
      ],
      child: BgWhite(
          isHideAppBar: true,
          textTitle: "Process Start",
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  RowBoxInputField(
                    labelText: "Machine No :",
                    maxLength: 3,
                    controller: MachineController,
                    height: 35,
                    focusNode: f1,
                    onEditingComplete: () => f2.requestFocus(),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  RowBoxInputField(
                    labelText: "Operator Name :",
                    height: 35,
                    controller: operatorNameController,
                    maxLength: 12,
                    focusNode: f2,
                    onEditingComplete: () => f3.requestFocus(),
                    textInputFormatter: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'^(?!.*\d{12})[a-zA-Z0-9]+$'),
                      ),
                    ],
                    onChanged: (value) {
                      if (MachineController.text.isNotEmpty &&
                          batchNoController.text.isNotEmpty) {
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
                  DottedLine(),
                  SizedBox(
                    height: 5,
                  ),
                  RowBoxInputField(
                    labelText: "Operator Name :",
                    height: 35,
                    maxLength: 12,
                    controller: operatorName1Controller,
                    focusNode: f3,
                    onEditingComplete: () => f4.requestFocus(),
                    textInputFormatter: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'^(?!.*\d{12})[a-zA-Z0-9]+$'),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  RowBoxInputField(
                    labelText: "Operator Name :",
                    height: 35,
                    maxLength: 12,
                    controller: operatorName2Controller,
                    focusNode: f4,
                    onEditingComplete: () => f5.requestFocus(),
                    textInputFormatter: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'^(?!.*\d{12})[a-zA-Z0-9]+$'),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  RowBoxInputField(
                    labelText: "Operator Name :",
                    height: 35,
                    maxLength: 12,
                    controller: operatorName3Controller,
                    focusNode: f5,
                    onEditingComplete: () => f6.requestFocus(),
                    textInputFormatter: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'^(?!.*\d{12})[a-zA-Z0-9]+$'),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  DottedLine(),
                  SizedBox(
                    height: 5,
                  ),
                  RowBoxInputField(
                    labelText: "Batch No :",
                    maxLength: 12,
                    height: 35,
                    controller: batchNoController,
                    type: TextInputType.number,
                    focusNode: f6,
                    textInputFormatter: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                    onChanged: (value) {
                      if (MachineController.text.isNotEmpty &&
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
                    height: 10,
                  ),
                  Row(
                    children: [
                      Visibility(
                        visible: true,
                        child: Container(
                            child: Label(
                          "Batch No. INVAILD",
                          color: COLOR_RED,
                        )),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    child: Button(
                      height: 40,
                      bgColor: bgChange ?? Colors.grey,
                      text: Label(
                        "Send",
                        color: COLOR_WHITE,
                      ),
                      onPress: () => _btnSend(),
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }

  void _saveSendSqlite() async {
    try {
      if (operatorNameController.text.isNotEmpty) {
        await databaseHelper.insertSqlite('PROCESS_SHEET', {
          'Machine': MachineController.text.trim(),
          'OperatorName': operatorNameController.text.trim(),
          'OperatorName1': operatorName1Controller.text == null
              ? ""
              : operatorName1Controller.text.trim(),
          'OperatorName2': operatorName2Controller.text == null
              ? ""
              : operatorName2Controller.text.trim(),
          'OperatorName3': operatorName3Controller.text == null
              ? ""
              : operatorName3Controller.text.trim(),
          'BatchNo': batchNoController.text.trim(),
          'StartDate': DateTime.now().toString(),
        });
        print("ok");
      }
    } catch (e) {
      print(e);
    }
  }

  void _btnSend() async {
    if (MachineController.text.isNotEmpty &&
        operatorNameController.text.isNotEmpty &&
        batchNoController.text.isNotEmpty) {
      _callAPI();
      // _saveDataToSqlite();
    } else {
      EasyLoading.showInfo("กรุณาใส่ข้อมูลให้ครบ");
    }
  }

  void _callAPI() {
    BlocProvider.of<LineElementBloc>(context).add(
      ProcessStartEvent(ProcessOutputModel(
        MACHINE: MachineController.text.trim(),
        OPERATORNAME: int.tryParse(operatorNameController.text.trim()),
        OPERATORNAME1: int.tryParse(operatorName1Controller.text.trim()),
        OPERATORNAME2: int.tryParse(operatorName2Controller.text.trim()),
        OPERATORNAME3: int.tryParse(operatorName3Controller.text.trim()),
        BATCHNO: batchNoController.text.trim(),
        STARTDATE: DateTime.now().toString(),
      )),
    );
  }
}
