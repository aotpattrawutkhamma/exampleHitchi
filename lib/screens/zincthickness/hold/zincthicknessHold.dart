import 'dart:convert';

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
import 'package:hitachi/models-Sqlite/zincModelSqlite.dart';
import 'package:hitachi/models/zincthickness/zincOutputModel.dart';
import 'package:hitachi/services/databaseHelper.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class ZincThickNessHold extends StatefulWidget {
  ZincThickNessHold({super.key, this.onChange});
  ValueChanged<List<Map<String, dynamic>>>? onChange;

  @override
  State<ZincThickNessHold> createState() => _ZincThickNessHoldState();
}

class _ZincThickNessHoldState extends State<ZincThickNessHold> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  ZincDataSource? zincDataSource;
  List<ZincModelSqlite> zincList = [];
  List<ZincModelSqlite> zincSqlite = [];
  List<int> _index = [];
  DataGridRow? datagridRow;
  Color _colorSend = COLOR_GREY;
  Color _colorDelete = COLOR_GREY;
  Map<String, double> columnWidths = {
    'ID': double.nan,
    'batch': double.nan,
    't1': double.nan,
    't2': double.nan,
    't3': double.nan,
    't4': double.nan,
    't6': double.nan,
    't7': double.nan,
    't8': double.nan,
    't9': double.nan,
    'date': double.nan,
  };

  @override
  void initState() {
    _checkExpiresData();
    _getZincSheet().then((result) {
      setState(() {
        zincList = result;
        zincDataSource = ZincDataSource(process: zincList);
      });
    });
    super.initState();
  }

  Future<void> _getHold() async {
    List<Map<String, dynamic>> sql =
        await databaseHelper.queryAllRows('ZINCTHICKNESS_SHEET');
    setState(() {
      widget.onChange?.call(sql);
    });
  }

  void _checkExpiresData() async {
    var sql = await databaseHelper.queryAllRows('ZINCTHICKNESS_SHEET');
    DateTime currentDate = DateTime.now();
    if (sql.length > 0) {
      await databaseHelper.deleted('ZINCTHICKNESS_SHEET',
          "DATE(DateData, '+7 days') < DATE('${currentDate}')");
    } else {
      EasyLoading.showError("Data not found");
    }
  }

  Future<List<ZincModelSqlite>> _getZincSheet() async {
    try {
      List<Map<String, dynamic>> rows =
          await databaseHelper.queryAllRows('ZINCTHICKNESS_SHEET');
      List<ZincModelSqlite> result =
          rows.map((row) => ZincModelSqlite.fromMap(row)).toList();
      return result;
    } on Exception {
      throw Exception();
    }
  }

  Future _refreshPage() async {
    _getZincSheet().then((result) {
      setState(() {
        zincList = result;
        zincDataSource = ZincDataSource(process: zincList);
      });
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
                await deletedInfo();
                await _refreshPage();
                await _getHold();
                EasyLoading.showSuccess("Send complete ",
                    duration: Duration(seconds: 3));
              } else if (state.item.RESULT == false) {
                _errorDialog(
                    isHideCancle: false,
                    text: Label("${state.item.MESSAGE}"),
                    onpressOk: () => Navigator.pop(context));
              }
            }
            if (state is ZincThicknessErrorState) {
              EasyLoading.dismiss();
              EasyLoading.showError("Check connection ");
            }
          },
        )
      ],
      child: BgWhite(
          isHideAppBar: true,
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                zincDataSource != null
                    ? Expanded(
                        child: Container(
                          child: SfDataGrid(
                            showCheckboxColumn: true,
                            source: zincDataSource!,
                            headerGridLinesVisibility: GridLinesVisibility.both,
                            gridLinesVisibility: GridLinesVisibility.both,
                            selectionMode: SelectionMode.multiple,
                            allowPullToRefresh: true,
                            allowColumnsResizing: true,
                            onColumnResizeUpdate:
                                (ColumnResizeUpdateDetails details) {
                              setState(() {
                                columnWidths[details.column.columnName] =
                                    details.width;
                              });
                              return true;
                            },
                            columnResizeMode: ColumnResizeMode.onResizeEnd,
                            onSelectionChanged:
                                (selectRow, deselectedRows) async {
                              if (selectRow.isNotEmpty) {
                                if (selectRow.length ==
                                        zincDataSource!.effectiveRows.length &&
                                    selectRow.length > 1) {
                                  setState(() {
                                    selectRow.forEach((row) {
                                      _index.add(int.tryParse(
                                          row.getCells()[0].value.toString())!);

                                      _colorSend = COLOR_BLUE_DARK;
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
                                    zincSqlite = datagridRow!
                                        .getCells()
                                        .map(
                                          (e) => ZincModelSqlite(),
                                        )
                                        .toList();
                                    print(_index);
                                    _colorSend = COLOR_BLUE_DARK;
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
                                  _colorSend = Colors.grey;
                                  _colorDelete = Colors.grey;
                                });
                              }
                            },
                            columns: <GridColumn>[
                              GridColumn(
                                visible: false,
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
                                width: columnWidths['batch']!,
                                columnName: 'batch',
                                label: Container(
                                  color: COLOR_BLUE_DARK,
                                  child: Center(
                                    child: Label(
                                      'Batch',
                                      color: COLOR_WHITE,
                                    ),
                                  ),
                                ),
                              ),
                              GridColumn(
                                width: columnWidths['t1']!,
                                columnName: 't1',
                                label: Container(
                                  color: COLOR_BLUE_DARK,
                                  child: Center(
                                    child:
                                        Label('Thickness1', color: COLOR_WHITE),
                                  ),
                                ),
                              ),
                              GridColumn(
                                columnName: 't2',
                                label: Container(
                                  color: COLOR_BLUE_DARK,
                                  child: Center(
                                    child:
                                        Label('Thickness2', color: COLOR_WHITE),
                                  ),
                                ),
                                width: columnWidths['t2']!,
                              ),
                              GridColumn(
                                columnName: 't3',
                                label: Container(
                                  color: COLOR_BLUE_DARK,
                                  child: Center(
                                    child:
                                        Label('Thickness3', color: COLOR_WHITE),
                                  ),
                                ),
                                width: columnWidths['t3']!,
                              ),
                              GridColumn(
                                width: columnWidths['t4']!,
                                columnName: 't4',
                                label: Container(
                                  color: COLOR_BLUE_DARK,
                                  child: Center(
                                    child:
                                        Label('Thickness4', color: COLOR_WHITE),
                                  ),
                                ),
                              ),
                              GridColumn(
                                width: columnWidths['t6']!,
                                columnName: 't6',
                                label: Container(
                                  color: COLOR_BLUE_DARK,
                                  child: Center(
                                    child:
                                        Label('Thickness6', color: COLOR_WHITE),
                                  ),
                                ),
                              ),
                              GridColumn(
                                width: columnWidths['t7']!,
                                columnName: 't7',
                                label: Container(
                                  color: COLOR_BLUE_DARK,
                                  child: Center(
                                    child:
                                        Label('Thickness7', color: COLOR_WHITE),
                                  ),
                                ),
                              ),
                              GridColumn(
                                width: columnWidths['t8']!,
                                columnName: 't8',
                                label: Container(
                                  color: COLOR_BLUE_DARK,
                                  child: Center(
                                    child:
                                        Label('Thickness8', color: COLOR_WHITE),
                                  ),
                                ),
                              ),
                              GridColumn(
                                width: columnWidths['t9']!,
                                columnName: 't9',
                                label: Container(
                                  color: COLOR_BLUE_DARK,
                                  child: Center(
                                    child:
                                        Label('Thickness9', color: COLOR_WHITE),
                                  ),
                                ),
                              ),
                              GridColumn(
                                width: columnWidths['date']!,
                                columnName: 'date',
                                label: Container(
                                  color: COLOR_BLUE_DARK,
                                  child: Center(
                                    child:
                                        Label('DateTime', color: COLOR_WHITE),
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
                          itemCount: _index.length,
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
                                  DataCell(Center(child: Label("Batch"))),
                                  DataCell(Label(
                                      "${zincList.where((element) => element.ID == _index.first).first.Batch}"))
                                ]),
                                DataRow(cells: [
                                  DataCell(Center(child: Label("Thickness1"))),
                                  DataCell(Label(
                                      "${zincList.where((element) => element.ID == _index.first).first.Thickness1}"))
                                ]),
                                DataRow(cells: [
                                  DataCell(Center(child: Label("Thickness2"))),
                                  DataCell(Label(
                                      "${zincList.where((element) => element.ID == _index.first).first.Thickness2}"))
                                ]),
                                DataRow(cells: [
                                  DataCell(Center(child: Label("Thickness3"))),
                                  DataCell(Label(
                                      "${zincList.where((element) => element.ID == _index.first).first.Thickness3}"))
                                ]),
                                DataRow(cells: [
                                  DataCell(Center(child: Label("Thickness4"))),
                                  DataCell(Label(
                                      "${zincList.where((element) => element.ID == _index.first).first.Thickness4}"))
                                ]),
                                DataRow(cells: [
                                  DataCell(Center(child: Label("Thickness6"))),
                                  DataCell(Label(
                                      "${zincList.where((element) => element.ID == _index.first).first.Thickness6}"))
                                ]),
                                DataRow(cells: [
                                  DataCell(Center(child: Label("Thickness7"))),
                                  DataCell(Label(
                                      "${zincList.where((element) => element.ID == _index.first).first.Thickness7}"))
                                ]),
                                DataRow(cells: [
                                  DataCell(Center(child: Label("Thickness8"))),
                                  DataCell(Label(
                                      "${zincList.where((element) => element.ID == _index.first).first.Thickness8}"))
                                ]),
                                DataRow(cells: [
                                  DataCell(Center(child: Label("Thickness9"))),
                                  DataCell(Label(
                                      "${zincList.where((element) => element.ID == _index.first).first.Thickness9}"))
                                ]),
                                DataRow(cells: [
                                  DataCell(Center(child: Label("DateTime"))),
                                  DataCell(Label(
                                      "${zincList.where((element) => element.ID == _index.first).first.DateData}"))
                                ])
                              ],
                            );
                          }),
                        ),
                      )
                    : Container(),
                const SizedBox(height: 20),
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
          )),
    );
  }

  void _AlertDialog() async {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Label("Do you want Delete "),
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await deletedInfo();
              await _refreshPage();
              await _getHold();
              EasyLoading.showSuccess("Delete Complete",
                  duration: Duration(seconds: 3));
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _sendDataServer() async {
    _index.forEach((element) async {
      var row = zincList.where((value) => value.ID == element).first;
      BlocProvider.of<ZincThicknessBloc>(context).add(
        ZincThickNessSendEvent(ZincThicknessOutputModel(
            BATCHNO: row.Batch,
            THICKNESS1: row.Thickness1,
            THICKNESS2: row.Thickness2,
            THICKNESS3: row.Thickness3,
            THICKNESS4: row.Thickness4,
            THICKNESS6: row.Thickness6,
            THICKNESS7: row.Thickness7,
            THICKNESS8: row.Thickness8,
            THICKNESS9: row.Thickness9,
            STARTDATE: row.DateData)),
      );
    });
  }

  Future deletedInfo() async {
    setState(() {
      _index.forEach((element) async {
        await databaseHelper.deletedRowSqlite(
            tableName: 'ZINCTHICKNESS_SHEET',
            columnName: 'ID',
            columnValue: element);
        _index.clear();
      });
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
}

class ZincDataSource extends DataGridSource {
  ZincDataSource({List<ZincModelSqlite>? process}) {
    try {
      if (process != null) {
        for (var _item in process) {
          _employees.add(
            DataGridRow(
              cells: [
                DataGridCell<int>(columnName: 'ID', value: _item.ID),
                DataGridCell<String>(columnName: 'batch', value: _item.Batch),
                DataGridCell<String>(columnName: 't1', value: _item.Thickness1),
                DataGridCell<String>(columnName: 't2', value: _item.Thickness2),
                DataGridCell<String>(columnName: 't3', value: _item.Thickness3),
                DataGridCell<String>(columnName: 't4', value: _item.Thickness4),
                DataGridCell<String>(columnName: 't6', value: _item.Thickness6),
                DataGridCell<String>(columnName: 't7', value: _item.Thickness7),
                DataGridCell<String>(columnName: 't8', value: _item.Thickness8),
                DataGridCell<String>(columnName: 't9', value: _item.Thickness9),
                DataGridCell<String>(columnName: 'date', value: _item.DateData),
              ],
            ),
          );
        }
      }
    } catch (e) {
      print(e);
      EasyLoading.showError("Can not Call API");
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
