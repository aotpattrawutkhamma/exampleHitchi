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
import 'package:hitachi/models/SendWdFinish/sendWdsFinish_output_Model.dart';
import 'package:hitachi/models/SendWds/SendWdsModel_Output.dart';
import 'package:hitachi/route/router_list.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:hitachi/services/databaseHelper.dart';
// import 'package:hitachi/models/SendWds/HoldWdsMoel.dart';

class WindingJobFinishHoldScreen extends StatefulWidget {
  WindingJobFinishHoldScreen({Key? key, this.onChange}) : super(key: key);
  ValueChanged<List<Map<String, dynamic>>>? onChange;
  @override
  State<WindingJobFinishHoldScreen> createState() =>
      _WindingJobFinishHoldScreenState();
}

class _WindingJobFinishHoldScreenState
    extends State<WindingJobFinishHoldScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController password = TextEditingController();
  WindingsDataSource? WindingDataSource;
  List<WindingSheetModel>? wdsSqliteModel;
  List<WindingSheetModel> wdsList = [];
  List<WindingSheetModel> selectAll = [];
  List<int> _index = [];
  int? allRowIndex;
  DataGridRow? datagridRow;
  bool isClick = false;
  Color _colorSend = COLOR_GREY;
  Color _colorDelete = COLOR_GREY;

  Map<String, double> columnWidths = {
    'batch': double.nan,
    'startEnd': double.nan,
    'element': double.nan
  };

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

  Future _getHold() async {
    List<Map<String, dynamic>> sql =
        await databaseHelper.queryAllRows('WINDING_SHEET');
    setState(() {
      widget.onChange?.call(
          sql.where((element) => element['checkComplete'] == 'E').toList());
    });
  }

  Future<List<WindingSheetModel>> _getWindingSheet() async {
    try {
      List<Map<String, dynamic>> rows =
          await databaseHelper.queryAllRows('WINDING_SHEET');
      List<WindingSheetModel> result = rows
          .where((row) => row['checkComplete'] == 'E')
          .map((row) => WindingSheetModel.fromMap(row))
          .toList();
      return result;
    } on Exception {
      throw Exception();
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
              if (state is PostSendWindingFinishLoadingState) {
                EasyLoading.show();
              }
              if (state is PostSendWindingFinishLoadedState) {
                EasyLoading.dismiss();
                if (state.item.RESULT == true) {
                  await deletedInfo();
                  await _getHold();
                  await _refreshPage();
                  _errorDialog(
                      text: Label("Success"),
                      onpressOk: () => Navigator.pop(context));
                } else {
                  _errorDialog(
                      isHideCancle: false,
                      text:
                          Label("${state.item.MESSAGE ?? "Check Connection"}"),
                      onpressOk: () => Navigator.pop(context));
                }
              }
              if (state is PostSendWindingFinishErrorState) {
                EasyLoading.showError("Connection Timeout");
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
                          source: WindingDataSource!,
                          showCheckboxColumn: true,
                          selectionMode: SelectionMode.multiple,
                          headerGridLinesVisibility: GridLinesVisibility.both,
                          gridLinesVisibility: GridLinesVisibility.both,
                          allowPullToRefresh: true,
                          onSelectionChanged: (selectRow, deselectedRows) {
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
                              width: columnWidths['batch']!,
                              columnName: 'batch',
                              label: Container(
                                color: COLOR_BLUE_DARK,
                                child: Container(
                                  child: Center(
                                      child: Label(
                                    'Batch No.',
                                    textAlign: TextAlign.center,
                                    fontSize: 14,
                                    color: COLOR_WHITE,
                                  )),
                                ),
                              ),
                            ),
                            GridColumn(
                              width: columnWidths['startEnd']!,
                              columnName: 'startEnd',
                              label: Container(
                                color: COLOR_BLUE_DARK,
                                child: Center(
                                    child: Label(
                                  'Date End',
                                  fontSize: 14,
                                  color: COLOR_WHITE,
                                )),
                              ),
                            ),
                            GridColumn(
                              width: columnWidths['element']!,
                              columnName: 'element',
                              label: Container(
                                color: COLOR_BLUE_DARK,
                                child: Center(
                                    child: Label(
                                  'Element Qty',
                                  fontSize: 14,
                                  color: COLOR_WHITE,
                                )),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Container(
                      child: Center(
                        child: Label(
                          "NO DATA",
                          fontSize: 30,
                        ),
                      ),
                    ),
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
                                DataCell(Center(child: Label("Batch No."))),
                                DataCell(Label(
                                    "${wdsList.where((element) => element.ID == _index.first).first.BATCH_NO}"))
                              ]),
                              DataRow(cells: [
                                DataCell(Center(child: Label("Finish Date"))),
                                DataCell(Label(
                                    "${wdsList.where((element) => element.ID == _index.first).first.BATCH_END_DATE}"))
                              ]),
                              DataRow(cells: [
                                DataCell(Center(child: Label("Element"))),
                                DataCell(Label(
                                    "${wdsList.where((element) => element.ID == _index.first).first.ELEMENT}"))
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

  Future _refreshPage() async {
    _getWindingSheet().then((result) {
      setState(() {
        wdsList = result;
        WindingDataSource = WindingsDataSource(process: wdsList);
      });
    });
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

  void _sendDataServer() async {
    _index.forEach((element) async {
      var row = wdsList.where((value) => value.ID == element).first;
      BlocProvider.of<LineElementBloc>(context).add(
        PostSendWindingFinishEvent(
          SendWdsFinishOutputModel(
            OPERATOR_NAME: int.tryParse(row.OPERATOR_NAME.toString()),
            BATCH_NO: row.BATCH_NO.toString(),
            ELEMNT_QTY: int.tryParse(row.ELEMENT.toString()),
            FINISH_DATE: DateTime.now().toString(),
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
    try {
      if (process != null) {
        for (var _item in process) {
          if (_item.CHECK_COMPLETE == "E") {
            _employees.add(
              DataGridRow(
                cells: [
                  DataGridCell<int>(
                      columnName: 'ID',
                      value: int.tryParse(_item.ID.toString())),
                  DataGridCell<String>(
                      columnName: 'batch', value: _item.BATCH_NO),
                  DataGridCell<String>(
                      columnName: 'startEnd', value: _item.START_END),
                  DataGridCell<String>(
                      columnName: 'element', value: _item.ELEMENT),
                ],
              ),
            );
          }
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
