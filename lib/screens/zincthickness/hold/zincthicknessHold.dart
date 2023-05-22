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
  const ZincThickNessHold({super.key});

  @override
  State<ZincThickNessHold> createState() => _ZincThickNessHoldState();
}

class _ZincThickNessHoldState extends State<ZincThickNessHold> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  ZincDataSource? zincDataSource;
  List<ZincModelSqlite>? zincList;
  List<ZincModelSqlite> zincSqlite = [];
  List<ZincModelSqlite> selectAll = [];
  int? index;
  int? allRowIndex;
  DataGridRow? datagridRow;
  Color _colorSend = COLOR_GREY;
  Color _colorDelete = COLOR_GREY;

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

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ZincThicknessBloc, ZincThicknessState>(
          listener: (context, state) {
            if (state is ZincThicknessLoadingState) {
              EasyLoading.show(status: "Loading...");
            } else if (state is ZincThicknessLoadedState) {
              EasyLoading.dismiss();

              if (state.item.RESULT == true) {
                Navigator.pop(context);
                deletedInfo();
                EasyLoading.showSuccess("Send complete ",
                    duration: Duration(seconds: 3));
              } else if (state.item.RESULT == false) {
                EasyLoading.showError("Data not found ");
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
                            onSelectionChanged:
                                (selectRow, deselectedRows) async {
                              if (selectRow.isNotEmpty) {
                                if (selectRow.length ==
                                    zincDataSource!.effectiveRows.length) {
                                  print("all");
                                  setState(() {
                                    selectRow.forEach((row) {
                                      allRowIndex = zincDataSource!
                                          .effectiveRows
                                          .indexOf(row);

                                      _colorSend = COLOR_SUCESS;
                                      _colorDelete = COLOR_RED;
                                    });
                                  });
                                } else if (selectRow.length !=
                                    zincDataSource!.effectiveRows.length) {
                                  setState(() {
                                    selectRow.forEach((element) {
                                      index = selectRow.isNotEmpty
                                          ? zincDataSource!.effectiveRows
                                              .indexOf(element)
                                          : null;
                                      datagridRow = zincDataSource!
                                          .effectiveRows
                                          .elementAt(index!);
                                      zincSqlite = datagridRow!
                                          .getCells()
                                          .map(
                                            (e) => ZincModelSqlite(),
                                          )
                                          .toList();
                                    });
                                    if (!selectAll
                                        .contains(zincList![index!])) {
                                      selectAll.add(zincList![index!]);
                                      print(selectAll.length);
                                    }
                                    _colorSend = COLOR_SUCESS;
                                    _colorDelete = COLOR_RED;
                                  });
                                }
                              } else {
                                setState(() {
                                  if (selectAll.contains(zincList![index!])) {
                                    selectAll.remove(zincList![index!]);
                                    print(selectAll.length);
                                  }
                                  if (selectAll.isEmpty) {
                                    _colorSend = Colors.grey;
                                    _colorDelete = Colors.grey;
                                  }
                                });

                                print('No Rows Selected');
                              }
                            },
                            columns: <GridColumn>[
                              GridColumn(
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
                                  columnName: 't1',
                                  label: Container(
                                    color: COLOR_BLUE_DARK,
                                    child: Center(
                                      child: Label('Thickness1',
                                          color: COLOR_WHITE),
                                    ),
                                  ),
                                  width: 100),
                              GridColumn(
                                  columnName: 't2',
                                  label: Container(
                                    color: COLOR_BLUE_DARK,
                                    child: Center(
                                      child: Label('Thickness2',
                                          color: COLOR_WHITE),
                                    ),
                                  ),
                                  width: 100),
                              GridColumn(
                                  columnName: 't3',
                                  label: Container(
                                    color: COLOR_BLUE_DARK,
                                    child: Center(
                                      child: Label('Thickness3',
                                          color: COLOR_WHITE),
                                    ),
                                  ),
                                  width: 100),
                              GridColumn(
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
                index != null
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
                                  DataRow(cells: [
                                    DataCell(Center(child: Label("Batch"))),
                                    DataCell(
                                        Label("${zincList![index!].Batch}"))
                                  ]),
                                  DataRow(cells: [
                                    DataCell(
                                        Center(child: Label("Thickness1"))),
                                    DataCell(Label(
                                        "${zincList![index!].Thickness1}"))
                                  ]),
                                  DataRow(cells: [
                                    DataCell(
                                        Center(child: Label("Thickness2"))),
                                    DataCell(Label(
                                        "${zincList![index!].Thickness2}"))
                                  ]),
                                  DataRow(cells: [
                                    DataCell(
                                        Center(child: Label("Thickness3"))),
                                    DataCell(Label(
                                        "${zincList![index!].Thickness3}"))
                                  ]),
                                  DataRow(cells: [
                                    DataCell(
                                        Center(child: Label("Thickness4"))),
                                    DataCell(Label(
                                        "${zincList![index!].Thickness4}"))
                                  ]),
                                  DataRow(cells: [
                                    DataCell(
                                        Center(child: Label("Thickness6"))),
                                    DataCell(Label(
                                        "${zincList![index!].Thickness6}"))
                                  ]),
                                  DataRow(cells: [
                                    DataCell(
                                        Center(child: Label("Thickness7"))),
                                    DataCell(Label(
                                        "${zincList![index!].Thickness7}"))
                                  ]),
                                  DataRow(cells: [
                                    DataCell(
                                        Center(child: Label("Thickness8"))),
                                    DataCell(Label(
                                        "${zincList![index!].Thickness8}"))
                                  ]),
                                  DataRow(cells: [
                                    DataCell(
                                        Center(child: Label("Thickness9"))),
                                    DataCell(Label(
                                        "${zincList![index!].Thickness9}"))
                                  ]),
                                  DataRow(cells: [
                                    DataCell(Center(child: Label("DateTime"))),
                                    DataCell(
                                        Label("${zincList![index!].DateData}"))
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
                        if (zincSqlite != null) {
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
                        if (zincSqlite != null) {
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
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              deletedInfo();
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _sendDataServer() async {
    if (index != null) {
      for (var row in selectAll) {
        BlocProvider.of<ZincThicknessBloc>(context).add(
          ZincThickNessSendEvent(ZincThicknessOutputModel(
// OPERATORNAME:int.tryParse(_)
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
        print("Check ${row.ID}");
      }
    } else if (allRowIndex != null) {
      for (var row in zincList!) {
        BlocProvider.of<ZincThicknessBloc>(context).add(
          ZincThickNessSendEvent(ZincThicknessOutputModel(
// OPERATORNAME:int.tryParse(_)
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
      }
    }
  }

  void deletedInfo() async {
    if (index != null) {
      for (var row in selectAll) {
        await databaseHelper.deletedRowSqlite(
            tableName: 'ZINCTHICKNESS_SHEET',
            columnName: 'ID',
            columnValue: row.ID);
      }
    } else if (allRowIndex != null) {
      for (var row in zincList!) {
        await databaseHelper.deletedRowSqlite(
            tableName: 'ZINCTHICKNESS_SHEET',
            columnName: 'ID',
            columnValue: row.ID);
      }
    }
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
