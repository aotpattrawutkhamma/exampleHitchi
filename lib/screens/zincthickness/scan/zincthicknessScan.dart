import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hitachi/blocs/zincthickness/zinc_thickness_bloc.dart';
import 'package:hitachi/config.dart';
import 'package:hitachi/helper/background/bg_white.dart';
import 'package:hitachi/helper/button/Button.dart';
import 'package:hitachi/helper/colors/colors.dart';
import 'package:hitachi/helper/input/rowBoxInputField.dart';
import 'package:hitachi/helper/text/label.dart';
import 'package:hitachi/models/zincthickness/zincOutputModel.dart';
import 'package:hitachi/services/databaseHelper.dart';
import 'package:intl/intl.dart';

class ZincThickNessScanScreen extends StatefulWidget {
  ZincThickNessScanScreen({super.key, this.onChange});
  ValueChanged<List<Map<String, dynamic>>>? onChange;

  @override
  State<ZincThickNessScanScreen> createState() =>
      _ZincThickNessScanScreenState();
}

class _ZincThickNessScanScreenState extends State<ZincThickNessScanScreen> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  final TextEditingController _batchController = TextEditingController();
  final TextEditingController _thickness1Controller = TextEditingController();
  final TextEditingController _thickness2Controller = TextEditingController();
  final TextEditingController _thickness3Controller = TextEditingController();
  final TextEditingController _thickness4Controller = TextEditingController();
  final TextEditingController _thickness6Controller = TextEditingController();
  final TextEditingController _thickness7Controller = TextEditingController();
  final TextEditingController _thickness8Controller = TextEditingController();
  final TextEditingController _thickness9Controller = TextEditingController();
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
  final batchFocus = FocusNode();
  //

  Color t1 = Colors.black;
  Color t2 = Colors.black;
  Color t3 = Colors.black;
  Color t4 = Colors.black;
  Color t6 = Colors.black;
  Color t7 = Colors.black;
  Color t8 = Colors.black;
  Color t9 = Colors.black;

  Color bgButton = Colors.grey;
  String? dateTime;

  void initState() {
    batchFocus.requestFocus();
    _getHold().then((value) => null);
    super.initState();
  }

  void _callApi() {
    String? th1;
    String? th2;
    String? th3;
    String? th4;
    String? th6;
    String? th7;
    String? th8;
    String? th9;
    setState(() {
      th1 = convertToDecimal(_thickness1Controller.text.trim()).toString();
      th2 = convertToDecimal(_thickness2Controller.text.trim()).toString();
      th3 = convertToDecimal(_thickness3Controller.text.trim()).toString();
      th4 = convertToDecimal(_thickness4Controller.text.trim()).toString();
      th6 = convertToDecimal(_thickness6Controller.text.trim()).toString();
      th7 = convertToDecimal(_thickness7Controller.text.trim()).toString();
      th8 = convertToDecimal(_thickness8Controller.text.trim()).toString();
      th9 = convertToDecimal(_thickness9Controller.text.trim()).toString();
    });
    BlocProvider.of<ZincThicknessBloc>(context).add(
      ZincThickNessSendEvent(ZincThicknessOutputModel(
          BATCHNO: _batchController.text.trim(),
          THICKNESS1: th1,
          THICKNESS2: th2,
          THICKNESS3: th3,
          THICKNESS4: th4,
          THICKNESS6: th6,
          THICKNESS7: th7,
          THICKNESS8: th8,
          THICKNESS9: th9,
          STARTDATE: DateFormat('yyyy-MMM-dd HH:mm:ss')
              .format(DateTime.now())
              .toString())),
    );
  }

  void _checkvalueController() async {
    if (_batchController.text.isNotEmpty &&
        _thickness1Controller.text.isNotEmpty &&
        _thickness2Controller.text.isNotEmpty &&
        _thickness3Controller.text.isNotEmpty &&
        _thickness4Controller.text.isNotEmpty &&
        _thickness6Controller.text.isNotEmpty &&
        _thickness7Controller.text.isNotEmpty &&
        _thickness8Controller.text.isNotEmpty &&
        _thickness9Controller.text.isNotEmpty) {
      if (t1 == COLOR_RED ||
          t2 == COLOR_RED ||
          t3 == COLOR_RED ||
          t4 == COLOR_RED) {
        _AlertDialog(text: "Please enter value thinkness 1-4 between 20-45");
      } else if (t6 == COLOR_RED ||
          t7 == COLOR_RED ||
          t8 == COLOR_RED ||
          t9 == COLOR_RED) {
        _AlertDialog(text: "Please enter value thinkness 6-9 between 45-70");
      } else {
        convertValuesToDecimal();
      }
    } else {
      EasyLoading.showError("Please Batch 12 digits");
    }
  }

  Future _insertSqlite() async {
    var sql = await databaseHelper.queryAllRows('ZINCTHICKNESS_SHEET');
    String? th1;
    String? th2;
    String? th3;
    String? th4;
    String? th6;
    String? th7;
    String? th8;
    String? th9;
    setState(() {
      th1 = convertToDecimal(_thickness1Controller.text.trim()).toString();
      th2 = convertToDecimal(_thickness2Controller.text.trim()).toString();
      th3 = convertToDecimal(_thickness3Controller.text.trim()).toString();
      th4 = convertToDecimal(_thickness4Controller.text.trim()).toString();
      th6 = convertToDecimal(_thickness6Controller.text.trim()).toString();
      th7 = convertToDecimal(_thickness7Controller.text.trim()).toString();
      th8 = convertToDecimal(_thickness8Controller.text.trim()).toString();
      th9 = convertToDecimal(_thickness9Controller.text.trim()).toString();
    });
    print(_thickness1Controller.text);
    print(_thickness2Controller.text);
    print(_thickness3Controller.text);
    print(_thickness4Controller.text);
    print(_thickness6Controller.text);
    print(_thickness7Controller.text);
    print(_thickness8Controller.text);
    print(_thickness9Controller.text);
    bool found = false;
    var items;
    for (items in sql) {
      if (_batchController.text.trim() == items['Batch'].trim()) {
        found = true;
        print(found);
        break;
      }
    }
    if (found == true) {
      await databaseHelper.updateSqlite(
        'ZINCTHICKNESS_SHEET',
        {
          'Thickness1': th1,
          'Thickness2': th2,
          'Thickness3': th3,
          'Thickness4': th4,
          'Thickness6': th6,
          'Thickness7': th7,
          'Thickness8': th8,
          'Thickness9': th9,
        },
        'Batch = ?',
        [_batchController.text.trim()],
      );

      f1.requestFocus();
      print("isUpdate");
    } else {
      print("isNotUpdate");
      await databaseHelper.insertSqlite('ZINCTHICKNESS_SHEET', {
        'Batch': _batchController.text.trim(),
        'Thickness1': th1,
        'Thickness2': th2,
        'Thickness3': th3,
        'Thickness4': th4,
        'Thickness6': th6,
        'Thickness7': th7,
        'Thickness8': th8,
        'Thickness9': th9,
        'DateData': DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
      });

      f1.requestFocus();
    }
  }

  double convertToDecimal(String value) {
    double numericValue = double.parse(value);
    return numericValue / 100;
  }

  void convertValuesToDecimal() {
    _callApi();
  }

  Future<void> _getHold() async {
    List<Map<String, dynamic>> sql =
        await databaseHelper.queryAllRows('ZINCTHICKNESS_SHEET');
    setState(() {
      widget.onChange?.call(sql);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ZincThicknessBloc, ZincThicknessState>(
          listener: (context, state) async {
            if (state is ZincThicknessLoadingState) {
              EasyLoading.show(status: "Loading...");
            } else if (state is ZincThicknessLoadedState) {
              EasyLoading.dismiss();

              if (state.item.RESULT == true) {
                f1.requestFocus();
                await _insertSqlite();
                _thickness1Controller.clear();
                _thickness2Controller.clear();
                _thickness3Controller.clear();
                _thickness4Controller.clear();
                _thickness6Controller.clear();
                _thickness7Controller.clear();
                _thickness8Controller.clear();
                _thickness9Controller.clear();
                setState(() {
                  bgButton = Colors.grey;
                });
                EasyLoading.showSuccess("${state.item.MESSAGE}",
                    duration: Duration(seconds: 3));
              } else if (state.item.RESULT == false) {
                _errorDialog(
                    text: Label("${state.item.MESSAGE}"),
                    onpressOk: () async {
                      Navigator.pop(context);
                      await _insertSqlite();
                      await _getHold();
                      _thickness1Controller.clear();
                      _thickness2Controller.clear();
                      _thickness3Controller.clear();
                      _thickness4Controller.clear();
                      _thickness6Controller.clear();
                      _thickness7Controller.clear();
                      _thickness8Controller.clear();
                      _thickness9Controller.clear();
                    });
              }
            }
            if (state is ZincThicknessErrorState) {
              EasyLoading.dismiss();
              _errorDialog(
                  text: Label("Check Connection & Save"),
                  onpressOk: () async {
                    Navigator.pop(context);
                    await _insertSqlite();
                    await _getHold();
                    _thickness1Controller.clear();
                    _thickness2Controller.clear();
                    _thickness3Controller.clear();
                    _thickness4Controller.clear();
                    _thickness6Controller.clear();
                    _thickness7Controller.clear();
                    _thickness8Controller.clear();
                    _thickness9Controller.clear();
                  });
            }
          },
        )
      ],
      child: BgWhite(
          isHideAppBar: true,
          body: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(20),
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  RowBoxInputField(
                    labelText: "Batch No. :",
                    controller: _batchController,
                    maxLength: 12,
                    focusNode: batchFocus,
                    onEditingComplete: () {
                      if (_batchController.text.length == 12) {
                        _getZincthicknessInSqlite();
                        f1.requestFocus();
                      }
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(child: Container()),
                      Expanded(
                        flex: 2,
                        child: RowBoxInputField(
                          labelText: "1 = ",
                          controller: _thickness1Controller,
                          textColor: t1,
                          focusNode: f1,
                          onEditingComplete: () {
                            if (_thickness1Controller.text.length == 2) {
                              f2.requestFocus();
                            }
                          },
                          onChanged: (value) {
                            setState(() {
                              if (value.isNotEmpty) {
                                int countValue = 0;
                                countValue = int.parse(value);
                                if (countValue < 20 || countValue > 45) {
                                  t1 = COLOR_RED;
                                } else {
                                  t1 = COLOR_BLACK;
                                }
                              }
                            });
                          },
                          type: TextInputType.numberWithOptions(
                              decimal: true, signed: false),
                          textInputFormatter: [
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          ],
                          maxLength: 2,
                        ),
                      ),
                      Expanded(child: Container()),
                      Expanded(
                        flex: 2,
                        child: RowBoxInputField(
                          labelText: "6 = ",
                          controller: _thickness6Controller,
                          textColor: t6,
                          focusNode: f6,
                          onEditingComplete: () {
                            if (_thickness6Controller.text.length == 2) {
                              f7.requestFocus();
                            }
                          },
                          onChanged: (value) {
                            setState(() {
                              if (value.isNotEmpty) {
                                int countValue = 0;
                                countValue = int.parse(value);
                                if (countValue < 45 || countValue > 75) {
                                  t6 = COLOR_RED;
                                } else {
                                  t6 = COLOR_BLACK;
                                }
                              }
                            });
                          },
                          type: TextInputType.number,
                          textInputFormatter: [
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          ],
                          maxLength: 2,
                        ),
                      ),
                      Expanded(child: Container()),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(child: Container()),
                      Expanded(
                        flex: 2,
                        child: RowBoxInputField(
                          labelText: "2 = ",
                          controller: _thickness2Controller,
                          textColor: t2,
                          focusNode: f2,
                          onEditingComplete: () {
                            if (_thickness2Controller.text.length == 2) {
                              f3.requestFocus();
                            }
                          },
                          onChanged: (value) {
                            setState(() {
                              if (value.isNotEmpty) {
                                int countValue = 0;
                                countValue = int.parse(value);
                                if (countValue < 20 || countValue > 45) {
                                  t2 = COLOR_RED;
                                } else {
                                  t2 = COLOR_BLACK;
                                }
                              }
                            });
                          },
                          type: TextInputType.number,
                          textInputFormatter: [
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          ],
                          maxLength: 2,
                        ),
                      ),
                      Expanded(child: Container()),
                      Expanded(
                        flex: 2,
                        child: RowBoxInputField(
                          labelText: "7 = ",
                          controller: _thickness7Controller,
                          textColor: t7,
                          focusNode: f7,
                          onEditingComplete: () {
                            if (_thickness7Controller.text.length == 2) {
                              f8.requestFocus();
                            }
                          },
                          onChanged: (value) {
                            setState(() {
                              if (value.isNotEmpty) {
                                int countValue = 0;
                                countValue = int.parse(value);
                                if (countValue < 45 || countValue > 70) {
                                  t7 = COLOR_RED;
                                } else {
                                  t7 = COLOR_BLACK;
                                }
                              }
                            });
                          },
                          type: TextInputType.number,
                          textInputFormatter: [
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          ],
                          maxLength: 2,
                        ),
                      ),
                      Expanded(child: Container()),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(child: Container()),
                      Expanded(
                        flex: 2,
                        child: RowBoxInputField(
                          labelText: "3 = ",
                          controller: _thickness3Controller,
                          textColor: t3,
                          focusNode: f3,
                          onEditingComplete: () {
                            if (_thickness3Controller.text.length == 2) {
                              f4.requestFocus();
                            }
                          },
                          onChanged: (value) {
                            setState(() {
                              if (value.isNotEmpty) {
                                int countValue = 0;
                                countValue = int.parse(value);
                                if (countValue < 20 || countValue > 45) {
                                  t3 = COLOR_RED;
                                } else {
                                  t3 = COLOR_BLACK;
                                }
                              }
                            });
                          },
                          type: TextInputType.number,
                          textInputFormatter: [
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          ],
                          maxLength: 2,
                        ),
                      ),
                      Expanded(child: Container()),
                      Expanded(
                        flex: 2,
                        child: RowBoxInputField(
                          labelText: "8 = ",
                          controller: _thickness8Controller,
                          textColor: t8,
                          focusNode: f8,
                          onEditingComplete: () {
                            if (_thickness8Controller.text.length == 2) {
                              f9.requestFocus();
                            }
                          },
                          onChanged: (value) {
                            setState(() {
                              if (value.isNotEmpty) {
                                int countValue = 0;
                                countValue = int.parse(value);
                                if (countValue < 45 || countValue > 70) {
                                  t8 = COLOR_RED;
                                } else {
                                  t8 = COLOR_BLACK;
                                }
                              }
                            });
                          },
                          type: TextInputType.number,
                          textInputFormatter: [
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          ],
                          maxLength: 2,
                        ),
                      ),
                      Expanded(child: Container()),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(child: Container()),
                      Expanded(
                        flex: 2,
                        child: RowBoxInputField(
                          labelText: "4 = ",
                          controller: _thickness4Controller,
                          textColor: t4,
                          focusNode: f4,
                          onEditingComplete: () {
                            if (_thickness4Controller.text.length == 2) {
                              f6.requestFocus();
                            }
                          },
                          onChanged: (value) {
                            setState(() {
                              if (value.isNotEmpty) {
                                int countValue = 0;
                                countValue = int.parse(value);
                                if (countValue < 20 || countValue > 45) {
                                  t4 = COLOR_RED;
                                } else {
                                  t4 = COLOR_BLACK;
                                }
                              }
                            });
                          },
                          type: TextInputType.number,
                          textInputFormatter: [
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          ],
                          maxLength: 2,
                        ),
                      ),
                      Expanded(child: Container()),
                      Expanded(
                        flex: 2,
                        child: RowBoxInputField(
                          labelText: "9 = ",
                          controller: _thickness9Controller,
                          textColor: t9,
                          focusNode: f9,
                          onEditingComplete: () {
                            _checkvalueController();
                          },
                          onChanged: (value) {
                            setState(() {
                              if (value.isNotEmpty) {
                                int countValue = 0;
                                countValue = int.parse(value);
                                if (countValue < 45 || countValue > 70) {
                                  t9 = COLOR_RED;
                                } else {
                                  t9 = COLOR_BLACK;
                                }
                              }
                              if (_batchController.text.isNotEmpty &&
                                  _thickness1Controller.text.isNotEmpty &&
                                  _thickness2Controller.text.isNotEmpty &&
                                  _thickness3Controller.text.isNotEmpty &&
                                  _thickness4Controller.text.isNotEmpty &&
                                  _thickness6Controller.text.isNotEmpty &&
                                  _thickness7Controller.text.isNotEmpty &&
                                  _thickness8Controller.text.isNotEmpty &&
                                  _thickness9Controller.text.isNotEmpty) {
                                bgButton = COLOR_BLUE_DARK;
                              } else {
                                bgButton = Colors.grey;
                              }
                            });
                          },
                          type: TextInputType.number,
                          textInputFormatter: [
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          ],
                          maxLength: 2,
                        ),
                      ),
                      Expanded(child: Container()),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Button(
                          bgColor: COLOR_RED,
                          onPress: () {
                            setState(() {
                              _thickness1Controller.text = '';
                              _thickness2Controller.text = '';
                              _thickness3Controller.text = '';
                              _thickness4Controller.text = '';
                              _thickness6Controller.text = '';
                              _thickness7Controller.text = '';
                              _thickness8Controller.text = '';
                              _thickness9Controller.text = '';
                              f1.requestFocus();
                            });
                          },
                          text: Label(
                            "Clear",
                            color: COLOR_WHITE,
                          ),
                        ),
                      ),
                      Expanded(child: Container()),
                      Expanded(
                        flex: 3,
                        child: Button(
                          bgColor: bgButton,
                          onPress: () => _checkvalueController(),
                          text: Label(
                            "Send",
                            color: COLOR_WHITE,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          )),
    );
  }

  void _getZincthicknessInSqlite() async {
    try {
      if (_batchController.text.trim().isNotEmpty) {
        var sql = await databaseHelper.queryAllRows('ZINCTHICKNESS_SHEET');
        bool found = false;
        var items;
        for (items in sql) {
          if (_batchController.text.trim() == items['Batch'].trim()) {
            found = true;
            setState(() {
              _thickness1Controller.text =
                  (double.parse(items['Thickness1']) * 100).toInt().toString();
              _thickness2Controller.text =
                  (double.parse(items['Thickness2']) * 100).toInt().toString();
              _thickness3Controller.text =
                  (double.parse(items['Thickness3']) * 100).toInt().toString();
              _thickness4Controller.text =
                  (double.parse(items['Thickness4']) * 100).toInt().toString();
              _thickness6Controller.text =
                  (double.parse(items['Thickness6']) * 100).toInt().toString();
              _thickness7Controller.text =
                  (double.parse(items['Thickness7']) * 100).toInt().toString();
              _thickness8Controller.text =
                  (double.parse(items['Thickness8']) * 100).toInt().toString();
              _thickness9Controller.text =
                  (double.parse(items['Thickness9']) * 100).toInt().toString();
              dateTime = items['DateData'];
            });
            break;
          }
        }
        if (found) {
          setState(() {
            int? countValue1 =
                int.tryParse(_thickness1Controller.text.trim().toString());
            int? countValue2 =
                int.tryParse(_thickness2Controller.text.trim().toString());
            int? countValue3 =
                int.tryParse(_thickness3Controller.text.trim().toString());
            int? countValue4 =
                int.tryParse(_thickness4Controller.text.trim().toString());
            int? countValue6 =
                int.tryParse(_thickness6Controller.text.trim().toString());
            int? countValue7 =
                int.tryParse(_thickness7Controller.text.trim().toString());
            int? countValue8 =
                int.tryParse(_thickness8Controller.text.trim().toString());
            int? countValue9 =
                int.tryParse(_thickness9Controller.text.trim().toString());
            if (countValue1! < 20 || countValue1 > 45) {
              t1 = COLOR_RED;
            } else {
              t1 = COLOR_BLACK;
            }
            if (countValue2! < 20 || countValue2 > 45) {
              t2 = COLOR_RED;
            } else {
              t2 = COLOR_BLACK;
            }
            if (countValue3! < 20 || countValue3 > 45) {
              t3 = COLOR_RED;
            } else {
              t3 = COLOR_BLACK;
            }
            if (countValue4! < 20 || countValue4 > 45) {
              t4 = COLOR_RED;
            } else {
              t4 = COLOR_BLACK;
            }

            if (countValue6! < 45 || countValue6 > 70) {
              t6 = COLOR_RED;
            } else {
              t6 = COLOR_BLACK;
            }
            if (countValue7! < 45 || countValue7 > 70) {
              t7 = COLOR_RED;
            } else {
              t7 = COLOR_BLACK;
            }
            if (countValue8! < 45 || countValue8 > 70) {
              t8 = COLOR_RED;
            } else {
              t8 = COLOR_BLACK;
            }
            if (countValue9! < 45 || countValue9 > 70) {
              t9 = COLOR_RED;
            } else {
              t9 = COLOR_BLACK;
            }
            bgButton = COLOR_BLUE_DARK;
          });

          // ทำอย่างไรก็ตามเมื่อพบค่าที่ตรงกัน
        } else {
          setState(() {
            _thickness1Controller.clear();
            _thickness2Controller.clear();
            _thickness3Controller.clear();
            _thickness4Controller.clear();
            _thickness6Controller.clear();
            _thickness7Controller.clear();
            _thickness8Controller.clear();
            _thickness9Controller.clear();
            print("Clear");
            bgButton = Colors.grey;
          });
        }
      } else {
        EasyLoading.showError("Please Input Batch No");
      }
    } on Exception {
      throw Exception();
    }
  }

  void _AlertDialog({String? text}) async {
    // EasyLoading.showError("Error[03]", duration: Duration(seconds: 5));//if password
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        // title: const Text('AlertDialog Title'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Label(
                text ?? "",
                color: COLOR_RED,
              ),
            ),
          ],
        ),

        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              convertValuesToDecimal();
            },
            child: const Text('Send Now'),
          ),
        ],
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
}
