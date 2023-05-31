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
  MaterialInputScreen({super.key, this.onChange});
  ValueChanged<List<Map<String, dynamic>>>? onChange;

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
    _materialFoucus.requestFocus();
    // _insertSqlite();
    // TODO: implement initState
    super.initState();
  }

  Future _getHold() async {
    List<Map<String, dynamic>> sql =
        await databaseHelper.queryAllRows('MATERIAL_TRACE_SHEET');
    setState(() {
      widget.onChange?.call(sql);
    });
  }

  void checkValueController() {
    if (_machineOrProcessController.text.isNotEmpty &&
        _operatorNameController.text.isNotEmpty &&
        _batchOrSerialController.text.isNotEmpty &&
        _machineOrProcessController.text.isNotEmpty &&
        _lotNoController.text.length != 3) {
      _callApi();
    } else {
      EasyLoading.showInfo("Please Input Data");
    }
  }

  void _callApi() async {
    BlocProvider.of<LineElementBloc>(context).add(
      MaterialInputEvent(
        MaterialOutputModel(
          MATERIAL: _materialController.text.trim(),
          MACHINENO: _machineOrProcessController.text.trim(),
          OPERATORNAME: int.tryParse(_operatorNameController.text.trim()),
          BATCHNO: _batchOrSerialController.text.trim(),
          LOT: _lotNoController.text.trim(),
          STARTDATE: DateFormat('yyyy MM dd HH:mm').format(DateTime.now()),
        ),
      ),
    );
  }

  Future _insertSqlite() async {
    await databaseHelper.insertSqlite('MATERIAL_TRACE_SHEET', {
      'Material': _materialController.text.trim(),
      'OperatorName': _operatorNameController.text.trim(),
      'BatchNo': _batchOrSerialController.text.trim(),
      'MachineNo': _machineOrProcessController.text.trim(),
      'LotNo1': _lotNoController.text.trim(),
      'Date1': DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now())
    });
  }

  @override
  Widget build(BuildContext context) {
    return BgWhite(
      isHideAppBar: true,
      body: MultiBlocListener(
        listeners: [
          BlocListener<LineElementBloc, LineElementState>(
            listener: (context, state) async {
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
                  _errorDialog(
                      isHideCancle: false,
                      text: Label("${_inputMtModel?.MESSAGE}"),
                      onpressOk: () {
                        Navigator.pop(context);
                        _materialController.clear();
                        _operatorNameController.clear();
                        _batchOrSerialController.clear();
                        _machineOrProcessController.clear();
                        _lotNoController.clear();
                        _materialFoucus.requestFocus();
                      });
                } else if (_inputMtModel!.RESULT == false) {
                  EasyLoading.dismiss();
                  if (_machineOrProcessController.text.isNotEmpty &&
                      _operatorNameController.text.isNotEmpty &&
                      _batchOrSerialController.text.isNotEmpty &&
                      _machineOrProcessController.text.isNotEmpty &&
                      _lotNoController.text.isNotEmpty) {
                    _errorDialog(
                        text: Label(
                            "${_inputMtModel?.MESSAGE ?? "Check Connection"}"),
                        onpressOk: () async {
                          await _insertSqlite();
                          await _getHold();
                          _materialController.clear();
                          _operatorNameController.clear();
                          _batchOrSerialController.clear();
                          _machineOrProcessController.clear();
                          _lotNoController.clear();
                          _materialFoucus.requestFocus();
                          Navigator.pop(context);
                        });
                  } else {
                    EasyLoading.showInfo("Please Input Data");
                  }
                } else {
                  EasyLoading.dismiss();
                  if (_machineOrProcessController.text.isNotEmpty &&
                      _operatorNameController.text.isNotEmpty &&
                      _batchOrSerialController.text.isNotEmpty &&
                      _machineOrProcessController.text.isNotEmpty &&
                      _lotNoController.text.isNotEmpty) {
                    _errorDialog(
                        text: Label(
                            "Please Check Connection Internet\n Do you want to Save Data ?"),
                        onpressOk: () async {
                          await _insertSqlite();
                          await _getHold();
                          _materialController.clear();
                          _operatorNameController.clear();
                          _batchOrSerialController.clear();
                          _machineOrProcessController.clear();
                          _lotNoController.clear();
                          setState(() {
                            bgColor = Colors.grey;
                          });
                          _materialFoucus.requestFocus();
                          Navigator.pop(context);
                        });
                  } else {
                    EasyLoading.showInfo("Please Input Data");
                  }
                }
              }
              if (state is CheckMaterialInputLoadingState) {
                EasyLoading.show();
              }
              if (state is CheckMaterialInputLoadedState) {
                EasyLoading.dismiss();
                setState(() {
                  _responeDefault = state.item;
                });
                if (_responeDefault!.RESULT == true) {
                  _operatorNameFouc.requestFocus();
                } else {
                  print("Count");
                  _errorDialog(
                      isHideCancle: false,
                      text: Label(
                          "${_responeDefault?.MESSAGE ?? "Check Connection"}"),
                      onpressOk: () {
                        _materialController.clear();
                        Navigator.pop(context);
                      });
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
                  maxLength: 255,
                  onEditingComplete: () {
                    if (_lotNoController.text.length != 3) {
                      checkValueController();
                    } else if (_lotNoController.text.length == 3) {}
                  },
                  textInputFormatter: [
                    // FilteringTextInputFormatter.allow(
                    //   RegExp(r'^(?!.*\d{4})[a-zA-Z0-9]+$'),
                    // ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      if (value == _batchOrSerialController.text &&
                          value == _machineOrProcessController.text &&
                          value == _operatorNameController.text &&
                          value == _materialController.text) {
                        _lotNoController.text = "";
                        _errorDialog(
                            text: Label("Please Input Lot No. Again"),
                            onpressOk: () => Navigator.pop(context));
                      } else if (_batchOrSerialController.text.isNotEmpty &&
                          _machineOrProcessController.text.isNotEmpty &&
                          _operatorNameController.text.isNotEmpty &&
                          _materialController.text.isNotEmpty) {
                        setState(() {
                          bgColor = COLOR_BLUE_DARK;
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

  void _errorDialog(
      {Label? text,
      Function? onpressOk,
      Function? onpressCancel,
      bool isHideCancle = true}) async {
    // EasyLoading.showError("Error[03]", duration: Duration(seconds: 5));//if password
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        // title: const Text('AlertDialog Title'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: text,
            ),
          ],
        ),

        actions: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Visibility(
                visible: isHideCancle,
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll(COLOR_BLUE_DARK)),
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
              ),
              Visibility(
                visible: isHideCancle,
                child: SizedBox(
                  width: 15,
                ),
              ),
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(COLOR_BLUE_DARK)),
                onPressed: () => onpressOk?.call(),
                child: const Text('OK'),
              ),
            ],
          )
        ],
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
