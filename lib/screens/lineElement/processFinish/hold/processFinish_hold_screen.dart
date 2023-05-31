import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hitachi/blocs/lineElement/line_element_bloc.dart';
import 'package:hitachi/helper/background/bg_white.dart';
import 'package:hitachi/helper/button/Button.dart';
import 'package:hitachi/helper/colors/colors.dart';
import 'package:hitachi/helper/text/label.dart';
import 'package:hitachi/models-Sqlite/materialtraceModel.dart';
import 'package:hitachi/models-Sqlite/processModel.dart';
import 'package:hitachi/models/materialInput/materialOutputModel.dart';
import 'package:hitachi/models/processFinish/processFinishOutput.dart';
import 'package:hitachi/models/processStart/processOutputModel.dart';

import 'package:hitachi/services/databaseHelper.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class ProcessFinishHoldScreen extends StatefulWidget {
  ProcessFinishHoldScreen({super.key, this.onChange});
  ValueChanged<List<Map<String, dynamic>>>? onChange;

  @override
  State<ProcessFinishHoldScreen> createState() =>
      _ProcessFinishHoldScreenState();
}

class _ProcessFinishHoldScreenState extends State<ProcessFinishHoldScreen> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  ProcessStartDataSource? matTracDs;
  List<int> _index = [];
  DataGridRow? datagridRow;

  List<ProcessModel>? processModelSqlite;
  List<ProcessModel> processList = [];
  final TextEditingController _passwordController = TextEditingController();

  Color _colorSend = COLOR_GREY;
  Color _colorDelete = COLOR_GREY;

  int? index;
  int? allRowIndex;
  List<ProcessModel> selectAll = [];
  String StartEndValue = 'E';

  late Map<String, double> columnWidths = {
    'ID': double.nan,
    'Machine': double.nan,
    'Operatorname': double.nan,
    'RejectQTY': double.nan,
    'BatchNO': double.nan,
    'FinDate': double.nan,
  };

  Future<List<ProcessModel>> _getProcessStart() async {
    try {
      List<Map<String, dynamic>> rows = await databaseHelper
          .queryAllProcessStartRows('PROCESS_SHEET', StartEndValue);
      // await databaseHelper.queryAllRows('PROCESS_SHEET');
      List<ProcessModel> result =
          rows.map((row) => ProcessModel.fromMap(row)).toList();
      return result;
    } catch (e) {
      print(e);
      return [];
    }
  }

  @override
  void initState() {
    _getHold();
    _getProcessStart().then((result) {
      setState(() {
        processList = result;
        matTracDs = ProcessStartDataSource(process: processList);
      });
    });
    super.initState();
  }

  Future _refreshPage() async {
    await Future.delayed(Duration(seconds: 1), () {
      _getProcessStart().then((result) {
        setState(() {
          processList = result;
          matTracDs = ProcessStartDataSource(process: processList);
        });
      });
    });
  }

  Future deletedInfo() async {
    setState(() {
      _index.forEach((element) async {
        await databaseHelper.deletedRowSqlite(
            tableName: 'PROCESS_SHEET', columnName: 'ID', columnValue: element);
        _index.clear();
      });
    });
  }

  Future _getHold() async {
    List<Map<String, dynamic>> sql =
        await databaseHelper.queryAllRows('PROCESS_SHEET');
    setState(() {
      widget.onChange
          ?.call(sql.where((element) => element['StartEnd'] == 'E').toList());
    });
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

  @override
  Widget build(BuildContext context) {
    return BgWhite(
        isHideAppBar: true,
        body: MultiBlocListener(
          listeners: [
            BlocListener<LineElementBloc, LineElementState>(
              listener: (context, state) async {
                if (state is ProcessFinishLoadingState) {
                  EasyLoading.show(status: "Loading...");
                } else if (state is ProcessFinishLoadedState) {
                  EasyLoading.dismiss();
                  if (state.item.RESULT == true) {
                    await deletedInfo();
                    await _refreshPage();
                    await _getHold();
                    EasyLoading.showSuccess("Send complete",
                        duration: Duration(seconds: 3));
                  } else {
                    _errorDialog(
                        isHideCancle: false,
                        text: Label(
                            "${state.item.MESSAGE ?? "Check Connection"}"),
                        onpressOk: () {
                          Navigator.pop(context);
                        });
                  }
                } else if (state is ProcessFinishErrorState) {
                  EasyLoading.dismiss();

                  _errorDialog(
                      text: Label("Check Connection"),
                      isHideCancle: false,
                      onpressOk: () async {
                        Navigator.pop(context);
                      });
                }
              },
            )
          ],
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                matTracDs != null
                    ? Expanded(
                        child: Container(
                          child: SfDataGrid(
                            source: matTracDs!,
                            showCheckboxColumn: true,
                            selectionMode: SelectionMode.multiple,
                            headerGridLinesVisibility: GridLinesVisibility.both,
                            gridLinesVisibility: GridLinesVisibility.both,
                            allowPullToRefresh: true,
                            allowColumnsResizing: true,
                            columnResizeMode: ColumnResizeMode.onResizeEnd,
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
                              if (selectRow.isNotEmpty) {
                                if (selectRow.length ==
                                        matTracDs!.effectiveRows.length &&
                                    selectRow.length > 1) {
                                  setState(() {
                                    selectRow.forEach((row) {
                                      _index.add(int.tryParse(
                                          row.getCells()[0].value.toString())!);

                                      _colorSend = COLOR_SUCESS;
                                      _colorDelete = COLOR_RED;
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
                                          (e) => ProcessModel(),
                                        )
                                        .toList();
                                    print(_index);
                                    _colorSend = COLOR_SUCESS;
                                    _colorDelete = COLOR_RED;
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
                            columns: <GridColumn>[
                              GridColumn(
                                visible: false,
                                width: columnWidths['ID']!,
                                columnName: 'ID',
                                label: Container(
                                  color: COLOR_BLUE_DARK,
                                  child: Center(
                                    child: Label(
                                      'ID',
                                      color: COLOR_WHITE,
                                    ),
                                  ),
                                ),
                              ),
                              GridColumn(
                                width: columnWidths['Machine']!,
                                columnName: 'Machine',
                                label: Container(
                                  color: COLOR_BLUE_DARK,
                                  child: Center(
                                    child: Label(
                                      'Machine',
                                      color: COLOR_WHITE,
                                    ),
                                  ),
                                ),
                              ),
                              GridColumn(
                                width: columnWidths['Operatorname']!,
                                columnName: 'Operatorname',
                                label: Container(
                                  color: COLOR_BLUE_DARK,
                                  child: Center(
                                    child: Label('Operatorname',
                                        color: COLOR_WHITE),
                                  ),
                                ),
                              ),
                              GridColumn(
                                width: columnWidths['RejectQTY']!,
                                columnName: 'RejectQTY',
                                label: Container(
                                  color: COLOR_BLUE_DARK,
                                  child: Center(
                                    child:
                                        Label('RejectQTY', color: COLOR_WHITE),
                                  ),
                                ),
                              ),
                              GridColumn(
                                width: columnWidths['BatchNO']!,
                                columnName: 'BatchNO',
                                label: Container(
                                  color: COLOR_BLUE_DARK,
                                  child: Center(
                                    child: Label('BatchNO', color: COLOR_WHITE),
                                  ),
                                ),
                              ),
                              GridColumn(
                                width: columnWidths['FinDate']!,
                                columnName: 'FinDate',
                                label: Container(
                                  color: COLOR_BLUE_DARK,
                                  child: Center(
                                    child: Label('Finish Date',
                                        color: COLOR_WHITE),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : CircularProgressIndicator(),
                const SizedBox(height: 20),
                _index.isNotEmpty
                    ? Expanded(
                        child: ListView.builder(
                          itemCount: 1,
                          itemBuilder: ((context, index) {
                            return DataTable(
                              horizontalMargin: 20,
                              headingRowHeight: 30,
                              dataRowHeight: 30,
                              headingRowColor: MaterialStateColor.resolveWith(
                                  (states) => COLOR_BLUE_DARK),
                              border: TableBorder.all(
                                width: 1.0,
                                color: COLOR_BLACK,
                              ),
                              columns: [
                                DataColumn(
                                  numeric: true,
                                  label: Label(
                                    "",
                                    color: COLOR_BLUE_DARK,
                                  ),
                                ),
                                DataColumn(label: Label(""))
                              ],
                              rows: [
                                DataRow(cells: [
                                  DataCell(Center(child: Label("Machine No."))),
                                  DataCell(Label(
                                      "${processList.where((element) => element.ID == _index.first).first.MACHINE}"))
                                ]),
                                DataRow(cells: [
                                  DataCell(
                                      Center(child: Label("Operator Name"))),
                                  DataCell(Label(
                                      "${processList.where((element) => element.ID == _index.first).first.OPERATOR_NAME}"))
                                ]),
                                DataRow(cells: [
                                  DataCell(Center(child: Label("RejectQTY"))),
                                  DataCell(Label(
                                      "${processList.where((element) => element.ID == _index.first).first.GARBAGE}"))
                                ]),
                                DataRow(cells: [
                                  DataCell(
                                      Center(child: Label("Batch/Serial No."))),
                                  DataCell(Label(
                                      "${processList.where((element) => element.ID == _index.first).first.BATCH_NO}"))
                                ]),
                                DataRow(cells: [
                                  DataCell(Center(child: Label("Finish Date"))),
                                  DataCell(Label(
                                      "${processList.where((element) => element.ID == _index.first).first.FINDATE}"))
                                ]),
                              ],
                            );
                          }),
                        ),
                      )
                    :
                    // CircularProgressIndicator(),
                    SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                        child: Button(
                      onPress: () {
                        if (_index.isNotEmpty) {
                          _AlertDialog();
                        } else {
                          EasyLoading.showInfo("Please Select Data");
                        }
                      },
                      text: Label(
                        "Delete",
                        color: COLOR_WHITE,
                      ),
                      bgColor: _colorDelete,
                    )),
                    Expanded(child: Container()),
                    Expanded(
                        child: Button(
                      text: Label("Send", color: COLOR_WHITE),
                      bgColor: _colorSend,
                      onPress: () {
                        if (_index.isNotEmpty) {
                          _sendDataServer();
                        } else {
                          EasyLoading.showInfo("Please Select Data");
                        }
                      },
                    )),
                  ],
                )
              ],
            ),
          ),
        ));
  }

  _sendDataServer() {
    _index.forEach((element) async {
      var row = processList.where((value) => value.ID == element).first;

      BlocProvider.of<LineElementBloc>(context).add(
        ProcessFinishInputEvent(ProcessFinishOutputModel(
          MACHINE: row.MACHINE,
          OPERATORNAME: int.tryParse(row.OPERATOR_NAME.toString()),
          REJECTQTY: row.GARBAGE.toString(),
          BATCHNO: int.tryParse(row.BATCH_NO.toString()),
          FINISHDATE: row.FINDATE.toString(),
        )),
      );
    });
  }

  // void _sendDataServer() async {
  //   _index.forEach((element) async {
  //     var row = processList.where((value) => value.ID == element).first;
  //     BlocProvider.of<LineElementBloc>(context).add(
  //       ProcessFinishInputEvent(
  //         ProcessFinishOutputModel(
  //           MACHINE: row.MACHINE,
  //           OPERATORNAME: int.tryParse(row.OPERATOR_NAME.toString()),
  //           REJECTQTY: row.GARBAGE.toString(),
  //           BATCHNO: int.tryParse(row.BATCH_NO.toString()),
  //           FINISHDATE: row.STARTDATE.toString(),
  //         ),
  //       ),
  //     );
  //   });
  // }

  void _AlertDialog() async {
    // EasyLoading.showError("Error[03]", duration: Duration(seconds: 5));//if password
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        // title: const Text('AlertDialog Title'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Label("Do you want Delete"),
            ),
          ],
        ),

        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await deletedInfo();
              await _refreshPage();
              await _getHold();
              EasyLoading.showSuccess("Delete Success");
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

class ProcessStartDataSource extends DataGridSource {
  ProcessStartDataSource({List<ProcessModel>? process}) {
    if (process != null) {
      for (var _item in process) {
        _employees.add(
          DataGridRow(
            cells: [
              DataGridCell<int>(columnName: 'ID', value: _item.ID),
              DataGridCell<String>(columnName: 'Machine', value: _item.MACHINE),
              DataGridCell<String>(
                  columnName: 'Operatorname', value: _item.OPERATOR_NAME),
              DataGridCell<String>(
                  columnName: 'RejectQTY', value: _item.GARBAGE),
              DataGridCell<int>(
                  columnName: 'BatchNO',
                  value: int.tryParse(_item.BATCH_NO.toString())),
              DataGridCell<String>(
                  columnName: 'FinDate', value: _item.FINDATE.toString()),
            ],
          ),
        );
      }
    } else {
      EasyLoading.showError("Can not request Data");
    }
  }

  List<DataGridRow> _employees = [];

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
