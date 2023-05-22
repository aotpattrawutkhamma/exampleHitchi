import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hitachi/blocs/treatment/treatment_bloc.dart';
import 'package:hitachi/helper/background/bg_white.dart';
import 'package:hitachi/helper/button/Button.dart';
import 'package:hitachi/helper/colors/colors.dart';
import 'package:hitachi/helper/input/rowBoxInputField.dart';
import 'package:hitachi/helper/text/label.dart';
import 'package:hitachi/models/treatmentModel/treatmentOutputModel.dart';
import 'package:hitachi/services/databaseHelper.dart';
import 'package:intl/intl.dart';

class TreatMentStartScanScreen extends StatefulWidget {
  const TreatMentStartScanScreen({super.key});

  @override
  State<TreatMentStartScanScreen> createState() =>
      _TreatMentStartScanScreenState();
}

class _TreatMentStartScanScreenState extends State<TreatMentStartScanScreen> {
  final TextEditingController _machineNoController = TextEditingController();
  final TextEditingController _operatorNameController = TextEditingController();
  final TextEditingController _batch1Controller = TextEditingController();
  final TextEditingController _batch2Controller = TextEditingController();
  final TextEditingController _batch3Controller = TextEditingController();
  final TextEditingController _batch4Controller = TextEditingController();
  final TextEditingController _batch5Controller = TextEditingController();
  final TextEditingController _batch6Controller = TextEditingController();
  final TextEditingController _batch7Controller = TextEditingController();
  //FOCUS
  final f1 = FocusNode();
  final f2 = FocusNode();
  final f3 = FocusNode();
  final f4 = FocusNode();
  final f5 = FocusNode();
  final f6 = FocusNode();
  final f7 = FocusNode();
  final f8 = FocusNode();
  final f9 = FocusNode();
  final f10 = FocusNode();
//

  Color? bgChange;

  DatabaseHelper databaseHelper = DatabaseHelper();

  void _btnSend() async {
    if (_machineNoController.text.isNotEmpty &&
        _operatorNameController.text.isNotEmpty &&
        _batch1Controller.text.isNotEmpty) {
      _callApi();
      // _saveDataToSqlite();
    } else {
      EasyLoading.showError("Please Input Info");
    }
  }

  void _callApi() {
    BlocProvider.of<TreatmentBloc>(context).add(
      TreatmentStartSendEvent(TreatMentOutputModel(
        MACHINE_NO: _machineNoController.text.trim(),
        OPERATOR_NAME: int.tryParse(_operatorNameController.text.trim()),
        BATCH_NO_1: _batch1Controller.text.trim(),
        BATCH_NO_2: _batch2Controller.text.trim(),
        BATCH_NO_3: _batch3Controller.text.trim(),
        BATCH_NO_4: _batch4Controller.text.trim(),
        BATCH_NO_5: _batch5Controller.text.trim(),
        BATCH_NO_6: _batch6Controller.text.trim(),
        BATCH_NO_7: _batch7Controller.text.trim(),
        START_DATE: DateTime.now().toString(),
      )),
    );
  }

  void _saveDataToSqlite() async {
    await databaseHelper.insertSqlite('TREATMENT_SHEET', {
      'MachineNo': _machineNoController.text.trim(),
      'OperatorName': _operatorNameController.text.trim(),
      'Batch1': _batch1Controller.text.trim(),
      'Batch2':
          _batch2Controller.text.isEmpty ? "" : _batch2Controller.text.trim(),
      'Batch3':
          _batch3Controller.text.isEmpty ? "" : _batch3Controller.text.trim(),
      'Batch4':
          _batch4Controller.text.isEmpty ? "" : _batch4Controller.text.trim(),
      'Batch5':
          _batch5Controller.text.isEmpty ? "" : _batch5Controller.text.trim(),
      'Batch6':
          _batch6Controller.text.isEmpty ? "" : _batch6Controller.text.trim(),
      'Batch7':
          _batch7Controller.text.isEmpty ? "" : _batch7Controller.text.trim(),
      'StartDate': DateFormat('dd MMM yyyy HH:mm').format(DateTime.now()),
      'FinDate': '',
      'StartEnd': '',
      'CheckComplete': 'S',
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<TreatmentBloc, TreatmentState>(
          listener: (context, state) {
            if (state is TreatmentStartSendLoadingState) {
              EasyLoading.show(status: "Loading...");
            } else if (state is TreatmentStartSendLoadedState) {
              if (state.item.RESULT == true) {
                EasyLoading.showSuccess("Send Complete.");
              } else if (state.item.RESULT == false) {
                if (_machineNoController.text.isNotEmpty &&
                    _operatorNameController.text.isNotEmpty &&
                    _batch1Controller.text.isNotEmpty) {
                  EasyLoading.showError("Can not send & save Data");
                  _saveDataToSqlite();
                } else {
                  EasyLoading.showError("Please Input Info");
                }
              } else {
                if (_machineNoController.text.isNotEmpty &&
                    _operatorNameController.text.isNotEmpty &&
                    _batch1Controller.text.isNotEmpty) {
                  EasyLoading.showError("Please Check Internet & save Data");
                  _saveDataToSqlite();
                } else {
                  EasyLoading.showError("Please Input Info");
                }
              }
            }
          },
        )
      ],
      child: BgWhite(
          isHideAppBar: true,
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  RowBoxInputField(
                    focusNode: f1,
                    onEditingComplete: () => f2.requestFocus(),
                    labelText: "Machine No. : ",
                    height: 35,
                    maxLength: 3,
                    controller: _machineNoController,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  RowBoxInputField(
                    focusNode: f2,
                    onEditingComplete: () => f3.requestFocus(),
                    labelText: "Operator Name : ",
                    height: 35,
                    maxLength: 12,
                    type: TextInputType.number,
                    controller: _operatorNameController,
                    textInputFormatter: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  RowBoxInputField(
                    focusNode: f3,
                    onEditingComplete: () => f4.requestFocus(),
                    labelText: "Batch 1 : ",
                    height: 35,
                    controller: _batch1Controller,
                    type: TextInputType.number,
                    textInputFormatter: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                    onChanged: (value) {
                      if (_machineNoController.text.isNotEmpty &&
                          _operatorNameController.text.isNotEmpty &&
                          _batch1Controller.text.isNotEmpty) {
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
                  const SizedBox(
                    height: 5,
                  ),
                  RowBoxInputField(
                    focusNode: f4,
                    onEditingComplete: () => f5.requestFocus(),
                    labelText: "Batch 2 : ",
                    height: 35,
                    controller: _batch2Controller,
                    type: TextInputType.number,
                    textInputFormatter: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  RowBoxInputField(
                    focusNode: f5,
                    onEditingComplete: () => f6.requestFocus(),
                    labelText: "Batch 3 : ",
                    height: 35,
                    controller: _batch3Controller,
                    type: TextInputType.number,
                    textInputFormatter: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  RowBoxInputField(
                    focusNode: f6,
                    onEditingComplete: () => f7.requestFocus(),
                    labelText: "Batch 4 : ",
                    height: 35,
                    controller: _batch4Controller,
                    type: TextInputType.number,
                    textInputFormatter: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  RowBoxInputField(
                    focusNode: f7,
                    onEditingComplete: () => f8.requestFocus(),
                    labelText: "Batch 5 : ",
                    height: 35,
                    controller: _batch5Controller,
                    type: TextInputType.number,
                    textInputFormatter: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: RowBoxInputField(
                          focusNode: f8,
                          onEditingComplete: () => f9.requestFocus(),
                          labelText: "Batch 6 : ",
                          height: 35,
                          controller: _batch6Controller,
                          type: TextInputType.number,
                          textInputFormatter: [
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Expanded(
                        child: RowBoxInputField(
                          focusNode: f9,
                          onEditingComplete: () => _btnSend(),
                          labelText: "Batch 7 : ",
                          height: 35,
                          controller: _batch7Controller,
                          type: TextInputType.number,
                          textInputFormatter: [
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Button(
                    height: 40,
                    bgColor: bgChange ?? Colors.grey,
                    text: Label(
                      "Send",
                      color: COLOR_WHITE,
                    ),
                    onPress: () => _btnSend(),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
