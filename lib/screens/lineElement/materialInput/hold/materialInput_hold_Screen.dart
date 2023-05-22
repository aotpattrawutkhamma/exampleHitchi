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
  const MaterialInputHoldScreen({super.key});

  @override
  State<MaterialInputHoldScreen> createState() =>
      _MaterialInputHoldScreenState();
}

class _MaterialInputHoldScreenState extends State<MaterialInputHoldScreen> {
  List<MaterialTraceModel>? materialList;
  DatabaseHelper databaseHelper = DatabaseHelper();
  MaterialTraceDataSource? matTracDs;
  int? index;
  int? allRowIndex;
  DataGridRow? datagridRow;
  List<MaterialTraceModel>? mtModelSqlite;
  final TextEditingController _passwordController = TextEditingController();
  Color _colorSend = COLOR_GREY;
  Color _colorDelete = COLOR_GREY;
  List<MaterialTraceModel> selectAll = [];

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

  void deletedInfo() async {
    if (index != null) {
      for (var row in selectAll) {
        await databaseHelper.deletedRowSqlite(
            tableName: 'MATERIAL_TRACE_SHEET',
            columnName: 'ID',
            columnValue: row.ID);
      }
    } else if (allRowIndex != null) {
      for (var row in materialList!) {
        await databaseHelper.deletedRowSqlite(
            tableName: 'MATERIAL_TRACE_SHEET',
            columnName: 'ID',
            columnValue: row.ID);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BgWhite(
        isHideAppBar: true,
        textTitle: "Material Input",
        body: MultiBlocListener(
          listeners: [
            BlocListener<LineElementBloc, LineElementState>(
              listener: (context, state) {
                if (state is MaterialInputLoadingState) {
                  EasyLoading.show();
                } else if (state is MaterialInputLoadedState) {
                  if (state.item.RESULT == true) {
                    deletedInfo();
                    Navigator.canPop(context);
                    EasyLoading.dismiss();
                    EasyLoading.showSuccess("Send complete",
                        duration: Duration(seconds: 3));
                  } else {
                    EasyLoading.showError("Please Check Data");
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
                            onSelectionChanged:
                                (selectRow, deselectedRows) async {
                              if (selectRow.isNotEmpty) {
                                if (selectRow.length ==
                                    matTracDs!.effectiveRows.length) {
                                  print("all");
                                  setState(() {
                                    selectRow.forEach((row) {
                                      allRowIndex =
                                          matTracDs!.effectiveRows.indexOf(row);

                                      _colorSend = COLOR_SUCESS;
                                      _colorDelete = COLOR_RED;
                                    });
                                  });
                                } else if (selectRow.length !=
                                    matTracDs!.effectiveRows.length) {
                                  setState(() {
                                    selectRow.forEach((element) {
                                      index = selectRow.isNotEmpty
                                          ? matTracDs!.effectiveRows
                                              .indexOf(element)
                                          : null;
                                      datagridRow = matTracDs!.effectiveRows
                                          .elementAt(index!);
                                      mtModelSqlite = datagridRow!
                                          .getCells()
                                          .map(
                                            (e) => MaterialTraceModel(),
                                          )
                                          .toList();
                                    });
                                    if (!selectAll
                                        .contains(materialList![index!])) {
                                      selectAll.add(materialList![index!]);
                                      print(selectAll.length);
                                    }
                                    // selectAll.add(materialList![index!]);
                                    _colorSend = COLOR_SUCESS;
                                    _colorDelete = COLOR_RED;
                                  });
                                }
                              } else {
                                setState(() {
                                  if (selectAll
                                      .contains(materialList![index!])) {
                                    selectAll.remove(materialList![index!]);
                                    print(selectAll.length);
                                  }
                                  _colorSend = Colors.grey;
                                  _colorDelete = Colors.grey;
                                });

                                print('No Rows Selected');
                              }
                            },
                            onCellTap: (details) async {
                              if (details.rowColumnIndex.rowIndex != 0) {
                                setState(() {
                                  index = details.rowColumnIndex.rowIndex - 1;
                                  datagridRow = matTracDs!.effectiveRows
                                      .elementAt(index!);
                                  mtModelSqlite = datagridRow!
                                      .getCells()
                                      .map(
                                        (e) => MaterialTraceModel(
                                          MATERIAL: e.value.toString(),
                                        ),
                                      )
                                      .toList();
                                });
                                _colorDelete = COLOR_RED;
                                _colorSend = COLOR_SUCESS;
                              }
                            },
                            columns: <GridColumn>[
                              // GridColumn(
                              //   columnName: 'matType',
                              //   label: Container(
                              //     color: COLOR_BLUE_DARK,
                              //     child: Center(
                              //       child: Label(
                              //         'Type',
                              //         color: COLOR_WHITE,
                              //       ),
                              //     ),
                              //   ),
                              // ),
                              GridColumn(
                                  columnName: 'mat',
                                  label: Container(
                                    color: COLOR_BLUE_DARK,
                                    child: Center(
                                      child:
                                          Label('Material', color: COLOR_WHITE),
                                    ),
                                  ),
                                  width: 100),
                              GridColumn(
                                  columnName: 'operator',
                                  label: Container(
                                    color: COLOR_BLUE_DARK,
                                    child: Center(
                                      child:
                                          Label('Operator', color: COLOR_WHITE),
                                    ),
                                  ),
                                  width: 100),
                              GridColumn(
                                  columnName: 'batch',
                                  label: Container(
                                    color: COLOR_BLUE_DARK,
                                    child: Center(
                                      child: Label('Batch/Serial',
                                          color: COLOR_WHITE),
                                    ),
                                  ),
                                  width: 100),
                              GridColumn(
                                columnName: 'Machine',
                                label: Container(
                                  color: COLOR_BLUE_DARK,
                                  child: Center(
                                    child: Label('Machine', color: COLOR_WHITE),
                                  ),
                                ),
                              ),
                              // GridColumn(
                              //   columnName: 'mat1',
                              //   label: Container(
                              //     color: COLOR_BLUE_DARK,
                              //     child: Center(
                              //       child:
                              //           Label('Material1', color: COLOR_WHITE),
                              //     ),
                              //   ),
                              // ),
                              GridColumn(
                                columnName: 'lotNo1',
                                label: Container(
                                  color: COLOR_BLUE_DARK,
                                  child: Center(
                                    child: Label('Lot No', color: COLOR_WHITE),
                                  ),
                                ),
                              ),
                              GridColumn(
                                columnName: 'Date',
                                label: Container(
                                  color: COLOR_BLUE_DARK,
                                  child: Center(
                                    child: Label('Date', color: COLOR_WHITE),
                                  ),
                                ),
                              ),
                              // GridColumn(
                              //   columnName: 'mat2',
                              //   label: Container(
                              //     color: COLOR_BLUE_DARK,
                              //     child: Center(
                              //       child:
                              //           Label('Material', color: COLOR_WHITE),
                              //     ),
                              //   ),
                              // ),
                              // GridColumn(
                              //   columnName: 'lotNo2',
                              //   label: Container(
                              //     color: COLOR_BLUE_DARK,
                              //     child: Center(
                              //       child: Label('Lot No', color: COLOR_WHITE),
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      )
                    : CircularProgressIndicator(),
                const SizedBox(height: 20),
                mtModelSqlite != null
                    ? Expanded(
                        child: Container(
                            child: ListView(
                          children: [
                            DataTable(
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
                                  //       "${materialList![index!].MATERIAL_TYPE}"))
                                  // ]),
                                  DataRow(cells: [
                                    DataCell(Center(child: Label("Material"))),
                                    DataCell(Label(
                                        "${materialList![index!].MATERIAL}"))
                                  ]),
                                  DataRow(cells: [
                                    DataCell(
                                        Center(child: Label("Operator Name"))),
                                    DataCell(Label(
                                        "${materialList![index!].OPERATOR_NAME}"))
                                  ]),
                                  DataRow(cells: [
                                    DataCell(Center(
                                        child: Label("Batch/Serial No."))),
                                    DataCell(Label(
                                        "${materialList![index!].BATCH_NO}"))
                                  ]),
                                  DataRow(cells: [
                                    DataCell(Center(
                                        child: Label("Machine/Process"))),
                                    DataCell(Label(
                                        "${materialList![index!].MACHINE_NO}"))
                                  ]),
                                  // DataRow(cells: [
                                  //   DataCell(Center(child: Label("Material"))),
                                  //   DataCell(Label(
                                  //       "${materialList![index!].MATERIAL_1}"))
                                  // ]),
                                  DataRow(cells: [
                                    DataCell(Center(child: Label("Lot No."))),
                                    DataCell(Label(
                                        "${materialList![index!].LOTNO_1}"))
                                  ]),
                                  DataRow(cells: [
                                    DataCell(Center(child: Label("Date"))),
                                    DataCell(Label(
                                        "${materialList![index!].DATE_1}"))
                                  ])
                                ])
                          ],
                        )),
                      )
                    : Expanded(
                        child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Label(
                                "No data",
                                color: COLOR_RED,
                                fontSize: 30,
                              ),
                              CircularProgressIndicator()
                            ],
                          ),
                        ),
                      ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                        child: Button(
                      onPress: () {
                        if (mtModelSqlite != null) {
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
                        if (materialList != null) {
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
    if (index != null) {
      for (var row in selectAll) {
        BlocProvider.of<LineElementBloc>(context).add(
          MaterialInputEvent(
            MaterialOutputModel(
              MATERIAL: row.MATERIAL,
              MACHINENO: row.MACHINE_NO,
              OPERATORNAME: int.tryParse(row.OPERATOR_NAME.toString()),
              BATCHNO: int.tryParse(row.BATCH_NO.toString()),
              LOT: row.LOTNO_1,
              STARTDATE: row.DATE_1,
            ),
          ),
        );
        print("Check ${row.ID}");
      }
    } else if (allRowIndex != null) {
      for (var row in materialList!) {
        BlocProvider.of<LineElementBloc>(context).add(
          MaterialInputEvent(
            MaterialOutputModel(
              MATERIAL: row.MATERIAL,
              MACHINENO: row.MACHINE_NO,
              OPERATORNAME: int.tryParse(row.OPERATOR_NAME.toString()),
              BATCHNO: int.tryParse(row.BATCH_NO.toString()),
              LOT: row.LOTNO_1,
              STARTDATE: row.DATE_1,
            ),
          ),
        );
      }
    }
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
            onPressed: () {
              deletedInfo();
              Navigator.pop(context);
              Navigator.pop(context);
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
              // DataGridCell<String>(
              //     columnName: 'matType', value: _item.MATERIAL_TYPE),
              DataGridCell<String>(columnName: 'mat', value: _item.MATERIAL),
              DataGridCell<String>(
                  columnName: 'operator', value: _item.BATCH_NO),
              DataGridCell<String>(columnName: 'batch', value: _item.BATCH_NO),
              // DataGridCell<String>(
              //     columnName: 'Machine', value: _item.MACHINE_NO),
              DataGridCell<String>(columnName: 'Mat1', value: _item.MATERIAL_1),
              DataGridCell<String>(columnName: 'lotNo1', value: _item.LOTNO_1),
              DataGridCell<String>(columnName: 'Date', value: _item.DATE_1),
              // DataGridCell<String>(columnName: 'Mat2', value: _item.MATERIAL_2),
              // DataGridCell<String>(columnName: 'lotNo2', value: _item.LOT_NO_2),
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
