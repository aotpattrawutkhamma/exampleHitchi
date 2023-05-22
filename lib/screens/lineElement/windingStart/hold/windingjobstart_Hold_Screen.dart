import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hitachi/blocs/lineElement/line_element_bloc.dart';
import 'package:hitachi/helper/background/bg_white.dart';
import 'package:hitachi/helper/button/Button.dart';
import 'package:hitachi/helper/colors/colors.dart';
import 'package:hitachi/helper/input/boxInputField.dart';
import 'package:hitachi/helper/text/label.dart';
import 'package:hitachi/models-Sqlite/windingSheetModel.dart';
import 'package:hitachi/models/SendWds/SendWdsModel_Output.dart';
import 'package:hitachi/route/router_list.dart';
import 'package:hitachi/screens/lineElement/windingStart/windingStart_Control.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:hitachi/services/databaseHelper.dart';
// import 'package:hitachi/models/SendWds/HoldWdsMoel.dart';

class WindingJobStartHoldScreen extends StatefulWidget {
  const WindingJobStartHoldScreen({Key? key}) : super(key: key);

  @override
  State<WindingJobStartHoldScreen> createState() =>
      _WindingJobStartHoldScreenState();
}

class _WindingJobStartHoldScreenState extends State<WindingJobStartHoldScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController password = TextEditingController();
  WindingsDataSource? WindingDataSource;
  // List<WindingSheetModel>? wdsSqliteModel;
  List<WindingSheetModel> wdsList = [];
  List<WindingSheetModel>? wdsSqliteModel;
  DataGridRow? datagridRow;
  bool isClick = false;
  Color _colorSend = COLOR_GREY;
  Color _colorDelete = COLOR_GREY;
  bool isHidewidget = false;
  List<WindingSheetModel> selectAll = [];
  int? index;
  int? allRowIndex;
  DatabaseHelper databaseHelper = DatabaseHelper();
  @override
  void initState() {
    super.initState();

    _getWindingSheet().then((result) {
      setState(() {
        wdsList = result;
        WindingDataSource = WindingsDataSource(process: wdsList);
      });
    });
  }

  Future<List<WindingSheetModel>> _getWindingSheet() async {
    try {
      List<Map<String, dynamic>> rows =
          await databaseHelper.queryAllRows('WINDING_SHEET');
      List<WindingSheetModel> result = rows
          .where((row) => row['Status'] == 'P')
          .map((row) => WindingSheetModel.fromMap(
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
    return BgWhite(
      isHideAppBar: true,
      textTitle: "Winding job Start(Hold)",
      body: MultiBlocListener(
        listeners: [
          BlocListener<LineElementBloc, LineElementState>(
            listener: (context, state) {
              if (state is PostSendWindingStartLoadingState) {
                EasyLoading.show();
              } else if (state is PostSendWindingStartLoadedState) {
                EasyLoading.dismiss();
                if (state.item.RESULT == true) {
                  Navigator.pop(context);
                  deletedInfo();

                  EasyLoading.showSuccess("Send complete",
                      duration: Duration(seconds: 3));
                } else {
                  EasyLoading.showError("${state.item.MESSAGE}");
                }
              } else {
                EasyLoading.dismiss();
                EasyLoading.showError("Please Check Connection Internet");
              }
            },
          )
        ],
        child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                WindingDataSource != null
                    ? Expanded(
                        child: Container(
                          child: SfDataGrid(
                            source: WindingDataSource!,
                            // columnWidthMode: ColumnWidthMode.fill,
                            showCheckboxColumn: true,
                            selectionMode: SelectionMode.multiple,
                            headerGridLinesVisibility: GridLinesVisibility.both,
                            gridLinesVisibility: GridLinesVisibility.both,
                            allowPullToRefresh: true,
                            // selectionManager:SelectionManagerBase(),
                            onSelectionChanged:
                                (selectRow, deselectedRows) async {
                              if (selectRow.isNotEmpty) {
                                if (selectRow.length ==
                                    WindingDataSource!.effectiveRows.length) {
                                  print("all");
                                  setState(() {
                                    selectRow.forEach((row) {
                                      allRowIndex = WindingDataSource!
                                          .effectiveRows
                                          .indexOf(row);

                                      _colorSend = COLOR_SUCESS;
                                      _colorDelete = COLOR_RED;
                                    });
                                  });
                                } else if (selectRow.length !=
                                    WindingDataSource!.effectiveRows.length) {
                                  setState(() {
                                    index = selectRow.isNotEmpty
                                        ? WindingDataSource!.effectiveRows
                                            .indexOf(selectRow.first)
                                        : null;
                                    datagridRow = WindingDataSource!
                                        .effectiveRows
                                        .elementAt(index!);
                                    wdsSqliteModel = datagridRow!
                                        .getCells()
                                        .map(
                                          (e) => WindingSheetModel(
                                            MACHINE_NO: e.value.toString(),
                                          ),
                                        )
                                        .toList();
                                    // selectAll.add(wdsList[index!]);
                                    if (!selectAll.contains(wdsList[index!])) {
                                      selectAll.add(wdsList[index!]);
                                      print(selectAll.length);
                                    }
                                    _colorSend = COLOR_SUCESS;
                                    _colorDelete = COLOR_RED;
                                  });
                                }
                              } else {
                                setState(() {
                                  if (selectAll.contains(wdsList[index!])) {
                                    selectAll.remove(wdsList[index!]);
                                    print("check ${selectAll.length}");
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
                                  columnName: 'batchno',
                                  label: Container(
                                    color: COLOR_BLUE_DARK,
                                    child: Center(
                                        child: Label(
                                      'Batch No.',
                                      fontSize: 14,
                                      color: COLOR_WHITE,
                                    )),
                                  ),
                                  width: 100),
                              GridColumn(
                                  columnName: 'product',
                                  label: Container(
                                    color: COLOR_BLUE_DARK,
                                    child: Center(
                                        child: Label(
                                      'Product',
                                      fontSize: 14,
                                      color: COLOR_WHITE,
                                    )),
                                  ),
                                  width: 100),
                              GridColumn(
                                  columnName: 'filmpackno',
                                  label: Container(
                                    color: COLOR_BLUE_DARK,
                                    child: Center(
                                        child: Label(
                                      'Film pack No.',
                                      fontSize: 14,
                                      color: COLOR_WHITE,
                                    )),
                                  )),
                              GridColumn(
                                  columnName: 'papercodelot',
                                  label: Container(
                                    color: COLOR_BLUE_DARK,
                                    child: Center(
                                        child: Label(
                                      'Paper core lot',
                                      textAlign: TextAlign.center,
                                      fontSize: 14,
                                      color: COLOR_WHITE,
                                    )),
                                  )),
                              GridColumn(
                                  columnName: 'PPfilmlot',
                                  label: Container(
                                    color: COLOR_BLUE_DARK,
                                    child: Center(
                                        child: Label(
                                      'PP film lot',
                                      fontSize: 14,
                                      color: COLOR_WHITE,
                                    )),
                                  )),
                              GridColumn(
                                  columnName: 'foillot',
                                  label: Container(
                                    color: COLOR_BLUE_DARK,
                                    child: Center(
                                        child: Label(
                                      'Foil Lot',
                                      fontSize: 14,
                                      color: COLOR_WHITE,
                                    )),
                                  )),
                              GridColumn(
                                  columnName: 'batchstart',
                                  label: Container(
                                    color: COLOR_BLUE_DARK,
                                    child: Center(
                                        child: Label(
                                      'StartDate',
                                      fontSize: 14,
                                      color: COLOR_WHITE,
                                    )),
                                  )),
                              GridColumn(
                                  columnName: 'status',
                                  label: Container(
                                    color: COLOR_BLUE_DARK,
                                    child: Center(
                                        child: Label(
                                      'Status',
                                      fontSize: 14,
                                      color: COLOR_WHITE,
                                    )),
                                  )),
                            ],
                          ),
                        ),
                      )
                    : CircularProgressIndicator(),
                wdsSqliteModel != null
                    ? Expanded(
                        child: Container(
                          child: ListView(
                            children: [
                              DataTable(
                                  horizontalMargin: 20,
                                  headingRowHeight: 30,
                                  dataRowHeight: 30,
                                  headingRowColor:
                                      MaterialStateColor.resolveWith(
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
                                      DataCell(
                                          Center(child: Label("Machine No."))),
                                      DataCell(Label(
                                          '${wdsList[index!].MACHINE_NO} '))
                                    ]),
                                    DataRow(cells: [
                                      DataCell(
                                          Center(child: Label("OperatorName"))),
                                      DataCell(Label(
                                          "${wdsList[index!].OPERATOR_NAME}"))
                                    ]),
                                    DataRow(cells: [
                                      DataCell(
                                          Center(child: Label("Batch No."))),
                                      DataCell(
                                          Label("${wdsList[index!].BATCH_NO}"))
                                    ]),
                                    DataRow(cells: [
                                      DataCell(Center(child: Label("Product"))),
                                      DataCell(
                                          Label("${wdsList[index!].PRODUCT}"))
                                    ]),
                                    DataRow(cells: [
                                      DataCell(
                                          Center(child: Label("Film pack No"))),
                                      DataCell(
                                          Label("${wdsList[index!].PACK_NO}"))
                                    ]),
                                    DataRow(cells: [
                                      DataCell(Center(
                                          child: Label("Paper Core Lot"))),
                                      DataCell(Label(
                                          "${wdsList[index!].PAPER_CORE}"))
                                    ]),
                                    DataRow(cells: [
                                      DataCell(
                                          Center(child: Label("PP film Lot"))),
                                      DataCell(
                                          Label("${wdsList[index!].PP_CORE}"))
                                    ]),
                                    DataRow(cells: [
                                      DataCell(
                                          Center(child: Label("Foil Lot"))),
                                      DataCell(
                                          Label("${wdsList[index!].FOIL_CORE}"))
                                    ]),
                                    DataRow(cells: [
                                      DataCell(
                                          Center(child: Label("StartDate"))),
                                      DataCell(Label(
                                          "${wdsList[index!].BATCH_START_DATE}"))
                                    ]),
                                    DataRow(cells: [
                                      DataCell(Center(child: Label("Status"))),
                                      DataCell(
                                          Label("${wdsList[index!].STATUS}"))
                                    ]),
                                  ])
                            ],
                          ),
                        ),
                      )
                    : CircularProgressIndicator(),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                        child: Button(
                      onPress: () {
                        if (wdsList.isNotEmpty) {
                          _AlertDialog();
                        } else {
                          _LoadingData();
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
                        if (wdsList != null) {
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
            )),
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
            tableName: 'WINDING_SHEET', columnName: 'ID', columnValue: row.ID);
      }
    } else if (allRowIndex != null) {
      for (var row in wdsList) {
        await databaseHelper.deletedRowSqlite(
          tableName: 'WINDING_SHEET',
          columnName: 'ID',
          columnValue: row.ID,
        );
      }
    } else {}
  }

  void _sendDataServer() async {
    if (index != null) {
      for (var row in selectAll) {
        BlocProvider.of<LineElementBloc>(context).add(
          PostSendWindingStartEvent(
            SendWindingStartModelOutput(
                MACHINE_NO: row.MACHINE_NO,
                OPERATOR_NAME: int.tryParse(row.OPERATOR_NAME.toString()),
                PRODUCT: int.tryParse(
                  row.PRODUCT.toString(),
                ),
                FILM_PACK_NO: int.tryParse(
                  row.PACK_NO.toString(),
                ),
                PAPER_CODE_LOT: row.PAPER_CORE,
                PP_FILM_LOT: row.PP_CORE,
                FOIL_LOT: row.FOIL_CORE),
          ),
        );
      }
    } else if (allRowIndex != null) {
      for (var row in wdsList) {
        BlocProvider.of<LineElementBloc>(context).add(
          PostSendWindingStartEvent(
            SendWindingStartModelOutput(
                MACHINE_NO: row.MACHINE_NO,
                OPERATOR_NAME: int.tryParse(row.OPERATOR_NAME.toString()),
                PRODUCT: int.tryParse(
                  row.PRODUCT.toString(),
                ),
                FILM_PACK_NO: int.tryParse(
                  row.PACK_NO.toString(),
                ),
                PAPER_CODE_LOT: row.PAPER_CORE,
                PP_FILM_LOT: row.PP_CORE,
                FOIL_LOT: row.FOIL_CORE),
          ),
        );
      }
    }
  }

  void _LoadingData() {
    EasyLoading.showInfo("Please Select Data", duration: Duration(seconds: 2));
  }
}

class WindingsDataSource extends DataGridSource {
  WindingsDataSource({List<WindingSheetModel>? process}) {
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
                  columnName: 'batchno', value: _item.BATCH_NO),
              DataGridCell<String>(columnName: 'product', value: _item.PRODUCT),
              DataGridCell<String>(
                  columnName: 'filmpackno', value: _item.PACK_NO),
              DataGridCell<String>(
                  columnName: 'papercodelot', value: _item.PAPER_CORE),
              DataGridCell<String>(
                  columnName: 'PPfilmlot', value: _item.PP_CORE),
              DataGridCell<String>(
                  columnName: 'foillot', value: _item.FOIL_CORE),
              DataGridCell<String>(
                  columnName: 'batchstart', value: _item.BATCH_START_DATE),
              DataGridCell<String>(columnName: 'status', value: _item.STATUS),
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
