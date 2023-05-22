import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hitachi/blocs/lineElement/line_element_bloc.dart';
import 'package:hitachi/helper/background/bg_white.dart';
import 'package:hitachi/helper/button/Button.dart';
import 'package:hitachi/helper/colors/colors.dart';
import 'package:hitachi/helper/input/boxInputField.dart';
import 'package:hitachi/helper/text/label.dart';
import 'package:hitachi/models/ResponeDefault.dart';
import 'package:hitachi/models/materialInput/materialInputModel.dart';
import 'package:hitachi/models/materialInput/materialOutputModel.dart';
import 'package:hitachi/route/router_list.dart';
import 'package:hitachi/services/databaseHelper.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqlite_api.dart';

class MaterialInputScreen extends StatefulWidget {
  const MaterialInputScreen({super.key});

  @override
  State<MaterialInputScreen> createState() => _MaterialInputScreenState();
}

class _MaterialInputScreenState extends State<MaterialInputScreen> {
  final TextEditingController _materialController = TextEditingController();
  final TextEditingController _operatorNameController = TextEditingController();
  final TextEditingController _batchOrSerialController =
      TextEditingController();
  final TextEditingController _machineOrProcessController =
      TextEditingController();
  final TextEditingController _lotNoController = TextEditingController();
//Foucs
  final _materialFoucus = FocusNode();
  final _operatorNameFouc = FocusNode();
  final _batchOrSerialFocus = FocusNode();
  final _machineFocus = FocusNode();
  final _lotNoFocus = FocusNode();

  Color bgColor = Colors.grey;

  final DateTime _dateTime = DateTime.now();
  MaterialInputModel? _inputMtModel;
  DatabaseHelper databaseHelper = DatabaseHelper();
  ResponeDefault? _responeDefault;

  @override
  void initState() {
    // _insertSqlite();
    // TODO: implement initState
    super.initState();
  }

  void checkValueController() {
    if (_machineOrProcessController.text.isNotEmpty &&
        _operatorNameController.text.isNotEmpty &&
        _batchOrSerialController.text.isNotEmpty &&
        _machineOrProcessController.text.isNotEmpty &&
        _lotNoController.text.isNotEmpty) {
      _callApi();
    } else {
      EasyLoading.showInfo("กรุณาใส่ข้อมูลให้ครบ");
    }
  }

  void _callApi() async {
    BlocProvider.of<LineElementBloc>(context).add(
      MaterialInputEvent(
        MaterialOutputModel(
          MATERIAL: _materialController.text.trim(),
          MACHINENO: _machineOrProcessController.text.trim(),
          OPERATORNAME: int.tryParse(_operatorNameController.text.trim()),
          BATCHNO: int.tryParse(_batchOrSerialController.text.trim()),
          LOT: _lotNoController.text.trim(),
          STARTDATE: _dateTime.toString(),
        ),
      ),
    );
  }

  void _insertSqlite() async {
    await databaseHelper.insertSqlite('MATERIAL_TRACE_SHEET', {
      'Material': _materialController.text.trim(),
      'OperatorName': _operatorNameController.text.trim(),
      'BatchNo': _batchOrSerialController.text.trim(),
      'MachineNo': _machineOrProcessController.text.trim(),
      'LotNo1': _lotNoController.text.trim(),
      'Date1': DateFormat('dd MMM yyyy HH:mm').format(DateTime.now())
    });
  }

  @override
  Widget build(BuildContext context) {
    return BgWhite(
      isHideAppBar: true,
      textTitle: "MaterialInput",
      body: MultiBlocListener(
        listeners: [
          BlocListener<LineElementBloc, LineElementState>(
            listener: (context, state) {
              if (state is MaterialInputLoadingState) {
                EasyLoading.show(status: "Loading ...");
              } else if (state is MaterialInputLoadedState) {
                EasyLoading.dismiss();
                print("object");
                setState(() {
                  _inputMtModel = state.item;
                });

                if (_inputMtModel!.RESULT == true) {
                  setState(() {
                    bgColor = Colors.grey;
                  });
                  _materialController.clear();
                  _operatorNameController.clear();
                  _batchOrSerialController.clear();
                  _machineOrProcessController.clear();
                  _lotNoController.clear();
                  EasyLoading.showSuccess("${_inputMtModel?.MESSAGE}",
                      duration: Duration(seconds: 5));
                  _materialFoucus.requestFocus();
                } else if (_inputMtModel!.RESULT == false) {
                  if (_machineOrProcessController.text.isNotEmpty &&
                      _operatorNameController.text.isNotEmpty &&
                      _batchOrSerialController.text.isNotEmpty &&
                      _machineOrProcessController.text.isNotEmpty &&
                      _lotNoController.text.isNotEmpty) {
                    _insertSqlite();
                    EasyLoading.showError("Failed To Send");
                  } else {
                    EasyLoading.showInfo("กรุณาใส่ข้อมูลให้ครบ");
                  }
                } else {
                  if (_machineOrProcessController.text.isNotEmpty &&
                      _operatorNameController.text.isNotEmpty &&
                      _batchOrSerialController.text.isNotEmpty &&
                      _machineOrProcessController.text.isNotEmpty &&
                      _lotNoController.text.isNotEmpty) {
                    _insertSqlite();
                    EasyLoading.showError(
                        "Please Check Connection Internet & Save Complete");
                  } else {
                    EasyLoading.showInfo("กรุณาใส่ข้อมูลให้ครบ");
                  }
                }
              }
              if (state is CheckMaterialInputLoadingState) {
                EasyLoading.show();
              }
              if (state is CheckMaterialInputLoadedState) {
                setState(() {
                  _responeDefault = state.item;
                });
                if (_responeDefault!.RESULT == true) {
                  EasyLoading.showSuccess("Success");
                } else {
                  EasyLoading.showError("${_responeDefault?.MESSAGE}",
                      duration: Duration(seconds: 5));
                }
              } else if (state is CheckMaterialInputErrorState) {
                EasyLoading.dismiss();

                EasyLoading.showError("Please Check Connection");
              }
            },
          ),
        ],
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                BoxInputField(
                  focusNode: _materialFoucus,
                  labelText: "Material:",
                  controller: _materialController,
                  onEditingComplete: () {
                    BlocProvider.of<LineElementBloc>(context).add(
                      CheckMaterialInputEvent(_materialController.text.trim()),
                    );
                    _operatorNameFouc.requestFocus();
                  },
                ),
                const SizedBox(
                  height: 5,
                ),
                BoxInputField(
                  focusNode: _operatorNameFouc,
                  labelText: "Operator Name",
                  controller: _operatorNameController,
                  type: TextInputType.number,
                  textInputFormatter: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  ],
                  onEditingComplete: () {
                    _batchOrSerialFocus.requestFocus();
                  },
                ),
                const SizedBox(
                  height: 5,
                ),
                BoxInputField(
                  focusNode: _batchOrSerialFocus,
                  labelText: "Batch/Serial",
                  controller: _batchOrSerialController,
                  maxLength: 12,
                  onEditingComplete: () {
                    if (_batchOrSerialController.text.length == 7 ||
                        _batchOrSerialController.text.length == 12) {
                      _machineFocus.requestFocus();
                    }
                  },
                ),
                const SizedBox(
                  height: 5,
                ),
                BoxInputField(
                  focusNode: _machineFocus,
                  labelText: 'Machine/Process',
                  controller: _machineOrProcessController,
                  maxLength: 3,
                  onEditingComplete: () => _lotNoFocus.requestFocus(),
                ),
                const SizedBox(
                  height: 5,
                ),
                BoxInputField(
                  focusNode: _lotNoFocus,
                  labelText: "Lot No. :",
                  controller: _lotNoController,
                  onEditingComplete: () => checkValueController(),
                  textInputFormatter: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'^(?!.*\d{3})[a-zA-Z0-9]+$'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      if (value == _batchOrSerialController.text &&
                          value == _machineOrProcessController.text &&
                          value == _operatorNameController.text &&
                          value == _materialController.text) {
                        _lotNoController.text = "";
                        EasyLoading.showError("Input Again");
                      } else if (_batchOrSerialController.text.isNotEmpty &&
                          _machineOrProcessController.text.isNotEmpty &&
                          _operatorNameController.text.isNotEmpty &&
                          _materialController.text.isNotEmpty) {
                        setState(() {
                          bgColor = COLOR_RED;
                        });
                      } else {
                        setState(() {
                          bgColor = COLOR_BLUE_DARK;
                        });
                      }
                    });
                  },
                ),
                const SizedBox(
                  height: 5,
                ),
                Button(
                  bgColor: bgColor,
                  text: Label(
                    "Send",
                    color: COLOR_WHITE,
                  ),
                  onPress: () {
                    checkValueController();
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Future<void> _selectedSqliteAndInsert({
  //   String? material,
  //   String? typeMaterial,
  //   String? operatorName,
  //   String? batchNo,
  //   String? machineNo,
  //   String? material1,
  //   String? lotNo1,
  //   String? date1,
  //   String? material2,
  //   String? lotNo2,
  //   String? date2,
  // }) async {
  //   try {
  //     switch (typeMaterial) {
  //       case "B":
  //         {
  //           await databaseHelper.queryTypeMaterial(
  //               material: material,
  //               value: machineNo,
  //               value2: operatorName,
  //               value3: batchNo,
  //               value4: lotNo1,
  //               value5: date1);

  // await databaseHelper.insertSqlite('MATERIAL_TRACE_SHEET', {
  //   'Material': material,
  //   'Type': typeMaterial,
  //   'OperatorName': operatorName,
  //   'BatchNo': batchNo,
  //   'MachineNo': null,
  //   'Material1': null,
  //   'LotNo1': lotNo1,
  //   'Date1': date1,
  //   'Material2': null,
  //   'LotNo2': null,
  //   'Date2': null,
  // });
  //           //dosomethings
  //         }
  //         break;
  //       case "P1":
  //         {
  //           await databaseHelper.queryTypeMaterial(
  //               material: material,
  //               value: typeMaterial,
  //               value2: operatorName,
  //               value3: batchNo,
  //               value4: lotNo1,
  //               value5: date1);

  //           await databaseHelper.insertSqlite('MATERIAL_TRACE_SHEET', {
  //             'Material': material,
  //             'Type': typeMaterial,
  //             'OperatorName': operatorName,
  //             'BatchNo': null,
  //             'MachineNo': machineNo,
  //             'Material1': null,
  //             'LotNo1': lotNo1,
  //             'Date1': date1,
  //             'Material2': null,
  //             'LotNo2': null,
  //             'Date2': null,
  //           });
  //           //dosomethings
  //         }
  //         break;
  //       case "P22":
  //         {
  //           await databaseHelper.queryTypeMaterialAll(
  //               material: material,
  //               value: typeMaterial,
  //               value2: operatorName,
  //               value3: batchNo,
  //               valueMaterial1: material1,
  //               value4: lotNo1,
  //               value5: date1,
  //               value6: material2,
  //               value7: lotNo2,
  //               value8: date2);

  //           await databaseHelper.insertSqlite('MATERIAL_TRACE_SHEET', {
  //             'Material': material,
  //             'Type': typeMaterial,
  //             'OperatorName': operatorName,
  //             'BatchNo': batchNo,
  //             'MachineNo': machineNo,
  //             'Material1': material1,
  //             'LotNo1': lotNo1,
  //             'Date1': date1,
  //             'Material2': material2,
  //             'LotNo2': lotNo2,
  //             'Date2': date2,
  //           });
  //           //dosomethings
  //         }
  //         break;
  //     }
  //   } catch (e) {
  //     print(e);
  //   }
  // }
}
