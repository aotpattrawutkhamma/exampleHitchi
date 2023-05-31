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
  WindingJobStartHoldScreen({Key? key, this.onChange}) : super(key: key);
  ValueChanged<List<Map<String, dynamic>>>? onChange;

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
  List<int> _index = [];
  int? allRowIndex;
  DatabaseHelper databaseHelper = DatabaseHelper();

  late Map<String, double> columnWidths = {
    'ID': double.nan,
    'machineno': double.nan,
    'operatorName': double.nan,
    'batchno': double.nan,
    'product': double.nan,
    'filmpackno': double.nan,
    'papercodelot': double.nan,
    'PPfilmlot': double.nan,
    'foillot': double.nan,
    'batchstart': double.nan,
    'status': double.nan,
  };
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

  Future _getHold() async {
    List<Map<String, dynamic>> sql =
        await databaseHelper.queryAllRows('WINDING_SHEET');
    setState(() {
      widget.onChange
          ?.call(sql.where((element) => element['Status'] == 'P').toList());
    });
  }

  Future<List<WindingSheetModel>> _getWindingSheet() async {
    try {
      List<Map<String, dynamic>> rows =
          await databaseHelper.queryAllRows('WINDING_SHEET');
      List<WindingSheetModel> result = rows
          .where((row) => row['Status'] == 'P')
          .map((row) => WindingSheetModel.fromMap(row))
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
    return BgWhite(
      isHideAppBar: true,
      body: MultiBlocListener(
        listeners: [
          BlocListener<LineElementBloc, LineElementState>(
            listener: (context, state) async {
              if (state is PostSendWindingStartLoadingState) {
                EasyLoading.show();
              } else if (state is PostSendWindingStartLoadedState) {
                EasyLoading.dismiss();
                if (state.item.RESULT == true) {
                  await deletedInfo();
                  await _getHold();
                  await _refreshPage();
                  EasyLoading.showSuccess("Send Complete",
                      duration: Duration(seconds: 3));
                } else {
                  _errorDialog(
                      isHideCancle: false,
                      text:
                          Label("${state.item.MESSAGE ?? "Check Connection"}"),
                      onpressOk: () {
                        Navigator.pop(context);
                      });
                }
              } else {
                EasyLoading.dismiss();
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
                        child: SfDataGrid(
                          source: WindingDataSource!,
                          showCheckboxColumn: true,
                          selectionMode: SelectionMode.multiple,
                          headerGridLinesVisibility: GridLinesVisibility.both,
                          gridLinesVisibility: GridLinesVisibility.both,
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
                          columnResizeMode: ColumnResizeMode.onResizeEnd,
                          // selectionManager:SelectionManagerBase(),
                          onSelectionChanged:
                              (selectRow, deselectedRows) async {
                            if (selectRow.isNotEmpty) {
                              if (selectRow.length ==
                                      WindingDataSource!.effectiveRows.length &&
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
                                  wdsSqliteModel = datagridRow!
                                      .getCells()
                                      .map(
                                        (e) => WindingSheetModel(),
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
                              width: columnWidths['ID']!,
                              visible: false,
                              columnName: 'ID',
                              label: Container(
                                color: COLOR_BLUE_DARK,
                                child: Center(
                                    child: Label(
                                  'ID',
                                  textAlign: TextAlign.center,
                                  fontSize: 14,
                                  color: COLOR_WHITE,
                                )),
                              ),
                            ),
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
                              ),
                            ),
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
                              width: columnWidths['batchno']!,
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
                            ),
                            GridColumn(
                              width: columnWidths['product']!,
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
                            ),
                            GridColumn(
                                width: columnWidths['filmpackno']!,
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
                                width: columnWidths['papercodelot']!,
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
                                width: columnWidths['PPfilmlot']!,
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
                                width: columnWidths['foillot']!,
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
                                width: columnWidths['batchstart']!,
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
                                width: columnWidths['status']!,
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
                      )
                    : CircularProgressIndicator(),
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
                                      "${wdsList.where((element) => element.ID == _index.first).first.MACHINE_NO}"))
                                ]),
                                DataRow(cells: [
                                  DataCell(
                                      Center(child: Label("Operator Name"))),
                                  DataCell(Label(
                                      "${wdsList.where((element) => element.ID == _index.first).first.OPERATOR_NAME}"))
                                ]),
                                DataRow(cells: [
                                  DataCell(Center(child: Label("Batch No."))),
                                  DataCell(Label(
                                      "${wdsList.where((element) => element.ID == _index.first).first.BATCH_NO}"))
                                ]),
                                DataRow(cells: [
                                  DataCell(Center(child: Label("Product"))),
                                  DataCell(Label(
                                      "${wdsList.where((element) => element.ID == _index.first).first.PRODUCT}"))
                                ]),
                                DataRow(cells: [
                                  DataCell(
                                      Center(child: Label("Film Pack No"))),
                                  DataCell(Label(
                                      "${wdsList.where((element) => element.ID == _index.first).first.PACK_NO}"))
                                ]),
                                DataRow(cells: [
                                  DataCell(
                                      Center(child: Label("Paper Core Lot"))),
                                  DataCell(Label(
                                      "${wdsList.where((element) => element.ID == _index.first).first.PAPER_CORE}"))
                                ]),
                                DataRow(cells: [
                                  DataCell(Center(child: Label("PP Film Lot"))),
                                  DataCell(Label(
                                      "${wdsList.where((element) => element.ID == _index.first).first.PP_CORE}"))
                                ]),
                                DataRow(cells: [
                                  DataCell(Center(child: Label("Foil Lot"))),
                                  DataCell(Label(
                                      "${wdsList.where((element) => element.ID == _index.first).first.FOIL_CORE}"))
                                ]),
                                DataRow(cells: [
                                  DataCell(Center(child: Label("Start Date"))),
                                  DataCell(Label(
                                      "${wdsList.where((element) => element.ID == _index.first).first.BATCH_START_DATE}"))
                                ]),
                                DataRow(cells: [
                                  DataCell(Center(child: Label("Status"))),
                                  DataCell(Label(
                                      "${wdsList.where((element) => element.ID == _index.first).first.STATUS}"))
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
            onPressed: () async {
              Navigator.pop(context);
              await deletedInfo();
              await _getHold();
              await _refreshPage();
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
            tableName: 'WINDING_SHEET', columnName: 'ID', columnValue: element);
        _index.clear();
      });
    });
  }

  Future _refreshPage() async {
    await Future.delayed(Duration(seconds: 1), () {
      _getWindingSheet().then((result) {
        setState(() {
          wdsList = result;
          WindingDataSource = WindingsDataSource(process: wdsList);
        });
      });
    });
  }

  void _sendDataServer() async {
    _index.forEach((element) async {
      var row = wdsList.where((value) => value.ID == element).first;

      BlocProvider.of<LineElementBloc>(context).add(
        PostSendWindingStartEvent(
          SendWindingStartModelOutput(
            MACHINE_NO: row.MACHINE_NO,
            OPERATOR_NAME: int.tryParse(row.OPERATOR_NAME.toString()),
            BATCH_NO: row.BATCH_NO,
            PRODUCT: int.tryParse(row.PRODUCT.toString()),
            FILM_PACK_NO: int.tryParse(row.PACK_NO.toString()),
            PAPER_CODE_LOT: row.PAPER_CORE,
            PP_FILM_LOT: row.PP_CORE,
            FOIL_LOT: row.FOIL_CORE,
            START_DATE: row.BATCH_START_DATE,
          ),
        ),
      );
    });
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
              DataGridCell<int>(columnName: 'ID', value: _item.ID),
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
