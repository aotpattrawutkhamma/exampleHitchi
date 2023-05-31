import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hitachi/blocs/lineElement/line_element_bloc.dart';
import 'package:hitachi/blocs/planwinding/planwinding_bloc.dart';
import 'package:hitachi/blocs/pmDaily/pm_daily_bloc.dart';
import 'package:hitachi/helper/background/bg_white.dart';
import 'package:hitachi/helper/button/Button.dart';
import 'package:hitachi/helper/colors/colors.dart';
import 'package:hitachi/helper/input/boxInputField.dart';
import 'package:hitachi/helper/input/rowBoxInputField.dart';
import 'package:hitachi/helper/text/label.dart';
import 'package:hitachi/models-Sqlite/pmdailyCheckPointModel.dart';
import 'package:hitachi/models-Sqlite/pmdailyModel.dart';
import 'package:hitachi/models/ResponeDefault.dart';
import 'package:hitachi/models/planWinding/PlanWindingOutputModel.dart';
import 'package:hitachi/models/pmdailyModel/PMDailyCheckpointOutputModel.dart';
import 'package:hitachi/models/pmdailyModel/PMDailyOutputModel.dart';
import 'package:hitachi/models/reportRouteSheet/reportRouteSheetModel.dart';
import 'package:hitachi/screens/lineElement/reportRouteSheet/page/problemPage.dart';
import 'package:hitachi/services/databaseHelper.dart';
import 'package:intl/intl.dart';

import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class PMDaily_Screen extends StatefulWidget {
  PMDaily_Screen({super.key, this.onChange});
  ValueChanged<List<Map<String, dynamic>>>? onChange;

  @override
  State<PMDaily_Screen> createState() => _PMDaily_ScreenState();
}

class _PMDaily_ScreenState extends State<PMDaily_Screen> {
  final TextEditingController batchNoController = TextEditingController();
  List<PMDailyOutputModelPlan>? PMDailyCheckPointModel;
  PlanWindingDataSource? PMDailyDataSource;
  PlanWindingLoadStatusDataSource? pmDailyLoadStatusDataSource;

  Color? bgChange;
  Color? bgChangeStatus;
  ResponeDefault? items;
  List<int> _index = [];
  DataGridRow? datagridRow;
  String CheckFirst = "";
  String valuetxtinput = "";

  DatabaseHelper databaseHelper = DatabaseHelper();
  final TextEditingController checkpointController = TextEditingController();
  final TextEditingController operatorNameController = TextEditingController();

  final f1 = FocusNode();
  final f2 = FocusNode();

  bool _checkLoadAllStatus = true;
  bool _btnloadSta = false;
  bool _BoolCheckbox = true;
  bool _enabledOperator = true;
  bool _date = true;
  bool _checkAPI = false;
  List<PMDailyModel>? processModelSqlite;

  late Map<String, double> columnWidths = {
    'status': double.nan,
    'no': double.nan,
  };

  @override
  void initState() {
    super.initState();
    f1.requestFocus();
    _checkloadStatus();
    _getHold();
  }

  // PlanWindingBloc
  // PlanWindingState
  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<PmDailyBloc, PmDailyState>(
          listener: (context, state) async {
            //=======================Status====================================
            if (state is PMDailyGetLoadingState) {
              // EasyLoading.show();
              EasyLoading.show(status: "Loading...");
            }
            if (state is PMDailyGetLoadedState) {
              EasyLoading.dismiss();

              setState(() {
                PMDailyCheckPointModel = state.item.CHECKPOINT;
              });

              if (state.item.CHECKPOINT!.isEmpty) {
                _errorDialog(
                    text: Label("Load PM Not Complete"),
                    isHideCancle: false,
                    onpressOk: () async {
                      Navigator.pop(context);
                      checkpointController.clear();
                      setState(() {
                        _checkAPI = false;
                      });
                    });
              } else if (state.item.CHECKPOINT!.isNotEmpty) {
                setState(() {
                  bgChangeStatus = COLOR_BLUE_DARK;
                  if (_date == true) {
                    PMDailyDataSource = PlanWindingDataSource(
                      CHECKPOINT: PMDailyCheckPointModel,
                    );
                  }
                  _checkAPI = true;
                });
              }
            }
            if (state is PMDailyGetErrorState) {
              EasyLoading.dismiss();
              EasyLoading.showError("Check Connection",
                  duration: Duration(seconds: 5));
              print(state.error);
              setState(() {
                _checkAPI = false;
              });
            }

            //===========================send================================
            if (state is PMDailyLoadingState) {
              EasyLoading.show(status: "Loading...");
            }
            if (state is PMDailyLoadedState) {
              print("Loaded");
              EasyLoading.dismiss();

              if (state.item.RESULT == true) {
                _errorDialog(
                    text: Label("${state.item.MESSAGE}"),
                    onpressOk: () async {
                      Navigator.pop(context);
                      _BoolCheckbox = false;
                      f2.requestFocus();
                      _loadPlan();
                      checkpointController.clear();
                    });
              } else if (state.item.RESULT == false) {
                items = state.item;
                _errorDialog(
                    text: Label("${state.item.MESSAGE}"),
                    onpressOk: () async {
                      Navigator.pop(context);
                      await _getProcessStart(_index.first);
                      await _getHold();
                      f2.requestFocus();
                      _loadPlan();
                      checkpointController.clear();
                    });
              } else {
                // EasyLoading.showError("Can not Call API");
                _errorDialog(
                    text: Label(
                        "${state.item.MESSAGE ?? "CheckConnection\n Do you want to Save"}"),
                    onpressOk: () async {
                      Navigator.pop(context);
                      await _getProcessStart(_index.first);
                      await _getHold();
                      f2.requestFocus();
                      _loadPlan();
                      checkpointController.clear();
                    });
              }
            }
            if (state is PMDailyErrorState) {
              print("ERROR");
              EasyLoading.dismiss();
              _getProcessStart(_index.first);
              _errorDialog(
                  text: Label("Check Connection"),
                  isHideCancle: false,
                  onpressOk: () async {
                    Navigator.pop(context);
                    await _getProcessStart(_index.first);
                    await _getHold();
                  });
            }
            //===========================================================
          },
        )
      ],
      child: BgWhite(
        isHideAppBar: true,
        body: Container(
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: 40,
                    width: 130,
                    child: Button(
                      onPress: () => _loadAllPlan(),
                      text: Label(
                        "Load All Status",
                        color: COLOR_WHITE,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              RowBoxInputField(
                labelText: "Operator Name : ",
                height: 35,
                controller: operatorNameController,
                maxLength: 12,
                focusNode: f1,
                enabled: _enabledOperator,
                // enabled: _enabledPMDaily,

                onEditingComplete: () {
                  if (operatorNameController.text.isNotEmpty) {
                    setState(() {
                      f2.requestFocus();
                      valuetxtinput = " ";
                      _enabledOperator = false;
                    });
                  } else {
                    setState(() {
                      valuetxtinput = "Operator Name : User INVALID";
                    });
                    operatorNameController.clear();
                  }
                },
                textInputFormatter: [
                  FilteringTextInputFormatter.allow(
                    RegExp(r'^(?!.*\d{12})[0-9]+$'),
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              RowBoxInputField(
                labelText: "Check Point : ",
                height: 35,
                maxLength: 10,
                controller: checkpointController,
                focusNode: f2,
                // enabled: _enabledOperator,
                onEditingComplete: () {
                  if (checkpointController.text.isNotEmpty) {
                    setState(() {
                      _loadPlan();
                      f2.requestFocus();
                      valuetxtinput = " ";
                    });
                  } else {
                    setState(() {
                      valuetxtinput = "Check Point : Check Point INVALID";
                    });
                    checkpointController.clear();
                  }
                },
                onChanged: (value) {
                  if (operatorNameController.text.isNotEmpty &&
                      checkpointController.text.isNotEmpty) {
                  } else {}
                },
              ),
              const SizedBox(
                height: 5,
              ),
              PMDailyDataSource != null && pmDailyLoadStatusDataSource == null
                  ? Expanded(
                      flex: 5,
                      child: Container(
                        child: SfDataGrid(
                          footerHeight: 10,
                          showCheckboxColumn: _BoolCheckbox,
                          selectionMode: SelectionMode.single,
                          gridLinesVisibility: GridLinesVisibility.both,
                          headerGridLinesVisibility: GridLinesVisibility.both,
                          source: PMDailyDataSource!,
                          columnWidthMode: ColumnWidthMode.fill,
                          allowPullToRefresh: true,
                          allowColumnsResizing: true,
                          onColumnResizeUpdate:
                              (ColumnResizeUpdateDetails details) {
                            setState(() {
                              columnWidths[details.column.columnName] =
                                  details.width;
                              print(details.width);
                            });
                            return true;
                          },
                          onSelectionChanged:
                              (selectRow, deselectedRows) async {
                            setState(() {
                              _index.clear();
                              bgChange = COLOR_BLUE_DARK;
                            });

                            if (selectRow.isNotEmpty) {
                              // bgChange = COLOR_BLUE_DARK;
                              if (selectRow.length ==
                                      PMDailyDataSource!.effectiveRows.length &&
                                  selectRow.length > 1) {
                                setState(() {
                                  selectRow.forEach((row) {
                                    _index.add(int.tryParse(
                                        row.getCells()[0].value.toString())!);
                                  });
                                });
                              } else {
                                setState(() {
                                  _index.add(int.tryParse(selectRow.first
                                      .getCells()[0]
                                      .value
                                      .toString())!);
                                  datagridRow = selectRow.first;
                                  processModelSqlite = datagridRow!
                                      .getCells()
                                      .map(
                                        (e) => PMDailyModel(),
                                      )
                                      .toList();
                                });
                              }
                            } else {
                              // bgChange = Colors.grey;
                              setState(() {
                                if (deselectedRows.length > 1) {
                                  _index.clear();
                                } else {
                                  _index.remove(int.tryParse(deselectedRows
                                      .first
                                      .getCells()[0]
                                      .value
                                      .toString())!);
                                }
                              });

                              print('No Rows Selected');
                            }
                          },
                          columns: [
                            GridColumn(
                              width: columnWidths['no']!,
                              columnName: 'no',
                              label: Container(
                                color: COLOR_BLUE_DARK,
                                child: Center(
                                  child: Label(
                                    'No',
                                    color: COLOR_WHITE,
                                  ),
                                ),
                              ),
                            ),
                            GridColumn(
                              width: columnWidths['status']!,
                              columnName: 'status',
                              label: Container(
                                color: COLOR_BLUE_DARK,
                                child: Center(
                                  child: Label(
                                    'Status',
                                    color: COLOR_WHITE,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Row(
                      children: [
                        Visibility(
                          visible: true,
                          child: Container(
                              child: Label(
                            " ${valuetxtinput}",
                            color: COLOR_RED,
                          )),
                        ),
                      ],
                    ),
              pmDailyLoadStatusDataSource != null && PMDailyDataSource == null
                  ? Expanded(
                      flex: 5,
                      child: Container(
                        child: SfDataGrid(
                          footerHeight: 10,
                          showCheckboxColumn: _BoolCheckbox,
                          selectionMode: SelectionMode.single,
                          gridLinesVisibility: GridLinesVisibility.both,
                          headerGridLinesVisibility: GridLinesVisibility.both,
                          source: pmDailyLoadStatusDataSource!,
                          columnWidthMode: ColumnWidthMode.fill,
                          allowPullToRefresh: true,
                          allowColumnsResizing: true,
                          onColumnResizeUpdate:
                              (ColumnResizeUpdateDetails details) {
                            setState(() {
                              columnWidths[details.column.columnName] =
                                  details.width;
                              print(details.width);
                            });
                            return true;
                          },
                          onSelectionChanged:
                              (selectRow, deselectedRows) async {
                            setState(() {
                              bgChange = COLOR_BLUE_DARK;
                            });
                            _index.clear();
                            if (selectRow.isNotEmpty) {
                              if (selectRow.length ==
                                      pmDailyLoadStatusDataSource!
                                          .effectiveRows.length &&
                                  selectRow.length > 1) {
                                setState(() {
                                  selectRow.forEach((row) {
                                    _index.add(int.tryParse(
                                        row.getCells()[0].value.toString())!);
                                  });
                                });
                              } else {
                                setState(() {
                                  _index.add(int.tryParse(selectRow.first
                                      .getCells()[0]
                                      .value
                                      .toString())!);
                                  datagridRow = selectRow.first;
                                  processModelSqlite = datagridRow!
                                      .getCells()
                                      .map(
                                        (e) => PMDailyModel(),
                                      )
                                      .toList();
                                });
                              }
                            } else {
                              setState(() {
                                if (deselectedRows.length > 1) {
                                  _index.clear();
                                } else {
                                  _index.remove(int.tryParse(deselectedRows
                                      .first
                                      .getCells()[0]
                                      .value
                                      .toString())!);
                                }
                              });

                              print('No Rows Selected');
                            }
                          },
                          columns: [
                            GridColumn(
                              width: columnWidths['no']!,
                              columnName: 'no',
                              label: Container(
                                color: COLOR_BLUE_DARK,
                                child: Center(
                                  child: Label(
                                    'No',
                                    color: COLOR_WHITE,
                                  ),
                                ),
                              ),
                            ),
                            GridColumn(
                              width: columnWidths['status']!,
                              columnName: 'status',
                              label: Container(
                                color: COLOR_BLUE_DARK,
                                child: Center(
                                  child: Label(
                                    'Status',
                                    color: COLOR_WHITE,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Row(
                      children: [
                        Visibility(
                          visible: true,
                          child: Container(
                              child: Label(
                            " ${valuetxtinput}",
                            color: COLOR_RED,
                          )),
                        ),
                      ],
                    ),
              pmDailyLoadStatusDataSource != null &&
                      PMDailyDataSource != null &&
                      _checkLoadAllStatus == true
                  ? Expanded(
                      flex: 5,
                      child: Container(
                        child: SfDataGrid(
                          footerHeight: 10,
                          showCheckboxColumn: _BoolCheckbox,
                          selectionMode: SelectionMode.single,
                          gridLinesVisibility: GridLinesVisibility.both,
                          headerGridLinesVisibility: GridLinesVisibility.both,
                          source: PMDailyDataSource!,
                          columnWidthMode: ColumnWidthMode.fill,
                          allowPullToRefresh: true,
                          allowColumnsResizing: true,
                          onColumnResizeUpdate:
                              (ColumnResizeUpdateDetails details) {
                            setState(() {
                              columnWidths[details.column.columnName] =
                                  details.width;
                              print(details.width);
                            });
                            return true;
                          },
                          onSelectionChanged:
                              (selectRow, deselectedRows) async {
                            setState(() {
                              bgChange = COLOR_BLUE_DARK;
                            });
                            _index.clear();
                            if (selectRow.isNotEmpty) {
                              if (selectRow.length ==
                                      PMDailyDataSource!.effectiveRows.length &&
                                  selectRow.length > 1) {
                                setState(() {
                                  selectRow.forEach((row) {
                                    _index.add(int.tryParse(
                                        row.getCells()[0].value.toString())!);
                                  });
                                });
                              } else {
                                setState(() {
                                  _index.add(int.tryParse(selectRow.first
                                      .getCells()[0]
                                      .value
                                      .toString())!);
                                  datagridRow = selectRow.first;
                                  processModelSqlite = datagridRow!
                                      .getCells()
                                      .map(
                                        (e) => PMDailyModel(),
                                      )
                                      .toList();
                                });
                              }
                            } else {
                              setState(() {
                                if (deselectedRows.length > 1) {
                                  _index.clear();
                                } else {
                                  _index.remove(int.tryParse(deselectedRows
                                      .first
                                      .getCells()[0]
                                      .value
                                      .toString())!);
                                }
                              });

                              print('No Rows Selected');
                            }
                          },
                          columns: [
                            GridColumn(
                              width: columnWidths['no']!,
                              columnName: 'no',
                              label: Container(
                                color: COLOR_BLUE_DARK,
                                child: Center(
                                  child: Label(
                                    'No',
                                    color: COLOR_WHITE,
                                  ),
                                ),
                              ),
                            ),
                            GridColumn(
                              width: columnWidths['status']!,
                              columnName: 'status',
                              label: Container(
                                color: COLOR_BLUE_DARK,
                                child: Center(
                                  child: Label(
                                    'Status',
                                    color: COLOR_WHITE,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Row(
                      children: [
                        Visibility(
                          visible: true,
                          child: Container(
                              child: Label(
                            " ${valuetxtinput}",
                            color: COLOR_RED,
                          )),
                        ),
                      ],
                    ),
              pmDailyLoadStatusDataSource != null &&
                      PMDailyDataSource != null &&
                      _checkLoadAllStatus == false
                  ? Expanded(
                      flex: 5,
                      child: Container(
                        child: SfDataGrid(
                          footerHeight: 10,
                          showCheckboxColumn: _BoolCheckbox,
                          selectionMode: SelectionMode.single,
                          gridLinesVisibility: GridLinesVisibility.both,
                          headerGridLinesVisibility: GridLinesVisibility.both,
                          source: pmDailyLoadStatusDataSource!,
                          columnWidthMode: ColumnWidthMode.fill,
                          allowPullToRefresh: true,
                          allowColumnsResizing: true,
                          onColumnResizeUpdate:
                              (ColumnResizeUpdateDetails details) {
                            setState(() {
                              columnWidths[details.column.columnName] =
                                  details.width;
                              print(details.width);
                            });
                            return true;
                          },
                          onSelectionChanged:
                              (selectRow, deselectedRows) async {
                            _index.clear();
                            setState(() {
                              bgChange = COLOR_BLUE_DARK;
                            });

                            if (selectRow.isNotEmpty) {
                              if (selectRow.length ==
                                      pmDailyLoadStatusDataSource!
                                          .effectiveRows.length &&
                                  selectRow.length > 1) {
                                setState(() {
                                  selectRow.forEach((row) {
                                    _index.add(int.tryParse(
                                        row.getCells()[0].value.toString())!);
                                  });
                                });
                              } else {
                                setState(() {
                                  _index.add(int.tryParse(selectRow.first
                                      .getCells()[0]
                                      .value
                                      .toString())!);
                                  datagridRow = selectRow.first;
                                  processModelSqlite = datagridRow!
                                      .getCells()
                                      .map(
                                        (e) => PMDailyModel(),
                                      )
                                      .toList();
                                });
                              }
                            } else {
                              setState(() {
                                if (deselectedRows.length > 1) {
                                  _index.clear();
                                } else {
                                  _index.remove(int.tryParse(deselectedRows
                                      .first
                                      .getCells()[0]
                                      .value
                                      .toString())!);
                                }
                              });

                              print('No Rows Selected');
                            }
                          },
                          columns: [
                            GridColumn(
                              width: columnWidths['no']!,
                              columnName: 'no',
                              label: Container(
                                color: COLOR_BLUE_DARK,
                                child: Center(
                                  child: Label(
                                    'No',
                                    color: COLOR_WHITE,
                                  ),
                                ),
                              ),
                            ),
                            GridColumn(
                              width: columnWidths['status']!,
                              columnName: 'status',
                              label: Container(
                                color: COLOR_BLUE_DARK,
                                child: Center(
                                  child: Label(
                                    'Status',
                                    color: COLOR_WHITE,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Row(
                      children: [
                        Visibility(
                          visible: true,
                          child: Container(
                              child: Label(
                            " ${valuetxtinput}",
                            color: COLOR_RED,
                          )),
                        ),
                      ],
                    ),
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Button(
                      bgColor: bgChangeStatus ?? Colors.grey,
                      onPress: () => _loadPlan(),
                      text: Label(
                        "Load Status",
                        color: COLOR_WHITE,
                      ),
                    ),
                  ),
                  Expanded(child: Container()),
                  Expanded(
                    flex: 3,
                    child: Button(
                      bgColor: bgChange ?? Colors.grey,
                      onPress: () => _btnSend(_index.first),
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
      ),
    );
  }

  Future _QueryLoadStatus(String NumberCPT) async {
    var sql = await databaseHelper.queryAllRows('PM_DAILY_SHEET');
    List<PMDailyCheckPointSQLiteModel> query = sql
        .where((element) => element['CTType'] == NumberCPT)
        .map((item) => PMDailyCheckPointSQLiteModel.fromMap(
            item.map((key, value) => MapEntry(key, value))))
        .toList();
    print("NumberCPT ${NumberCPT}");
    print(query[0].DESCRIPTION);
    //
    setState(() {
      pmDailyLoadStatusDataSource =
          PlanWindingLoadStatusDataSource(CHECKPOINT: query);
    });
  }

  Future<void> _loadAllPlan() async {
    BlocProvider.of<PmDailyBloc>(context).add(
      PMDailyGetSendEvent(),
    );

    if (_checkAPI == true) {
      setState(() {
        bgChange = Colors.grey;
        _BoolCheckbox = false;
        _enabledOperator = true;
        _checkLoadAllStatus = true;
      });
      databaseHelper.deleteDataAllFromSQLite(tableName: 'PM_DAILY_SHEET');
      BlocProvider.of<PmDailyBloc>(context).add(
        PMDailyGetSendEvent(),
      );
    } else {
      setState(() {
        bgChange = Colors.grey;
        _BoolCheckbox = false;
        _enabledOperator = true;
        _checkLoadAllStatus = true;
      });
    }
  }

  Future<void> _loadPlan() async {
    setState(() {
      _index.clear();
      _checkLoadAllStatus = false;
      _BoolCheckbox = true;
      bgChange = Colors.grey;
      String NumberCPT = checkpointController.text.substring(0, 1);
      _QueryLoadStatus(NumberCPT);
    });
  }

  void _btnSend(int _index) async {
    if (checkpointController.text.isNotEmpty &&
        operatorNameController.text.isNotEmpty &&
        _index != 0) {
      _callAPI(_index);
    } else {
      setState(() {
        // _enabledPMDaily = true;
      });
      // EasyLoading.showInfo("กรุณาใส่ข้อมูลให้ครบ");
    }
  }

  Future _getHold() async {
    List<Map<String, dynamic>> sql =
        await databaseHelper.queryAllRows('PM_SHEET');
    setState(() {
      widget.onChange?.call(sql);
    });
  }

  void _callAPI(int _index) {
    BlocProvider.of<PmDailyBloc>(context).add(
      PMDailySendEvent(PMDailyOutputModel(
        OPERATORNAME: int.tryParse(operatorNameController.text.trim()),
        CHECKPOINT: checkpointController.text.trim(),
        STATUS: _index.toString().trim(),
        STARTDATE:
            DateFormat('yyyy MM dd HH:mm:ss').format(DateTime.now()).toString(),
      )),
    );
  }

  void _saveSendSqlite(int _index) async {
    try {
      if (operatorNameController.text.isNotEmpty) {
        await databaseHelper.insertSqlite('PM_SHEET', {
          'OperatorName': operatorNameController.text.trim(),
          'CheckPointPM': checkpointController.text.trim(),
          'Status': _index.toString().trim(),
          'DatePM': DateFormat('yyyy MM dd HH:mm:ss')
              .format(DateTime.now())
              .toString(),
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<bool> _getProcessStart(int _index) async {
    try {
      var sql_pmDailySheet = await databaseHelper.queryDataSelectPMDaily(
        select1: 'OperatorName'.trim(),
        select2: 'CheckPointPM'.trim(),
        select3: 'Status'.trim(),
        select4: 'StartDate'.trim(),
        formTable: 'PM_SHEET'.trim(),
        where: 'OperatorName'.trim(),
        stringValue: operatorNameController.text.trim(),
      );
      print(sql_pmDailySheet.length);

      // if (sql_processSheet[0]['Machine'] != MachineController.text.trim()) {
      print(operatorNameController.text.trim());
      print(sql_pmDailySheet.length);
      if (sql_pmDailySheet.isEmpty) {
        // setState(() {
        print("_checkSendSqlite = true;");
        _saveSendSqlite(_index);
        // });
      } else {
        // setState(() {
        print("_checkSendSqlite = false;");
        // _updateSendSqlite();//
        // });
        print("else");
      }

      return true;
    } catch (e) {
      print("Catch : ${e}");
      return false;
    }
  }

  Future<void> _checkloadStatus() async {
    var sql_PMDSheet = await databaseHelper.queryAllRows('PM_DAILY_SHEET');
    if (sql_PMDSheet.isEmpty) {
      setState(() {
        bgChangeStatus = Colors.grey;
        _enabledOperator = true;
      });
    } else {
      setState(() {
        bgChangeStatus = COLOR_BLUE_DARK;
        _enabledOperator = true;
      });
    }
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

class PlanWindingDataSource extends DataGridSource {
  PlanWindingDataSource({
    List<PMDailyOutputModelPlan>? CHECKPOINT,
  }) {
    int countloop = 0;
    if (CHECKPOINT != null) {
      databaseHelper.deleteDataAllFromSQLite(tableName: 'PM_DAILY_SHEET');
      for (var _item in CHECKPOINT) {
        countloop++;
        _employees.add(
          DataGridRow(
            cells: [
              DataGridCell<String>(columnName: 'no', value: _item.STATUS),
              DataGridCell<String>(
                  columnName: 'status', value: _item.DESCRIPTION),
            ],
          ),
        );
        databaseHelper.insertSqlite('PM_DAILY_SHEET', {
          'CTType': _item.CTTYPE,
          'Status': _item.STATUS,
          'Description': _item.DESCRIPTION,
        });
      }
    } else {
      EasyLoading.showError("Can not Call API");
    }
    // }
  }

  List<DataGridRow> _employees = [];
  DatabaseHelper databaseHelper = DatabaseHelper();
  PMDaily_Screen? PMDailyScreen;

  @override
  List<DataGridRow> get rows => _employees;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>(
        (dataGridCell) {
          return Container(
            alignment: (dataGridCell.columnName == 'id' ||
                    dataGridCell.columnName == 'qty')
                ? Alignment.center
                : Alignment.center,
            child: Text(dataGridCell.value.toString()),
          );
        },
      ).toList(),
    );
  }
}

class PlanWindingLoadStatusDataSource extends DataGridSource {
  PlanWindingLoadStatusDataSource({
    List<PMDailyCheckPointSQLiteModel>? CHECKPOINT,
  }) {
    int countloop = 0;
    if (CHECKPOINT != null) {
      for (var _item in CHECKPOINT) {
        countloop++;
        _employees.add(
          DataGridRow(
            cells: [
              DataGridCell<String>(columnName: 'no', value: _item.STATUS),
              DataGridCell<String>(
                  columnName: 'status', value: _item.DESCRIPTION),
            ],
          ),
        );
      }
    } else {
      EasyLoading.showError("Can not Call API");
    }
    // }
  }

  List<DataGridRow> _employees = [];
  DatabaseHelper databaseHelper = DatabaseHelper();
  PMDaily_Screen? PMDailyScreen;

  @override
  List<DataGridRow> get rows => _employees;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>(
        (dataGridCell) {
          return Container(
            alignment: (dataGridCell.columnName == 'id' ||
                    dataGridCell.columnName == 'qty')
                ? Alignment.center
                : Alignment.center,
            child: Text(dataGridCell.value.toString()),
          );
        },
      ).toList(),
    );
  }
}
