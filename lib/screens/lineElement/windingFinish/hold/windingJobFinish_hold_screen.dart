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
  const WindingJobFinishHoldScreen({Key? key}) : super(key: key);

  @override
  State<WindingJobFinishHoldScreen> createState() =>
      _WindingJobFinishHoldScreenState();
}

class _WindingJobFinishHoldScreenState
    extends State<WindingJobFinishHoldScreen> {
  final _formKey = GlobalKey<FormState>();
  // final TextEditingController machineNo = TextEditingController();
  // final TextEditingController operatorName = TextEditingController();
  // final TextEditingController batchNo = TextEditingController();
  // final TextEditingController product = TextEditingController();
  // final TextEditingController filmPackNo = TextEditingController();
  // final TextEditingController paperCodeLot = TextEditingController();
  // final TextEditingController ppFilmLot = TextEditingController();
  // final TextEditingController foilLot = TextEditingController();
  // final TextEditingController batchstartdate = TextEditingController();
  // final TextEditingController batchenddate = TextEditingController();
  // final TextEditingController element = TextEditingController();
  // final TextEditingController status = TextEditingController();
  final TextEditingController password = TextEditingController();
  WindingsDataSource? WindingDataSource;
  List<WindingSheetModel>? wdsSqliteModel;
  List<WindingSheetModel> wdsList = [];
  List<WindingSheetModel> selectAll = [];
  int? index;
  int? allRowIndex;
  DataGridRow? datagridRow;
  bool isClick = false;
  Color _colorSend = COLOR_GREY;
  Color _colorDelete = COLOR_GREY;

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
          .where((row) => row['Element'] != null)
          .map((row) => WindingSheetModel.fromMap(
              row.map((key, value) => MapEntry(key, value.toString()))))
          .toList();

      return result;
    } on Exception {
      throw Exception();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BgWhite(
      isHideAppBar: true,
      textTitle: "Winding job Finish(Hold)",
      body: MultiBlocListener(
        listeners: [
          BlocListener<LineElementBloc, LineElementState>(
            listener: (context, state) {
              if (state is PostSendWindingFinishLoadingState) {
                EasyLoading.show();
              }
              if (state is PostSendWindingFinishLoadedState) {
                if (state.item.RESULT == true) {
                  Navigator.pop(context);
                  deletedInfo();
                  EasyLoading.showSuccess("Send complete",
                      duration: Duration(seconds: 3));
                } else {
                  EasyLoading.showError("Failed To Send");
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
                          source: WindingDataSource!,
                          showCheckboxColumn: true,
                          selectionMode: SelectionMode.multiple,
                          headerGridLinesVisibility: GridLinesVisibility.both,
                          gridLinesVisibility: GridLinesVisibility.both,
                          allowPullToRefresh: true,
                          onSelectionChanged: (selectRow, deselectedRows) {
                            if (selectRow.isNotEmpty) {
                              print(selectRow.length);
                              print(WindingDataSource!.effectiveRows.length);
                              if (selectRow.length ==
                                  WindingDataSource!.effectiveRows.length) {
                                print("object");
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
                                  datagridRow = WindingDataSource!.effectiveRows
                                      .elementAt(index!);
                                  wdsSqliteModel = datagridRow!
                                      .getCells()
                                      .map(
                                        (e) => WindingSheetModel(
                                          MACHINE_NO: e.value.toString(),
                                        ),
                                      )
                                      .toList();
                                  if (!selectAll.contains(wdsList[index!])) {
                                    selectAll.add(wdsList[index!]);
                                    print(selectAll.length);
                                  }
                                  _colorDelete = COLOR_RED;
                                  _colorSend = COLOR_SUCESS;
                                  print(wdsList[index!].ID);
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
                              columnName: 'batch',
                              label: Container(
                                color: COLOR_BLUE_DARK,
                                child: Center(
                                    child: Label(
                                  'Batch No.',
                                  textAlign: TextAlign.center,
                                  fontSize: 14,
                                  color: COLOR_WHITE,
                                )),
                              ),
                            ),
                            GridColumn(
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
                                width: 100),
                            GridColumn(
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
                                width: 100),
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
              wdsSqliteModel != null
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
                                  DataCell(Center(child: Label("Batch No."))),
                                  DataCell(
                                      Label(wdsList[index!].BATCH_NO ?? ""))
                                ]),
                                DataRow(cells: [
                                  DataCell(Center(child: Label("Finish Date"))),
                                  DataCell(
                                      Label(wdsList[index!].START_END ?? ""))
                                ]),
                                DataRow(cells: [
                                  DataCell(Center(child: Label("Element"))),
                                  DataCell(Label(wdsList[index!].ELEMENT ?? ""))
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
                      if (wdsList.isNotEmpty) {
                        _AlertDialog();
                        setState(() {});
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
          PostSendWindingFinishEvent(
            SendWdsFinishOutputModel(
              OPERATOR_NAME: int.tryParse(row.OPERATOR_NAME.toString()),
              BATCH_NO: int.tryParse(row.BATCH_NO.toString()),
              ELEMNT_QTY: int.tryParse(row.ELEMENT.toString()),
              FINISH_DATE: DateTime.now().toString(),
            ),
          ),
        );
      }
    } else if (allRowIndex != null) {
      for (var row in wdsList) {
        BlocProvider.of<LineElementBloc>(context).add(
          PostSendWindingFinishEvent(
            SendWdsFinishOutputModel(
              OPERATOR_NAME: int.tryParse(row.OPERATOR_NAME.toString()),
              BATCH_NO: int.tryParse(row.BATCH_NO.toString()),
              ELEMNT_QTY: int.tryParse(row.ELEMENT.toString()),
              FINISH_DATE: DateTime.now().toString(),
            ),
          ),
        );
      }
    } else {}
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
          _employees.add(
            DataGridRow(
              cells: [
                // DataGridCell<String>(
                //     columnName: 'operatorName', value: _item.OPERATOR_NAME),
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
