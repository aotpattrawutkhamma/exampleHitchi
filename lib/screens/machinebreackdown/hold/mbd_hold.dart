import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hitachi/blocs/lineElement/line_element_bloc.dart';
import 'package:hitachi/blocs/machineBreakDown/machine_break_down_bloc.dart';
import 'package:hitachi/helper/background/bg_white.dart';
import 'package:hitachi/helper/button/Button.dart';
import 'package:hitachi/helper/colors/colors.dart';
import 'package:hitachi/helper/text/label.dart';
import 'package:hitachi/models-Sqlite/breakdownSheetModel.dart';
import 'package:hitachi/services/databaseHelper.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../models/machineBreakdown/machinebreakdownOutputMode.dart';

class MachineBreakDownHoldScreen extends StatefulWidget {
  const MachineBreakDownHoldScreen({super.key});

  @override
  State<MachineBreakDownHoldScreen> createState() =>
      _MachineBreakDownHoldScreenState();
}

class _MachineBreakDownHoldScreenState
    extends State<MachineBreakDownHoldScreen> {
  final TextEditingController password = TextEditingController();
  BreakDownDataSource? breakdownDataSource;
  List<BreakDownSheetModel>? bdsSqliteModel;
  List<BreakDownSheetModel> bdsList = [];
  List<BreakDownSheetModel> selectAll = [];
  int? index;
  int? allRowIndex;
  DataGridRow? datagridRow;
  bool isClick = false;
  Color _colorSend = COLOR_GREY;
  Color _colorDelete = COLOR_GREY;
  bool isHidewidget = false;

  DatabaseHelper databaseHelper = DatabaseHelper();
  @override
  void initState() {
    super.initState();

    _getWindingSheet().then((result) {
      setState(() {
        bdsList = result;
        breakdownDataSource = BreakDownDataSource(process: bdsList);
      });
    });
  }

  Future<List<BreakDownSheetModel>> _getWindingSheet() async {
    try {
      List<Map<String, dynamic>> rows =
          await databaseHelper.queryAllRows('BREAKDOWN_SHEET');
      List<BreakDownSheetModel> result = rows
          .map((row) => BreakDownSheetModel.fromMap(
              row.map((key, value) => MapEntry(key, value.toString()))))
          .toList();

      return result;
    } catch (e) {
      print(e);
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<MachineBreakDownBloc, MachineBreakDownState>(
          listener: (context, state) {
            if (state is PostMachineBreakdownLoadingState) {
              EasyLoading.show();
            }
            if (state is PostMachineBreakdownLoadedState) {
              if (state.item.RESULT == true) {
                deletedInfo();
                Navigator.pop(context);
                EasyLoading.showSuccess("Send complete",
                    duration: Duration(seconds: 3));
              } else {
                EasyLoading.showError("Please Check Data");
              }
            }
            if (state is PostMachineBreakdownErrorState) {
              EasyLoading.showError("Can not send");
            }
          },
        )
      ],
      child: BgWhite(
        isHideAppBar: true,
        textTitle: "Winding job Start(Hold)",
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              breakdownDataSource != null
                  ? Expanded(
                      child: Container(
                        child: SfDataGrid(
                          source: breakdownDataSource!,
                          // columnWidthMode: ColumnWidthMode.fill,
                          showCheckboxColumn: true,
                          selectionMode: SelectionMode.multiple,
                          headerGridLinesVisibility: GridLinesVisibility.both,
                          gridLinesVisibility: GridLinesVisibility.both,
                          onSelectionChanged:
                              (selectRow, deselectedRows) async {
                            if (selectRow.isNotEmpty) {
                              if (selectRow.length ==
                                  breakdownDataSource!.effectiveRows.length) {
                                print("all");
                                setState(() {
                                  selectRow.forEach((row) {
                                    allRowIndex = breakdownDataSource!
                                        .effectiveRows
                                        .indexOf(row);

                                    _colorSend = COLOR_SUCESS;
                                    _colorDelete = COLOR_RED;
                                  });
                                });
                              } else if (selectRow.length !=
                                  breakdownDataSource!.effectiveRows.length) {
                                setState(() {
                                  index = selectRow.isNotEmpty
                                      ? breakdownDataSource!.effectiveRows
                                          .indexOf(selectRow.first)
                                      : null;

                                  datagridRow = breakdownDataSource!
                                      .effectiveRows
                                      .elementAt(index!);
                                  bdsSqliteModel = datagridRow!
                                      .getCells()
                                      .map(
                                        (e) => BreakDownSheetModel(
                                          MACHINE_NO: e.value.toString(),
                                        ),
                                      )
                                      .toList();
                                  if (!selectAll.contains(bdsList[index!])) {
                                    selectAll.add(bdsList[index!]);
                                    print(selectAll.length);
                                  }
                                  _colorSend = COLOR_SUCESS;
                                  _colorDelete = COLOR_RED;

                                  // selectAll.add(bdsList[index!]);
                                });
                              }
                            } else {
                              setState(() {
                                if (selectAll.contains(bdsList[index!])) {
                                  selectAll.remove(bdsList[index!]);
                                  print("check ${selectAll.length}");
                                  if (selectAll.isEmpty) {
                                    _colorSend = Colors.grey;
                                    _colorDelete = Colors.grey;
                                  }
                                }
                                // if (selectRow.isEmpty) {
                                //   selectAll.clear();
                                //   print(selectAll.length);
                                //   print("selectAll.length");
                                // } else {
                                //   selectAll.remove(bdsList[index!]);
                                //   print(selectAll.length);
                                // }
                              });
                            }
                          },
                          // onCellTap: (details) async {
                          //   if (details.rowColumnIndex.rowIndex != 0) {
                          //     setState(() {
                          //       selectedRowIndex =
                          //           details.rowColumnIndex.rowIndex - 1;
                          //       datagridRow = BreakdownDataSource!.effectiveRows
                          //           .elementAt(selectedRowIndex!);
                          //       bdsSqliteModel = datagridRow!
                          //           .getCells()
                          //           .map(
                          //             (e) => BreakDownSheetModel(),
                          //           )
                          //           .toList();
                          //       _colorSend = COLOR_SUCESS;
                          //       _colorDelete = COLOR_RED;
                          //     });
                          //   }
                          // },
                          columns: <GridColumn>[
                            GridColumn(
                                columnName: 'machineno',
                                label: Container(
                                  color: COLOR_BLUE_DARK,
                                  child: Center(
                                      child: Label(
                                    'Machine No.',
                                    fontSize: 14,
                                    color: COLOR_WHITE,
                                  )),
                                  // color: COLOR_BLUE_DARK,
                                )),
                            GridColumn(
                              columnName: 'operatorName',
                              label: Container(
                                color: COLOR_BLUE_DARK,
                                child: Center(
                                    child: Label(
                                  'Operator Name',
                                  textAlign: TextAlign.center,
                                  fontSize: 14,
                                  color: COLOR_WHITE,
                                )),
                              ),
                            ),
                            GridColumn(
                                columnName: 'service',
                                label: Container(
                                  color: COLOR_BLUE_DARK,
                                  child: Center(
                                      child: Label(
                                    'Service',
                                    fontSize: 14,
                                    color: COLOR_WHITE,
                                  )),
                                ),
                                width: 100),
                            GridColumn(
                                columnName: 'breakstart',
                                label: Container(
                                  color: COLOR_BLUE_DARK,
                                  child: Center(
                                      child: Label(
                                    'BreakStart',
                                    fontSize: 14,
                                    color: COLOR_WHITE,
                                  )),
                                ),
                                width: 100),
                            GridColumn(
                                columnName: 'tech1',
                                label: Container(
                                  color: COLOR_BLUE_DARK,
                                  child: Center(
                                      child: Label(
                                    'Tech1',
                                    fontSize: 14,
                                    color: COLOR_WHITE,
                                  )),
                                )),
                            GridColumn(
                                columnName: 'starttech1',
                                label: Container(
                                  color: COLOR_BLUE_DARK,
                                  child: Center(
                                      child: Label(
                                    'StartTech1',
                                    textAlign: TextAlign.center,
                                    fontSize: 14,
                                    color: COLOR_WHITE,
                                  )),
                                )),
                            GridColumn(
                                columnName: 'tech2',
                                label: Container(
                                  color: COLOR_BLUE_DARK,
                                  child: Center(
                                      child: Label(
                                    'Tech2',
                                    fontSize: 14,
                                    color: COLOR_WHITE,
                                  )),
                                )),
                            GridColumn(
                                columnName: 'starttech2',
                                label: Container(
                                  color: COLOR_BLUE_DARK,
                                  child: Center(
                                      child: Label(
                                    'StartTech2',
                                    fontSize: 14,
                                    color: COLOR_WHITE,
                                  )),
                                )),
                            GridColumn(
                                columnName: 'stoptech1',
                                label: Container(
                                  color: COLOR_BLUE_DARK,
                                  child: Center(
                                      child: Label(
                                    'StopTech1',
                                    fontSize: 14,
                                    color: COLOR_WHITE,
                                  )),
                                )),
                            GridColumn(
                                columnName: 'stoptech2',
                                label: Container(
                                  color: COLOR_BLUE_DARK,
                                  child: Center(
                                      child: Label(
                                    'StopTech2',
                                    fontSize: 14,
                                    color: COLOR_WHITE,
                                  )),
                                )),
                            GridColumn(
                                columnName: 'accept',
                                label: Container(
                                  color: COLOR_BLUE_DARK,
                                  child: Center(
                                      child: Label(
                                    'Accept',
                                    fontSize: 14,
                                    color: COLOR_WHITE,
                                  )),
                                )),
                            GridColumn(
                                columnName: 'breakstop',
                                label: Container(
                                  color: COLOR_BLUE_DARK,
                                  child: Center(
                                      child: Label(
                                    'BreakStop',
                                    fontSize: 14,
                                    color: COLOR_WHITE,
                                  )),
                                )),
                          ],
                        ),
                      ),
                    )
                  : CircularProgressIndicator(),
              bdsSqliteModel != null
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
                                  DataCell(Center(child: Label("Machine No."))),
                                  DataCell(
                                      Label("${bdsList[index!].MACHINE_NO}"))
                                ]),
                                DataRow(cells: [
                                  DataCell(
                                      Center(child: Label("OperatorName"))),
                                  DataCell(
                                      Label("${bdsList[index!].OPERATOR_NAME}"))
                                ]),
                                DataRow(cells: [
                                  DataCell(Center(child: Label("SERVICE"))),
                                  DataCell(
                                      Label("${bdsList[index!].SERVICE_NO}"))
                                ]),
                                DataRow(cells: [
                                  DataCell(
                                      Center(child: Label("BreakStartDate"))),
                                  DataCell(Label(
                                      "${bdsList[index!].BREAK_START_DATE}"))
                                ]),
                                DataRow(cells: [
                                  DataCell(Center(child: Label("Tech1"))),
                                  DataCell(Label("${bdsList[index!].TECH_1}"))
                                ]),
                                DataRow(cells: [
                                  DataCell(Center(child: Label("StartTech1"))),
                                  DataCell(Label(
                                      "${bdsList[index!].START_TECH_DATE_1}"))
                                ]),
                                DataRow(cells: [
                                  DataCell(Center(child: Label("Tech2"))),
                                  DataCell(Label("${bdsList[index!].TECH_2}"))
                                ]),
                                DataRow(cells: [
                                  DataCell(Center(child: Label("StartTech2"))),
                                  DataCell(Label(
                                      "${bdsList[index!].START_TECH_DATE_2}"))
                                ]),
                                DataRow(cells: [
                                  DataCell(Center(child: Label("StopTech1"))),
                                  DataCell(Label(
                                      "${bdsList[index!].STOP_DATE_TECH_1}"))
                                ]),
                                DataRow(cells: [
                                  DataCell(Center(child: Label("StopTech2"))),
                                  DataCell(Label(
                                      "${bdsList[index!].STOP_DATE_TECH_2}"))
                                ]),
                                DataRow(cells: [
                                  DataCell(Center(child: Label("Accept"))),
                                  DataCell(Label(
                                      "${bdsList[index!].OPERATOR_ACCEPT}"))
                                ]),
                                DataRow(cells: [
                                  DataCell(Center(child: Label("BreakStop"))),
                                  DataCell(Label(
                                      "${bdsList[index!].BREAK_STOP_DATE}"))
                                ]),
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
                      if (bdsSqliteModel != null) {
                        _AlertDialog();
                      } else {
                        _selectData();
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
                      if (bdsSqliteModel != null) {
                        _sendDataServer();
                      } else {
                        EasyLoading.showInfo("Please Select Data");
                      }
                    },
                  )),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
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

  void deletedInfo() async {
    if (index != null) {
      for (var row in selectAll) {
        await databaseHelper.deletedRowSqlite(
            tableName: 'BREAKDOWN_SHEET',
            columnName: 'ID',
            columnValue: row.ID);
      }
    } else if (allRowIndex != null) {
      for (var row in bdsList) {
        await databaseHelper.deletedRowSqlite(
            tableName: 'BREAKDOWN_SHEET',
            columnName: 'ID',
            columnValue: row.ID);
      }
    }
  }

  void _sendDataServer() async {
    if (index != null) {
      for (var row in selectAll) {
        BlocProvider.of<MachineBreakDownBloc>(context).add(
          MachineBreakDownSendEvent(
            MachineBreakDownOutputModel(
              MACHINE_NO: row.MACHINE_NO,
              OPERATOR_NAME: row.OPERATOR_NAME,
              SERVICE: row.SERVICE_NO,
              BREAK_START_DATE: row.BREAK_START_DATE,
              TECH1: row.TECH_1,
              START_DATE_TECH_1: row.START_TECH_DATE_1,
              TECH2: row.TECH_2,
              START_DATE_TECH_2: row.START_TECH_DATE_2,
              STOP_TECH_DATE_1: row.STOP_DATE_TECH_1,
              STOP_TECH_DATE_2: row.STOP_DATE_TECH_2,
              ACCEPT: row.OPERATOR_ACCEPT,
              BREAK_STOP_DATE: row.BREAK_STOP_DATE,
            ),
          ),
        );
      }
    } else if (allRowIndex != null) {
      for (var row in bdsList) {
        BlocProvider.of<MachineBreakDownBloc>(context).add(
          MachineBreakDownSendEvent(
            MachineBreakDownOutputModel(
              MACHINE_NO: row.MACHINE_NO,
              OPERATOR_NAME: row.OPERATOR_NAME,
              SERVICE: row.SERVICE_NO,
              BREAK_START_DATE: row.BREAK_START_DATE,
              TECH1: row.TECH_1,
              START_DATE_TECH_1: row.START_TECH_DATE_1,
              TECH2: row.TECH_2,
              START_DATE_TECH_2: row.START_TECH_DATE_2,
              STOP_TECH_DATE_1: row.STOP_DATE_TECH_1,
              STOP_TECH_DATE_2: row.STOP_DATE_TECH_2,
              ACCEPT: row.OPERATOR_ACCEPT,
              BREAK_STOP_DATE: row.BREAK_STOP_DATE,
            ),
          ),
        );
      }
    }
  }

  void _selectData() {
    EasyLoading.showInfo("Please Select Data", duration: Duration(seconds: 2));
  }
}

class BreakDownDataSource extends DataGridSource {
  BreakDownDataSource({List<BreakDownSheetModel>? process}) {
    if (process != null) {
      for (var _item in process) {
        _employees.add(
          DataGridRow(
            cells: [
              DataGridCell<String>(
                  columnName: 'machineno', value: _item.MACHINE_NO),
              DataGridCell<String>(
                  columnName: 'operatorName', value: _item.OPERATOR_NAME),
              DataGridCell<String>(
                  columnName: 'service', value: _item.SERVICE_NO),
              DataGridCell<String>(
                  columnName: 'breakstart', value: _item.BREAK_START_DATE),
              DataGridCell<String>(columnName: 'tech1', value: _item.TECH_1),
              DataGridCell<String>(
                  columnName: 'starttech1', value: _item.START_TECH_DATE_1),
              DataGridCell<String>(columnName: 'tech2', value: _item.TECH_2),
              DataGridCell<String>(
                  columnName: 'starttech2', value: _item.START_TECH_DATE_2),
              DataGridCell<String>(
                  columnName: 'stoptech1', value: _item.STOP_DATE_TECH_1),
              DataGridCell<String>(
                  columnName: 'stoptech2', value: _item.STOP_DATE_TECH_2),
              DataGridCell<String>(
                  columnName: 'accept', value: _item.OPERATOR_ACCEPT),
              DataGridCell<String>(
                  columnName: 'breakstop', value: _item.BREAK_STOP_DATE),
            ],
          ),
        );
      }
    } else {
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
