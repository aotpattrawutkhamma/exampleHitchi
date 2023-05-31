import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hitachi/blocs/lineElement/line_element_bloc.dart';
import 'package:hitachi/helper/background/bg_white.dart';
import 'package:hitachi/helper/button/Button.dart';
import 'package:hitachi/helper/colors/colors.dart';
import 'package:hitachi/helper/text/label.dart';
import 'package:hitachi/models-Sqlite/materialtraceModel.dart';
import 'package:hitachi/models/materialInput/materialOutputModel.dart';

import 'package:hitachi/services/databaseHelper.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class MaterialInputHoldScreen extends StatefulWidget {
  MaterialInputHoldScreen({super.key, this.onChange});
  ValueChanged<List<Map<String, dynamic>>>? onChange;

  @override
  State<MaterialInputHoldScreen> createState() =>
      _MaterialInputHoldScreenState();
}

class _MaterialInputHoldScreenState extends State<MaterialInputHoldScreen> {
  List<MaterialTraceModel> materialList = [];
  DatabaseHelper databaseHelper = DatabaseHelper();
  MaterialTraceDataSource? matTracDs;
  List<int> _index = [];
  int? allRowIndex;
  DataGridRow? datagridRow;
  List<MaterialTraceModel>? mtModelSqlite;
  final TextEditingController _passwordController = TextEditingController();
  Color _colorSend = COLOR_GREY;
  Color _colorDelete = COLOR_GREY;
  List<MaterialTraceModel> selectAll = [];

  Map<String, double> columnWidths = {
    'ID': double.nan,
    'mat': double.nan,
    'operator': double.nan,
    'batch': double.nan,
    'Mat1': double.nan,
    'lotNo1': double.nan,
    'Date': double.nan,
  };
  Future _getHold() async {
    List<Map<String, dynamic>> sql =
        await databaseHelper.queryAllRows('MATERIAL_TRACE_SHEET');
    setState(() {
      widget.onChange?.call(sql);
    });
  }

  ////
  Future<List<MaterialTraceModel>> _getMaterialSheet() async {
    try {
      List<Map<String, dynamic>> rows =
          await databaseHelper.queryAllRows('MATERIAL_TRACE_SHEET');
      List<MaterialTraceModel> result =
          rows.map((row) => MaterialTraceModel.fromMap(row)).toList();
      return result;
    } catch (e) {
      print(e);
      return [];
    }
  }

  @override
  void initState() {
    _getMaterialSheet().then((result) {
      setState(() {
        materialList = result;
        matTracDs = MaterialTraceDataSource(process: materialList);
      });
    });
    super.initState();
  }

  Future _refresh() async {
    await Future.delayed(Duration(seconds: 1), () {
      _getMaterialSheet().then((result) {
        setState(() {
          materialList = result;
          matTracDs = MaterialTraceDataSource(process: materialList);
        });
      });
    });
  }

  Future deletedInfo() async {
    setState(() {
      _index.forEach((element) async {
        await databaseHelper.deletedRowSqlite(
            tableName: 'MATERIAL_TRACE_SHEET',
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

  @override
  Widget build(BuildContext context) {
    return BgWhite(
        isHideAppBar: true,
        body: MultiBlocListener(
          listeners: [
            BlocListener<LineElementBloc, LineElementState>(
              listener: (context, state) async {
                if (state is MaterialInputLoadingState) {
                  EasyLoading.show();
                } else if (state is MaterialInputLoadedState) {
                  EasyLoading.dismiss();
                  if (state.item.RESULT == true) {
                    await deletedInfo();
                    await _getHold();
                    await _refresh();

                    EasyLoading.showSuccess("Send complete",
                        duration: Duration(seconds: 3));
                  } else {
                    _errorDialog(
                        isHideCancle: false,
                        text: Label(
                            "${state.item.MESSAGE ?? "Check Connection"}"),
                        onpressOk: () => Navigator.pop(context));
                  }
                } else {
                  EasyLoading.dismiss();
                  EasyLoading.showError("Please Check Connection Internet");
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
                            showCheckboxColumn: true,
                            source: matTracDs!,
                            headerGridLinesVisibility: GridLinesVisibility.both,
                            gridLinesVisibility: GridLinesVisibility.both,
                            selectionMode: SelectionMode.multiple,
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
                            columnResizeMode: ColumnResizeMode.onResizeEnd,
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
                                    mtModelSqlite = datagridRow!
                                        .getCells()
                                        .map(
                                          (e) => MaterialTraceModel(),
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
                                      'Type',
                                      color: COLOR_WHITE,
                                    ),
                                  ),
                                ),
                              ),
                              GridColumn(
                                columnName: 'mat',
                                label: Container(
                                  color: COLOR_BLUE_DARK,
                                  child: Center(
                                    child:
                                        Label('Material', color: COLOR_WHITE),
                                  ),
                                ),
                                width: columnWidths['mat']!,
                              ),
                              GridColumn(
                                columnName: 'operator',
                                label: Container(
                                  color: COLOR_BLUE_DARK,
                                  child: Center(
                                    child:
                                        Label('Operator', color: COLOR_WHITE),
                                  ),
                                ),
                                width: columnWidths['operator']!,
                              ),
                              GridColumn(
                                columnName: 'batch',
                                label: Container(
                                  color: COLOR_BLUE_DARK,
                                  child: Center(
                                    child: Label('Batch/Serial',
                                        color: COLOR_WHITE),
                                  ),
                                ),
                                width: columnWidths['batch']!,
                              ),
                              GridColumn(
                                width: columnWidths['Mat1']!,
                                columnName: 'Mat1',
                                label: Container(
                                  color: COLOR_BLUE_DARK,
                                  child: Center(
                                    child: Label('Machine', color: COLOR_WHITE),
                                  ),
                                ),
                              ),
                              GridColumn(
                                width: columnWidths['lotNo1']!,
                                columnName: 'lotNo1',
                                label: Container(
                                  color: COLOR_BLUE_DARK,
                                  child: Center(
                                    child: Label('Lot No', color: COLOR_WHITE),
                                  ),
                                ),
                              ),
                              GridColumn(
                                width: columnWidths['Date']!,
                                columnName: 'Date',
                                label: Container(
                                  color: COLOR_BLUE_DARK,
                                  child: Center(
                                    child: Label('Date', color: COLOR_WHITE),
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
                                // DataRow(cells: [
                                //   DataCell(
                                //       Center(child: Label("MaterialType"))),
                                //   DataCell(Label(
                                //       "${materialList.where((element) => element.ID == _index.first).first.MATERIAL_TYPE}"))
                                // ]),
                                DataRow(cells: [
                                  DataCell(Center(child: Label("Material"))),
                                  DataCell(Label(
                                      "${materialList.where((element) => element.ID == _index.first).first.MATERIAL}"))
                                ]),
                                DataRow(cells: [
                                  DataCell(
                                      Center(child: Label("Operator Name"))),
                                  DataCell(Label(
                                      "${materialList.where((element) => element.ID == _index.first).first.OPERATOR_NAME}"))
                                ]),
                                DataRow(cells: [
                                  DataCell(Center(
                                      child: Label("Batch / Serial No."))),
                                  DataCell(Label(
                                      "${materialList.where((element) => element.ID == _index.first).first.BATCH_NO}"))
                                ]),
                                DataRow(cells: [
                                  DataCell(Center(
                                      child: Label("Machine / Process"))),
                                  DataCell(Label(
                                      "${materialList.where((element) => element.ID == _index.first).first.MACHINE_NO}"))
                                ]),
                                DataRow(cells: [
                                  DataCell(Center(child: Label("Lot No."))),
                                  DataCell(Label(
                                      "${materialList.where((element) => element.ID == _index.first).first.LOTNO_1}"))
                                ]),
                                DataRow(cells: [
                                  DataCell(Center(child: Label("Date"))),
                                  DataCell(Label(
                                      "${materialList.where((element) => element.ID == _index.first).first.DATE_1}"))
                                ]),
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
          ),
        ));
  }

  _sendDataServer() {
    _index.forEach((element) async {
      var row = materialList.where((value) => value.ID == element).first;
      BlocProvider.of<LineElementBloc>(context).add(
        MaterialInputEvent(
          MaterialOutputModel(
            MATERIAL: row.MATERIAL,
            MACHINENO: row.MACHINE_NO,
            OPERATORNAME: int.tryParse(row.OPERATOR_NAME.toString()),
            BATCHNO: row.BATCH_NO.toString(),
            LOT: row.LOTNO_1,
            STARTDATE: row.DATE_1,
          ),
        ),
      );
    });
  }

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
              child: Label("Do you want Delete "),
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
              await _getHold();
              await _refresh();

              EasyLoading.showSuccess("Delete Success");
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

class MaterialTraceDataSource extends DataGridSource {
  MaterialTraceDataSource({List<MaterialTraceModel>? process}) {
    if (process != null) {
      for (var _item in process) {
        _employees.add(
          DataGridRow(
            cells: [
              DataGridCell<int>(columnName: 'ID', value: _item.ID),
              DataGridCell<String>(columnName: 'mat', value: _item.MATERIAL),
              DataGridCell<String>(
                  columnName: 'operator', value: _item.BATCH_NO),
              DataGridCell<String>(columnName: 'batch', value: _item.BATCH_NO),

              DataGridCell<String>(columnName: 'Mat1', value: _item.MACHINE_NO),
              DataGridCell<String>(columnName: 'lotNo1', value: _item.LOTNO_1),
              DataGridCell<String>(columnName: 'Date', value: _item.DATE_1),
              // DataGridCell<String>(columnName: 'Mat2', value: _item.MATERIAL_2),
              // DataGridCell<String>(columnName: 'lotNo2', value: _item.LOT_NO_2),
              // DataGridCell<String>(
              //     columnName: 'Machine', value: _item.MACHINE_NO),
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
