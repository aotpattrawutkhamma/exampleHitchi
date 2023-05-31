import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hitachi/blocs/filmReceive/film_receive_bloc.dart';
import 'package:hitachi/config.dart';
import 'package:hitachi/helper/background/bg_white.dart';
import 'package:hitachi/helper/button/Button.dart';
import 'package:hitachi/helper/colors/colors.dart';
import 'package:hitachi/helper/input/boxInputField.dart';
import 'package:hitachi/helper/text/label.dart';
import 'package:hitachi/models/checkPackNo_Model.dart';
import 'package:hitachi/models/filmReceiveModel/filmreceiveOutputModel.dart';
import 'package:hitachi/services/databaseHelper.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class FilmReceiveScanScreen extends StatefulWidget {
  FilmReceiveScanScreen({super.key, this.onChange});
  ValueChanged<List<Map<String, dynamic>>>? onChange;
  @override
  State<FilmReceiveScanScreen> createState() => _FilmReceiveScanScreenState();
}

class _FilmReceiveScanScreenState extends State<FilmReceiveScanScreen> {
  final TextEditingController _poNoController = TextEditingController();
  final TextEditingController _InvoiceNoController = TextEditingController();
  final TextEditingController _freightController = TextEditingController();
  final TextEditingController _IncomingDateController = TextEditingController();
  final TextEditingController _storeByController = TextEditingController();
  final TextEditingController _packNoController = TextEditingController();
  final TextEditingController _rollNoController = TextEditingController();
  final TextEditingController _barCode1Controller = TextEditingController();
  final TextEditingController _barCode2Controller = TextEditingController();
  final TextEditingController _weight1Controller = TextEditingController();
  final TextEditingController _weight2Controller = TextEditingController();
  final TextEditingController _mfgDateController = TextEditingController();
  final TextEditingController _wrapGradeController = TextEditingController();

  String _thickness = '';

  DatabaseHelper databaseHelper = DatabaseHelper();
  DateTime? _selectedDate;
  DateTime? _selectedDateMfg;
  String? dataFromBarcode1;
  CheckPackNoModel _itemsPackNo = CheckPackNoModel();

  Color bgButton = Colors.grey;

  List<String> itemList = ['sea', 'air'];
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
  final f11 = FocusNode();
//

  Future _getHold() async {
    List<Map<String, dynamic>> sql =
        await databaseHelper.queryAllRows('DATA_SHEET');
    setState(() {
      widget.onChange?.call(sql);
    });
  }

  @override
  void initState() {
    _getHold();
    super.initState();
  }

  void _checkValueController() async {
    if (_poNoController.text.isNotEmpty &&
        _InvoiceNoController.text.isNotEmpty &&
        _freightController.text.isNotEmpty &&
        _IncomingDateController.text.isNotEmpty &&
        _storeByController.text.isNotEmpty &&
        _packNoController.text.isNotEmpty &&
        _rollNoController.text.isNotEmpty &&
        _barCode1Controller.text.isNotEmpty &&
        _barCode2Controller.text.isNotEmpty &&
        _weight1Controller.text.isNotEmpty &&
        _weight2Controller.text.isNotEmpty &&
        _mfgDateController.text.isNotEmpty &&
        _wrapGradeController.text.isNotEmpty) {
      _sendData();
    } else {
      EasyLoading.showError("Please Input Info");
    }
  }

  callFilmIn() async {
    switch (_wrapGradeController.text.trim()) {
      case "1":
        setState(() {
          _wrapGradeController.text = "A";
        });
        break;
      case "2":
        setState(() {
          _wrapGradeController.text = "B";
        });
        break;
      case "3":
        setState(() {
          _wrapGradeController.text = "C";
        });
        break;
      case "4":
        setState(() {
          _wrapGradeController.text = "D";
        });
        break;
      case "5":
        setState(() {
          _wrapGradeController.text = "E";
        });
        break;
      case "6":
        setState(() {
          _wrapGradeController.text = "F";
        });
        break;
      case "7":
        setState(() {
          _wrapGradeController.text = "G";
        });
        break;
      case "8":
        setState(() {
          _wrapGradeController.text = "H";
        });
        break;
      case "9":
        setState(() {
          _wrapGradeController.text = "I";
        });
        break;
      case "0":
        setState(() {
          _wrapGradeController.text = "J";
        });
        break;
      default:
        // กรณีไม่ตรงกับ case ใด ๆ ให้ไม่ทำอะไร
        break;
    }
    try {
      var sql = await databaseHelper.queryDataSelect(
          select1: 'PACK_NO',
          formTable: 'DATA_SHEET',
          where: 'PACK_NO',
          stringValue: _packNoController.text.trim());
      double? totalWeight;
      setState(() {
        double weight1 = double.tryParse(_weight1Controller.text.trim()) ?? 0;
        double weight2 = double.tryParse(_weight2Controller.text.trim()) ?? 0;
        totalWeight = weight1 + weight2;
      });
      if (sql.length <= 0) {
        await databaseHelper.insertSqlite('DATA_SHEET', {
          'PO_NO': _poNoController.text.trim(),
          'INVOICE': _InvoiceNoController.text.trim(),
          'FRIEGHT': _freightController.text.trim(),
          'INCOMING_DATE':
              _IncomingDateController.text.split('-').reversed.join('-'),
          'STORE_BY': _storeByController.text.trim(),
          'PACK_NO': _packNoController.text.trim(),
          'STORE_DATE':
              DateFormat('yyyy-MM-dd').format(DateTime.now()).toString(),
          'STATUS': "S",
          'W1': _weight1Controller.text.trim(),
          'W2': _weight1Controller.text.trim(),
          'WEIGHT': totalWeight.toString(),
          'MFG_DATE': _mfgDateController.text.split('-').reversed.join('-'),
          'THICKNESS1': _thickness,
          'THICKNESS2': "",
          'WRAP_GRADE': _wrapGradeController.text.trim(),
          'ROLL_NO': _rollNoController.text.trim(),
          'checkComplete': "S",
        });
      }
    } catch (e, s) {
      print("${e}${s}");
      EasyLoading.showError("Data Not Save");
    }
  }

  Future _checkThickness() async {
    if (_packNoController.text.isNotEmpty &&
        _packNoController.text.substring(0, 1) == '1') {
      setState(() {
        _thickness = "10";
      });
    } else if (_packNoController.text.isNotEmpty &&
        _packNoController.text.substring(0, 3) == '601') {
      setState(() {
        _thickness = "6.1";
      });
    } else if (_packNoController.text.isNotEmpty &&
        _packNoController.text.substring(0, 3) == '602') {
      setState(() {
        _thickness = "6.2";
      });
    } else if (_packNoController.text.isNotEmpty &&
        _packNoController.text.substring(0, 3) == '603') {
      setState(() {
        _thickness = "6.3";
      });
    } else if (_packNoController.text.isNotEmpty &&
        _packNoController.text.substring(0, 3) == '604') {
      setState(() {
        _thickness = "6.4";
      });
    } else if (_packNoController.text.isNotEmpty &&
        _packNoController.text.substring(0, 3) == '605') {
      setState(() {
        _thickness = "6.5";
      });
    } else if (_packNoController.text.isNotEmpty &&
        _packNoController.text.substring(0, 3) == '606') {
      setState(() {
        _thickness = "6.6";
      });
    } else if (_packNoController.text.isNotEmpty &&
        _packNoController.text.substring(0, 3) == '607') {
      setState(() {
        _thickness = "6.7";
      });
    } else if (_packNoController.text.isNotEmpty &&
        _packNoController.text.substring(0, 3) == '608') {
      setState(() {
        _thickness = "6.8";
      });
    } else if (_packNoController.text.isNotEmpty &&
        _packNoController.text.substring(0, 3) == '609') {
      setState(() {
        _thickness = "6.9";
      });
    } else {
      setState(() {
        _thickness = _packNoController.text.substring(0, 1);
      });
    }
  }

  void _sendData() {
    double? totalWeight;
    setState(() {
      double weight1 = double.tryParse(_weight1Controller.text.trim()) ?? 0;
      double weight2 = double.tryParse(_weight2Controller.text.trim()) ?? 0;
      totalWeight = weight1 + weight2;
    });
    switch (_wrapGradeController.text.trim()) {
      case "1":
        setState(() {
          _wrapGradeController.text = "A";
        });
        break;
      case "2":
        setState(() {
          _wrapGradeController.text = "B";
        });
        break;
      case "3":
        setState(() {
          _wrapGradeController.text = "C";
        });
        break;
      case "4":
        setState(() {
          _wrapGradeController.text = "D";
        });
        break;
      case "5":
        setState(() {
          _wrapGradeController.text = "E";
        });
        break;
      case "6":
        setState(() {
          _wrapGradeController.text = "F";
        });
        break;
      case "7":
        setState(() {
          _wrapGradeController.text = "G";
        });
        break;
      case "8":
        setState(() {
          _wrapGradeController.text = "H";
        });
        break;
      case "9":
        setState(() {
          _wrapGradeController.text = "I";
        });
        break;
      case "0":
        setState(() {
          _wrapGradeController.text = "J";
        });
        break;
      default:
        // กรณีไม่ตรงกับ case ใด ๆ ให้ไม่ทำอะไร
        break;
    }
    BlocProvider.of<FilmReceiveBloc>(context).add(
      FilmReceiveSendEvent(
        FilmReceiveOutputModel(
          PONO: _poNoController.text.trim(),
          INVOICE: _InvoiceNoController.text.trim(),
          FRIEGHT: _freightController.text.trim(),
          DATERECEIVE:
              _IncomingDateController.text.split('-').reversed.join('-'),
          OPERATORNAME: int.tryParse(_storeByController.text.trim()),
          PACKNO: _packNoController.text.trim(),
          STATUS: 'S',
          WEIGHT1: num.tryParse(_weight1Controller.text.trim()),
          WEIGHT2: num.tryParse(_weight2Controller.text.trim()),
          MFGDATE: _mfgDateController.text.split('-').reversed.join('-'),
          THICKNESS: _thickness,
          WRAPGRADE: _wrapGradeController.text.trim(),
          ROLL_NO: _rollNoController.text.trim(),
        ),
      ),
    );
  }

  void _checkMfgDate() {
    if (dataFromBarcode1!.length >= 11) {
      String dateStr = dataFromBarcode1!.substring(4, 6) +
          "-" +
          dataFromBarcode1!.substring(6, 8) +
          "-" +
          "20" +
          dataFromBarcode1!.substring(8, 10);

      DateTime selectedDate = DateFormat('dd-MM-yyyy').parse(dateStr);
      print(selectedDate);
      if (selectedDate != null) {
        setState(() {
          _mfgDateController.text =
              DateFormat('dd-MM-yyyy').format(selectedDate);
          String incomingDateStr = _IncomingDateController.text;
          String mfgDateStr = _mfgDateController.text;

          DateTime incomingDate =
              DateFormat('dd-MM-yyyy').parse(incomingDateStr);
          DateTime mfgDate = DateFormat('dd-MM-yyyy').parse(mfgDateStr);

          Duration difference = incomingDate.difference(mfgDate).abs();
          int differenceInDays = difference.inDays;

          print(differenceInDays);

          if (differenceInDays > 120) {
            showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                      backgroundColor: Colors.orange,
                      content: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Center(
                              child: Label(
                            "ฟิล์มหมดอายุแล้ว",
                            fontSize: 20,
                          )),
                        ],
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Label('OK'),
                        ),
                      ],
                    ));
          } else if (differenceInDays > 90) {
            showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                      backgroundColor: Colors.yellow,
                      content: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Center(
                              child: Label(
                            "ฟิล์มอายุ 91 - 120 วัน",
                            fontSize: 20,
                          )),
                        ],
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Label('OK'),
                        ),
                      ],
                    ));
          } else {}
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<FilmReceiveBloc, FilmReceiveState>(
          listener: (context, state) async {
            if (state is FilmReceiveLoadingState) {
              EasyLoading.show();
            } else if (state is FilmReceiveLoadedState) {
              EasyLoading.dismiss();

              if (state.item.RESULT == true) {
                _packNoController.clear();
                _rollNoController.clear();
                _barCode1Controller.clear();
                _barCode2Controller.clear();
                _weight1Controller.clear();
                _weight2Controller.clear();
                _mfgDateController.clear();
                _wrapGradeController.clear();
                f6.requestFocus();
                EasyLoading.showSuccess("Send complete",
                    duration: Duration(seconds: 3));
              } else {
                _errorDialog(
                    text: Label(
                        "${state.item.MESSAGE != null ? state.item.MESSAGE! : "Check Connection\n Do you want to save"}"),
                    onpressOk: () async {
                      await _checkThickness();
                      await callFilmIn();
                      await _getHold();

                      _packNoController.clear();
                      _rollNoController.clear();
                      _barCode1Controller.clear();
                      _barCode2Controller.clear();
                      _weight1Controller.clear();
                      _weight2Controller.clear();
                      _mfgDateController.clear();
                      _wrapGradeController.clear();
                      f6.requestFocus();
                      Navigator.pop(context);
                    });
              }
            } else if (state is FilmReceiveErrorState) {
              EasyLoading.dismiss();
              await _checkThickness();
              await callFilmIn();
              EasyLoading.showError("Can not send");
            }
            if (state is CheckFilmReceiveLoadingState) {
              print("Loading");
              EasyLoading.show(status: "Loading...");
            } else if (state is CheckFilmReceiveLoadedState) {
              EasyLoading.dismiss();
              setState(() {
                _itemsPackNo = state.item;
              });
              print(state.item.MESSAGE);
              if (_itemsPackNo.RESULT == false) {
                print("Error");
                _errorDialog(
                    text: Label(
                      "${_itemsPackNo.MESSAGE ?? "Check Connection"}",
                      color: COLOR_BLACK,
                    ),
                    onpressOk: () {
                      Navigator.pop(context);
                      f7.requestFocus();
                    });
              }
              if (_itemsPackNo.RESULT == true) {
                print("Error");
                f7.requestFocus();
              }
            } else if (state is CheckFilmReceiveErrorState) {
              EasyLoading.dismiss();
              f7.requestFocus();
            }
          },
        )
      ],
      child: BgWhite(
          isHideAppBar: true,
          body: Container(
            padding: EdgeInsets.all(15),
            width: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  BoxInputField(
                    labelText: "PO No.",
                    height: 30,
                    controller: _poNoController,
                    focusNode: f1,
                    onEditingComplete: () => f2.requestFocus(),
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: BoxInputField(
                          focusNode: f2,
                          labelText: "Invoice No.",
                          height: 30,
                          controller: _InvoiceNoController,
                          onEditingComplete: () => f3.requestFocus(),
                        ),
                      ),
                      Expanded(child: Container()),
                      Expanded(
                        flex: 4,
                        child: SizedBox(
                          height: 40,
                          child: DropdownButtonFormField2(
                            focusNode: f3,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.zero,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            isExpanded: true,
                            hint: Center(
                              child: Text(
                                'Please Select',
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                            items: itemList
                                .map((item) => DropdownMenuItem<String>(
                                      value: item,
                                      child: Label(item),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              _freightController.text = value!;
                            },
                            buttonStyleData: const ButtonStyleData(
                              height: 50,
                              padding: EdgeInsets.only(left: 20, right: 10),
                            ),
                            iconStyleData: const IconStyleData(
                              icon: Icon(
                                Icons.arrow_drop_down,
                                color: Colors.black45,
                              ),
                              iconSize: 20,
                            ),
                            dropdownStyleData: DropdownStyleData(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: GestureDetector(
                          onTap: () async {
                            f4.requestFocus();
                            final DateTime? selectedDate = await showDatePicker(
                              context: context,
                              initialDate: _selectedDate ?? DateTime.now(),
                              firstDate: DateTime(2023),
                              lastDate: DateTime.now(),
                            );
                            if (selectedDate != null) {
                              setState(() {
                                _selectedDate = selectedDate;
                                _IncomingDateController.text =
                                    DateFormat('dd-MM-yyyy')
                                        .format(selectedDate);
                              });
                              f5.requestFocus();
                            }
                          },
                          child: AbsorbPointer(
                            child: BoxInputField(
                              labelText: "Incoming Date",
                              controller: _IncomingDateController,
                              type: TextInputType.datetime,
                              focusNode: f4,
                              height: 30,
                              onChanged: (value) {},
                              maxLength: 6,
                              textInputFormatter: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9]')),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(child: Container()),
                      Expanded(
                        flex: 4,
                        child: BoxInputField(
                          focusNode: f5,
                          labelText: "Store By",
                          height: 30,
                          type: TextInputType.number,
                          controller: _storeByController,
                          onEditingComplete: () => f6.requestFocus(),
                          textInputFormatter: [
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: BoxInputField(
                          focusNode: f6,
                          onEditingComplete: () async {
                            if (_packNoController.text.length == 8) {
                              await _checkThickness();
                              BlocProvider.of<FilmReceiveBloc>(context).add(
                                FilmReceiveCheckEvent(
                                    _packNoController.text.trim()),
                              );
                            } else {
                              await _checkThickness();
                            }
                            print(_thickness);
                          },
                          labelText: "Pack No.",
                          height: 30,
                          controller: _packNoController,
                          maxLength: 8,
                          textInputFormatter: [
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          ],
                        ),
                      ),
                      Expanded(child: Container()),
                      Expanded(
                        flex: 4,
                        child: BoxInputField(
                          labelText: "Roll No.",
                          height: 30,
                          focusNode: f7,
                          maxLength: 14,
                          onEditingComplete: () {
                            if (_rollNoController.text.length == 14) {
                              f8.requestFocus();
                            }
                          },
                          controller: _rollNoController,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: BoxInputField(
                          focusNode: f8,
                          labelText: "BarCode 1",
                          height: 30,
                          maxLength: 14,
                          controller: _barCode1Controller,
                          onEditingComplete: () {
                            if (_barCode1Controller.text.length == 14) {
                              f9.requestFocus();
                              _checkMfgDate();
                            }
                          },
                          onChanged: (value) {
                            if (value.length > 10) {
                              setState(() {
                                dataFromBarcode1 = value;
                                String substringValue =
                                    value.substring(value.length - 3);
                                double parsedValue =
                                    double.parse(substringValue) / 100;
                                _weight1Controller.text =
                                    parsedValue.toStringAsFixed(2);
                              });
                            }
                          },
                        ),
                      ),
                      Expanded(child: Container()),
                      Expanded(
                        flex: 4,
                        child: BoxInputField(
                          focusNode: f9,
                          maxLength: 14,
                          onEditingComplete: () {
                            if (_barCode2Controller.text.length == 14) {
                              f11.requestFocus();
                            }
                          },
                          labelText: "BarCode 2",
                          height: 30,
                          controller: _barCode2Controller,
                          onChanged: (value) {
                            if (value.length > 10) {
                              String substringValue =
                                  value.substring(value.length - 3);
                              double parsedValue =
                                  double.parse(substringValue) / 100;
                              _weight2Controller.text =
                                  parsedValue.toStringAsFixed(2);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: BoxInputField(
                          labelText: "Weight 1",
                          height: 30,
                          controller: _weight1Controller,
                        ),
                      ),
                      Expanded(child: Container()),
                      Expanded(
                        flex: 4,
                        child: BoxInputField(
                          labelText: "Weight 2",
                          height: 30,
                          controller: _weight2Controller,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: GestureDetector(
                          onTap: () async {
                            if (_barCode1Controller.text.isNotEmpty) {
                              _checkMfgDate();
                              f11.requestFocus();
                            } else {}
                          },
                          child: AbsorbPointer(
                            child: BoxInputField(
                              focusNode: f10,
                              labelText: "Mfg. Date",
                              controller: _mfgDateController,
                              type: TextInputType.datetime,
                              enabled: false,
                              height: 30,
                            ),
                          ),
                        ),
                      ),
                      Expanded(child: Container()),
                      Expanded(
                        flex: 4,
                        child: BoxInputField(
                          maxLength: 1,
                          type: TextInputType.number,
                          textInputFormatter: [
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          ],
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              setState(() {
                                bgButton = COLOR_BLUE_DARK;
                              });
                            } else {
                              setState(() {
                                bgButton = Colors.grey;
                              });
                            }
                          },
                          focusNode: f11,
                          labelText: "Wrap Grade",
                          height: 30,
                          controller: _wrapGradeController,
                          onEditingComplete: () => {_checkValueController()},
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Button(
                    bgColor: bgButton,
                    onPress: () {
                      _checkValueController();
                      // callFilmIn();
                    },
                    text: Label(
                      "Send",
                      color: COLOR_WHITE,
                    ),
                  )
                ],
              ),
            ),
          )),
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
