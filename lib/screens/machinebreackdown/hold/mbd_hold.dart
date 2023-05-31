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
  MachineBreakDownHoldScreen({super.key, this.onChange});
  ValueChanged<List<Map<String, dynamic>>>? onChange;

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
  List<int> _index = [];
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

  Map<String, double> columnWidths = {
    'ID': double.nan,
    'machineno': double.nan,
    'operatorName': double.nan,
    'service': double.nan,
    'breakstart': double.nan,
    'tech1': double.nan,
    'starttech1': double.nan,
    'tech2': double.nan,
    'starttech2': double.nan,
    'stopname1': double.nan,
    'stoptech1': double.nan,
    'stopname2': double.nan,
    'stoptech2': double.nan,
    'accept': double.nan,
    'breakstop': double.nan,
  };

  Future _getHold() async {
    List<Map<String, dynamic>> sql =
        await databaseHelper.queryAllRows('BREAKDOWN_SHEET');
    setState(() {
      widget.onChange?.call(sql);
    });
  }

  Future<List<BreakDownSheetModel>> _getWindingSheet() async {
    try {
      List<Map<String, dynamic>> rows =
          await databaseHelper.queryAllRows('BREAKDOWN_SHEET');
      List<BreakDownSheetModel> result = rows
          .map((row) => BreakDownSheetModel.fromMap(
              row.map((key, value) => MapEntry(key, value))))
          .toList();

      return result;
    } catch (e) {
      print(e);
      return [];
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

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<MachineBreakDownBloc, MachineBreakDownState>(
          listener: (context, state) async {
            if (state is PostMachineBreakdownLoadingState) {
              EasyLoading.show();
            }
            if (state is PostMachineBreakdownLoadedState) {
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
                    text: Label("${state.item.MESSAGE ?? "Check Connection"}"),
                    onpressOk: () {
                      Navigator.pop(context);
                    });
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
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              breakdownDataSource != null
                  ? Expanded(
                      child: Container(
                        child: SfDataGrid(
                          source: breakdownDataSource!,
                          showCheckboxColumn: true,
                          selectionMode: SelectionMode.multiple,
                          headerGridLinesVisibility: GridLinesVisibility.both,
                          gridLinesVisibility: GridLinesVisibility.both,
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
                                      breakdownDataSource!
                                          .effectiveRows.length &&
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
                                  bdsSqliteModel = datagridRow!
                                      .getCells()
                                      .map(
                                        (e) => BreakDownSheetModel(),
                                      )
                                      .toList();

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
                                    fontSize: 14,
                                    color: COLOR_WHITE,
                                  )),
                                  // color: COLOR_BLUE_DARK,
                                )),
                            GridColumn(
                                width: columnWidths['machineno']!,
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
                              width: columnWidths['operatorName']!,
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
                              width: columnWidths['service']!,
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
                            ),
                            GridColumn(
                              width: columnWidths['breakstart']!,
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
                            ),
                            GridColumn(
                                width: columnWidths['tech1']!,
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
                                width: columnWidths['starttech1']!,
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
                                width: columnWidths['tech2']!,
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
                                width: columnWidths['starttech2']!,
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
                                width: columnWidths['stopname1']!,
                                columnName: 'stopname1',
                                label: Container(
                                  color: COLOR_BLUE_DARK,
                                  child: Center(
                                      child: Label(
                                    'Stop Tech1',
                                    fontSize: 14,
                                    color: COLOR_WHITE,
                                  )),
                                )),
                            GridColumn(
                                width: columnWidths['stoptech1']!,
                                columnName: 'stoptech1',
                                label: Container(
                                  color: COLOR_BLUE_DARK,
                                  child: Center(
                                      child: Label(
                                    'Stop Date \nTech1',
                                    fontSize: 14,
                                    color: COLOR_WHITE,
                                  )),
                                )),
                            GridColumn(
                                width: columnWidths['stopname2']!,
                                columnName: 'stopname2',
                                label: Container(
                                  color: COLOR_BLUE_DARK,
                                  child: Center(
                                      child: Label(
                                    'Stop Tech2',
                                    fontSize: 14,
                                    color: COLOR_WHITE,
                                  )),
                                )),
                            GridColumn(
                                width: columnWidths['stoptech2']!,
                                columnName: 'stoptech2',
                                label: Container(
                                  color: COLOR_BLUE_DARK,
                                  child: Center(
                                      child: Label(
                                    'Stop Date \nTech2',
                                    fontSize: 14,
                                    color: COLOR_WHITE,
                                  )),
                                )),
                            GridColumn(
                                width: columnWidths['accept']!,
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
                                width: columnWidths['breakstop']!,
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
              _index.isNotEmpty
                  ? Expanded(
                      child: ListView.builder(
                        itemCount: _index.length,
                        itemBuilder: ((context, index) {
                          return DataTable(
                            horizontalMargin: 20,
                            headingRowHeight: 30,
                            dataRowHeight: 50,
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
                                DataCell(Center(child: Label("Machine No"))),
                                DataCell(Label(
                                    "${bdsList.where((element) => element.ID == _index.first).first.MACHINE_NO}"))
                              ]),
                              DataRow(cells: [
                                DataCell(Center(child: Label("Operator Name"))),
                                DataCell(Label(
                                    "${bdsList.where((element) => element.ID == _index.first).first.OPERATOR_NAME}"))
                              ]),
                              DataRow(cells: [
                                DataCell(Center(child: Label("Service"))),
                                DataCell(Label(
                                    "${bdsList.where((element) => element.ID == _index.first).first.SERVICE_NO}"))
                              ]),
                              DataRow(cells: [
                                DataCell(Center(child: Label("BreakStart"))),
                                DataCell(Label(
                                    "${bdsList.where((element) => element.ID == _index.first).first.BREAK_START_DATE}"))
                              ]),
                              DataRow(cells: [
                                DataCell(Center(child: Label("Tech 1"))),
                                DataCell(Label(
                                    "${bdsList.where((element) => element.ID == _index.first).first.TECH_1}"))
                              ]),
                              DataRow(cells: [
                                DataCell(Center(child: Label("Start Tech 1"))),
                                DataCell(Label(
                                    "${bdsList.where((element) => element.ID == _index.first).first.START_TECH_DATE_1}"))
                              ]),
                              DataRow(cells: [
                                DataCell(Center(child: Label("Tech 2"))),
                                DataCell(Label(
                                    "${bdsList.where((element) => element.ID == _index.first).first.TECH_2}"))
                              ]),
                              DataRow(cells: [
                                DataCell(Center(child: Label("Start Tech 2"))),
                                DataCell(Label(
                                    "${bdsList.where((element) => element.ID == _index.first).first.START_TECH_DATE_2}"))
                              ]),
                              DataRow(cells: [
                                DataCell(Center(child: Label("Stop Tech 1"))),
                                DataCell(Label(
                                    "${bdsList.where((element) => element.ID == _index.first).first.STOPTECH_1}"))
                              ]),
                              DataRow(cells: [
                                DataCell(
                                    Center(child: Label("Stop Date Tech 1"))),
                                DataCell(Label(
                                    "${bdsList.where((element) => element.ID == _index.first).first.STOP_DATE_TECH_1}"))
                              ]),
                              DataRow(cells: [
                                DataCell(Center(child: Label("Stop Tech 2"))),
                                DataCell(Label(
                                    "${bdsList.where((element) => element.ID == _index.first).first.STOPTECH_2}"))
                              ]),
                              DataRow(cells: [
                                DataCell(
                                    Center(child: Label("Stop Date Tech 2"))),
                                DataCell(Label(
                                    "${bdsList.where((element) => element.ID == _index.first).first.STOP_DATE_TECH_2}"))
                              ]),
                              DataRow(cells: [
                                DataCell(Center(child: Label("Accept"))),
                                DataCell(Label(
                                    "${bdsList.where((element) => element.ID == _index.first).first.OPERATOR_ACCEPT}"))
                              ]),
                              DataRow(cells: [
                                DataCell(Center(child: Label("Break Stop"))),
                                DataCell(Label(
                                    "${bdsList.where((element) => element.ID == _index.first).first.BREAK_STOP_DATE}"))
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
                      if (_index.isNotEmpty) {
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
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await deletedInfo();
              await _refresh();
              await _getHold();

              EasyLoading.showSuccess("Delete Success");
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future deletedInfo() async {
    setState(() {
      _index.forEach((element) async {
        await databaseHelper.deletedRowSqlite(
            tableName: 'BREAKDOWN_SHEET',
            columnName: 'ID',
            columnValue: element);
        _index.clear();
      });
    });
  }

  Future _refresh() async {
    await Future.delayed(Duration(seconds: 1), () {
      _getWindingSheet().then((result) {
        setState(() {
          bdsList = result;
          breakdownDataSource = BreakDownDataSource(process: bdsList);
        });
      });
    });
  }

  void _sendDataServer() async {
    _index.forEach((element) async {
      var row = bdsList.where((value) => value.ID == element).first;

      if (row.OPERATOR_ACCEPT!.isEmpty) {
        EasyLoading.showError("Please Input Operator Accept",
            duration: Duration(seconds: 3));
      } else if (row.STOPTECH_1!.isEmpty) {
        EasyLoading.showError("Please Input Technical Stop",
            duration: Duration(seconds: 3));
      } else {
        BlocProvider.of<MachineBreakDownBloc>(context).add(
          MachineBreakDownSendEvent(
            MachineBreakDownOutputModel(
              MACHINE_NO: row.MACHINE_NO,
              OPERATOR_NAME: row.OPERATOR_NAME,
              SERVICE: row.SERVICE_NO,
              BREAK_START_DATE: row.BREAK_START_DATE,
              MT1: row.TECH_1,
              MT1_START_DATE: row.START_TECH_DATE_1,
              MT2: row.TECH_2,
              MT2_START_DATE: row.START_TECH_DATE_2,
              MT1_STOP: row.STOP_DATE_TECH_1,
              MT2_STOP: row.STOP_DATE_TECH_2,
              ACCEPT: row.OPERATOR_ACCEPT,
              BREAK_STOP_DATE: row.BREAK_STOP_DATE,
            ),
          ),
        );
      }
    });
  }

  void _selectData() {
    EasyLoading.showInfo("Please Select Data", duration: Duration(seconds: 2));
  }
}

class BreakDownDataSource extends DataGridSource {
  BreakDownDataSource({List<BreakDownSheetModel>? process}) {
    if (process != null) {
      for (var _item in process) {
        print(_item.STOPTECH_1);
        print(_item.STOPTECH_2);
        _employees.add(
          DataGridRow(
            cells: [
              DataGridCell<int>(columnName: 'ID', value: _item.ID),
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
                  columnName: 'stopname1', value: _item.STOPTECH_1),
              DataGridCell<String>(
                  columnName: 'stoptech1', value: _item.STOP_DATE_TECH_1),
              DataGridCell<String>(
                  columnName: 'stopname2', value: _item.STOPTECH_2),
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
